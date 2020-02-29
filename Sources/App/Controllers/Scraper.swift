//
//  Scraper.swift
//  App
//
//  Created by Kenny on 2/29/20.
//

import Foundation

class Scraper {
    //=======================
    // MARK: - Properties
    static let instance = Scraper()
    let dbURL = URL(string: "https://check-that-fact.firebaseio.com")!
    let snopesBaseURL = URL(string: "https://www.snopes.com/fact-check/")!
    var snopesArray = [Snopes]()
    
    //=======================
    // MARK: - Snopes
    func scrapeSnopes(htmlString: String, complete: @escaping ([Snopes]?) -> ()) {
        //construct articleUrl - ref: <a class="media post-230824 fact_check type-fact_check status-publish has-post-thumbnail hentry tag-alexa tag-memes fact_check_category-technology fact_check_rating-mixture" href="https://www.snopes.com/fact-check/alexa-cpr/">
        var articleArray = htmlString.components(separatedBy: "<a class=\"media post-")
        articleArray.removeFirst()
        for article in articleArray {
            let leftSideArticleUrl = "fact_check type-"
            let rightSideArticleUrl = "/\">"
            let articleUrlSearchString = "href=\""
            guard let articleUrl = unwrapAndParseHtmlString(htmlString: article, leftSideString: leftSideArticleUrl, rightSideString: rightSideArticleUrl, searchString: articleUrlSearchString) else {
                NSLog("\(NSError(domain: "scraper.scrapeSnopes.articleUrl", code: 404, userInfo: ["articleUrl":"nil"]))")
                return
            }
            
            //construct Headline
            let leftSideHeadline = "<h5 class=\"title\">"
            let rightSideHeadline = "</h5>"
            let articleHeadline = unwrapAndParseHtmlString(htmlString: article, leftSideString: leftSideHeadline, rightSideString: rightSideHeadline)
            
            //construct ArticleImageUrl
            let leftSideArticleImageUrl = "data-lazy-src=\""
            let rightSideArticleImageUrl = "\""
            let articleImageUrl = unwrapAndParseHtmlString(htmlString: article, leftSideString: leftSideArticleImageUrl, rightSideString: rightSideArticleImageUrl)
            
            //construct ArticleDate
            let leftSideArticleDate = "<li class=\"date breadcrumb-item\">"
            let rightSideArticleDate = "</li>"
            let articleDate = unwrapAndParseHtmlString(htmlString: article, leftSideString: leftSideArticleDate, rightSideString: rightSideArticleDate)?.components(separatedBy: "\t").last
            
            //construct articleText - need to chain from articleUrl
            var articleText: String?
            guard let inputURL = URL(string: articleUrl) else {
                NSLog("\(NSError(domain: "scraper.scrapeSnopes.articleUrl", code: 404, userInfo: ["articleUrl":"invalid URL"]))")
                return
            }
            getHTMLString(url: inputURL) { (htmlString) in
                guard let htmlString = htmlString else {
                    NSLog("\(NSError(domain: "scraper.scrapeSnopes.getHTMLString_begin", code: 404, userInfo: ["getHTMLString incoming":"nil"]))")
                    return
                }
                let leftSideArticleText = "<main class=\"base-main\" role=\"main\">"
                let rightSideArticleText = "<footer>"
                articleText = self.unwrapAndParseHtmlString(htmlString: htmlString, leftSideString: leftSideArticleText, rightSideString: rightSideArticleText, searchString: nil)
                
                //construct articleRuling - need to chain from articleText
                guard let articleText = articleText else {
                    NSLog("\(NSError(domain: "scraper.scrapeSnopes.getHTMLString", code: 404, userInfo: ["articleRuling":"articleText is nil"]))")
                    return
                }
                let leftSideArticleRuling = "class=\"rating-label-"
                let rightSideArticleRuling = "\">"
                let articleRuling = self.unwrapAndParseHtmlString(htmlString: articleText, leftSideString: leftSideArticleRuling, rightSideString: rightSideArticleRuling) ?? "Unknown"
                
                guard var articleDate = articleDate,
                    let articleHeadline = articleHeadline,
                    let articleImageUrl = articleImageUrl
                else {
                    NSLog("\(NSError(domain: "scraper.scrapeSnopes.getHTMLString_end", code: 404, userInfo: ["final variables":"one or more required variables is nil"]))")
                    return
                }
                articleDate = articleDate.components(separatedBy: "\t").last!
                
                let snopes = Snopes(articleDate: articleDate, articleUrl: articleUrl, headline: articleHeadline, articleText: articleText, articleImageUrl: articleImageUrl, ruling: articleRuling)
                if !self.snopesArray.contains(snopes) {
                    self.snopesArray.append(snopes)
                }
                //don't complete until the array is filled
                if self.snopesArray.count == articleArray.count - 1 { //garbage in first position
                    complete(self.snopesArray)
                }
                let service = DatabaseService()
                let jsonURL = self.dbURL.appendingPathComponent("Snopes")
                    .appendingPathComponent(UUID().uuidString)
                    .appendingPathExtension("json")
                for article in self.snopesArray {
                    service.put(article: article, to: jsonURL)
                }
            }
        }
    }
    
    //=======================
    // MARK: - Parse
    /**
        Given 2 or 3 terms, parses html from a String.
     
        If there are characters between your leftSideString and your rightSideString, include the unique characters just before the desired result in the searchString parameter
        - parameter htmlString: The HTML to parse
        - parameter leftSideString: The beginning of the string you're searching for a dynamic value in (i.e. "<a") - this should NOT include part of the term you want returned
        - parameter rightSideString: The end of the string you're searching for a dynamic value in (i.e."/\\">") - this should NOT include part of the term you want returned
        - parameter searchString: Find the text between this and the rightSideString (i.e. "href=\") - this should NOT include part of the term you want returned
     */
    private func unwrapAndParseHtmlString(htmlString: String, leftSideString: String, rightSideString: String, searchString: String? = nil) -> String? {
        let contentArray = htmlString.components(separatedBy: leftSideString)
        if contentArray.count > 1 {
            let resultContent = contentArray[1].components(separatedBy: rightSideString)
            guard let searchString = searchString else {return resultContent[0].trimmingCharacters(in: .whitespaces)}
            let result = resultContent[0].components(separatedBy: searchString)
            return result[1].trimmingCharacters(in: .whitespaces)
        }
        NSLog("\(NSError(domain: "scraper.unwrapAndParseHtmlString", code: 404, userInfo: ["htmlString.components":"unable to separate by \(leftSideString)"]))")
        return nil
    }
    
    /**
        Returns utf8 encoded String from html data for parsing
     */
    func getHTMLString(url: URL, complete: @escaping (_: String?) -> ()) {
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            if let error = error {
                print("Error retrieving html string from \(url): \(String(describing: error))")
                complete(nil)
                return
            }
          guard let data = data else {
            NSLog("\(NSError(domain: "scraper.getHTMLString", code: 404, userInfo: ["incoming data":"nil"]))")
            complete(nil)
            return
          }
          guard let htmlString = String(data: data, encoding: .utf8) else {
            NSLog("\(NSError(domain: "scraper.getHTMLString", code: 404, userInfo: ["htmlString":"Failure encoding to .utf8"]))")
            complete(nil)
            return
          }
          complete(htmlString)
        }.resume()
    }
    
    //=======================
    // MARK: - Helpers
    ///data formated for endpoint
    func JSONOutput() -> [String] {
        var returnArr = [String]()
        if !snopesArray.isEmpty {
            let lastIndex = snopesArray.endIndex
            for (index, snopes) in snopesArray.enumerated() {
                let data = encode(from: snopes)
                guard let dataToString = dataToString(data: data) else {
                    NSLog("\(NSError(domain: "scraper.JSONOutput", code: 404, userInfo: ["articleRuling":"articleText is nil"]))")
                    break
                }
                if index != lastIndex - 1 {
                    returnArr.append("\(dataToString), ")
                } else {
                    returnArr.append("\(dataToString)")
                }
            }
            
        } else {
            print("no scraped data")
            
        }
        return returnArr
    }
    
    private func dataToString(data: Data) -> String? {
        return String(decoding: data, as: UTF8.self)
    }
    
    
    private func encode(from type: Any?) -> Data {
        let jsonEncoder = JSONEncoder()
        do {
            switch type {
            case is Snopes:
               return try jsonEncoder.encode(type as? Snopes)
            default: fatalError("\(String(describing: type)) is not defined locally in encode function")
            }
        } catch {
            print("Error encoding User object into JSON \(error)")
            return Data()
        }
    }
    

}

