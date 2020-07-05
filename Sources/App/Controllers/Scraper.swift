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
    let snopesBaseURL = URL(string: "https://www.snopes.com/fact-check/")!
    let factcheckOrgBaseUrl = URL(string: "https://www.factcheck.org/the-factcheck-wire/")!
    var snopesArray = [Snopes]()
    
    var _snopesArray: [Snopes] {
        getHTMLString(url: snopesBaseURL) { (articlesHTML) in
            guard let articlesHTML = articlesHTML else { return }
            self.scrapeSnopes(htmlString: articlesHTML) { (result) in
                guard let result = result else { return }
                self.snopesArray = result
            }
        }
        return snopesArray
    }

    var factCheckOrgArray = [FactcheckOrgArticle]()
    var _factCheckOrgArray: [FactcheckOrgArticle] {
        getHTMLString(url: factcheckOrgBaseUrl) { (articlesHTML) in
            guard let articlesHTML = articlesHTML else { return }
            self.scrapeFactCheckOrg(htmlString: articlesHTML) { (result) in
                guard let result = result else { return }
                self.factCheckOrgArray = result
            }
        }
        return factCheckOrgArray //this will probably only be updated every other run
    }
    
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
            guard let articleUrl = unwrapAndParseHtmlString(htmlString: article,
                                                            leftSideString: leftSideArticleUrl,
                                                            rightSideString: rightSideArticleUrl,
                                                            searchString: articleUrlSearchString) else {
                let error = NSError(domain: "scraper.scrapeSnopes.articleUrl",
                code: 404,
                userInfo: ["articleUrl":"nil"])
                NSLog("\(error)")
                return
            }
            
            //construct Headline
            let leftSideHeadline = "<h5 class=\"title\">"
            let rightSideHeadline = "</h5>"
            let articleHeadline = unwrapAndParseHtmlString(htmlString: article,
                                                           leftSideString: leftSideHeadline,
                                                           rightSideString: rightSideHeadline)
            
            //construct ArticleImageUrl
            let leftSideArticleImageUrl = "data-lazy-src=\""
            let rightSideArticleImageUrl = "\""
            let articleImageUrl = unwrapAndParseHtmlString(htmlString: article,
                                                           leftSideString: leftSideArticleImageUrl,
                                                           rightSideString: rightSideArticleImageUrl)
            
            //construct ArticleDate
            let leftSideArticleDate = "<li class=\"date breadcrumb-item\">"
            let rightSideArticleDate = "</li>"
            let articleDate = unwrapAndParseHtmlString(htmlString: article,
                                                       leftSideString: leftSideArticleDate,
                                                       rightSideString: rightSideArticleDate)?.components(separatedBy: "\t").last
            
            //construct articleText - need to chain from articleUrl
            var articleText: String?
            guard let inputURL = URL(string: articleUrl) else {
                let error = NSError(domain: "scraper.scrapeSnopes.articleUrl",
                code: 404,
                userInfo: ["articleUrl":"invalid URL"])
                NSLog("\(error)")
                return
            }
            getHTMLString(url: inputURL) { (htmlString) in
                guard let htmlString = htmlString else {
                    let error = NSError(domain: "scraper.scrapeSnopes.getHTMLString_begin",
                    code: 404,
                    userInfo: ["getHTMLString incoming":"nil"])
                    NSLog("\(error)")
                    return
                }
                let leftSideArticleText = "<main class=\"base-main\" role=\"main\">"
                let rightSideArticleText = "<footer>"
                articleText = self.unwrapAndParseHtmlString(htmlString: htmlString,
                                                            leftSideString: leftSideArticleText,
                                                            rightSideString: rightSideArticleText,
                                                            searchString: nil)
                
                //construct articleRuling - need to chain from articleText
                guard let articleText = articleText else {
                    let error = NSError(domain: "scraper.scrapeSnopes.getHTMLString",
                    code: 404,
                    userInfo: ["articleRuling":"articleText is nil"])
                    NSLog("\(error)")
                    return
                }
                let leftSideArticleRuling = "class=\"rating-label-"
                let rightSideArticleRuling = "\">"
                let articleRuling = self.unwrapAndParseHtmlString(htmlString: articleText,
                                                                  leftSideString: leftSideArticleRuling,
                                                                  rightSideString: rightSideArticleRuling) ?? "Unknown"
                
                guard var articleDate = articleDate,
                    let articleHeadline = articleHeadline,
                    let articleImageUrl = articleImageUrl
                else {
                    let error = NSError(domain: "scraper.scrapeSnopes.getHTMLString_end",
                                        code: 404,
                                        userInfo: ["final variables":"one or more required variables is nil"])
                    NSLog("\(error)")
                    return
                }
                articleDate = articleDate.components(separatedBy: "\t").last!
                
                let snopes = Snopes(articleDate: articleDate,
                                    articleUrl: articleUrl, headline: articleHeadline,
                                    articleText: articleText,
                                    articleImageUrl: articleImageUrl,
                                    ruling: articleRuling)
                var duplicates = 0
                if !self.snopesArray.contains(snopes) {
                    self.snopesArray.append(snopes)
                } else {
                    duplicates += 1
                }
                //don't complete until the array is filled
                if self.snopesArray.count == articleArray.count - duplicates - 1 { //garbage in first position
                    let service = DatabaseService()
                    service.updateArticles(articles: self.snopesArray)
                    complete(self.snopesArray)
                }
            }
        }

    }

    func scrapeFactCheckOrg(htmlString: String,
                            complete: @escaping ([FactcheckOrgArticle]?) -> ()) {
        var articleArray = htmlString.components(separatedBy: "<article class=\"post-")
        articleArray.removeFirst()
        //construct article
        for article in articleArray {
            let leftSideArticle = "type-post"
            let rightSideArticle = "</article>"
            guard let articleSearchElement = self.unwrapAndParseHtmlString(htmlString: article,
                                                                           leftSideString: leftSideArticle,
                                                                           rightSideString: rightSideArticle)
                else { return }

            //get date
            let leftSideDate = "<div class=\"entry-meta\">"
            let rightSideDate = "</div>"
            let date = self.unwrapAndParseHtmlString(htmlString: articleSearchElement,
                                                     leftSideString: leftSideDate,
                                                     rightSideString: rightSideDate)
            //get headline
            let leftSideHeadline = "<h3 class=\"entry-title\">"
            let rightSideHeadline = "</a>"
            let headlineSearchString = "rel=\"bookmark\">"
            let headline = self.unwrapAndParseHtmlString(htmlString: articleSearchElement,
                                                         leftSideString: leftSideHeadline,
                                                         rightSideString: rightSideHeadline,
                                                         searchString: headlineSearchString)
            //get image
            let leftSideImage = "archive-post-thumbnail\"><img width=\""
            let rightSideImage = "\" class=\"attachment-thumbnail"
            let imageSearchString = "src=\""
            let image = self.unwrapAndParseHtmlString(htmlString: articleSearchElement,
                                                      leftSideString: leftSideImage,
                                                      rightSideString: rightSideImage,
                                                      searchString: imageSearchString)

            //get articleUrl
            let leftSideArticleUrl = "<h3 class=\"entry-title\">"
            let rightSideArticleUrl = "\" rel=\"bookmark\">"
            let articleUrlSearchString = "<a href=\""
            guard let articleUrl = self.unwrapAndParseHtmlString(htmlString: articleSearchElement,
                                                                 leftSideString: leftSideArticleUrl,
                                                                 rightSideString: rightSideArticleUrl,
                                                                 searchString: articleUrlSearchString)
                else {
                    let error = NSError(domain: "scraper.scrapeFactcheckOrg.articleUrl",
                                        code: 404,
                                        userInfo: ["articleUrl":"invalid URL"])
                    NSLog(
                        """
                        Error articleUrl is nil: \(#file), \(#function), \(#line) -
                        \(error)
                        """)
                    return
            }

            //get articleText
            var text: String?
            guard let inputURL = URL(string: articleUrl) else {
                let error = NSError(domain: "scraper.scrapeFactcheckOrg.articleUrl",
                                    code: 404,
                                    userInfo: ["articleUrl":"invalid URL"])
                NSLog("\(error)")
                return
            }
            self.getHTMLString(url: inputURL) { (htmlString) in
                guard let htmlString = htmlString else {
                    let error = NSError(domain: "scraper.scrapeFactcheckOrg.getHTMLString_begin",
                                        code: 404,
                                        userInfo: ["getHTMLString incoming":"nil"])
                    NSLog("\(error)")
                    return
                }
                let leftSideArticleText = "<div class=\"wrapper\" id=\"single-wrapper\">"
                let rightSideArticleText = "<div class=\"wrapper\" id=\"wrapper-footer\">"
                text = self.unwrapAndParseHtmlString(htmlString: htmlString,
                                                     leftSideString: leftSideArticleText,
                                                     rightSideString: rightSideArticleText,
                                                     searchString: nil)
                guard let articleDate = date,
                    let articleHeadline = headline,
                    let articleText = text,
                    let articleImage = image
                    else { return }
                let factcheckArticle = FactcheckOrgArticle(articleDate: articleDate,
                                                           articleUrl: articleUrl,
                                                           headline: articleHeadline,
                                                           articleText: articleText,
                                                           articleImageUrl: articleImage)
                var duplicates = 0
                if !self.factCheckOrgArray.contains(factcheckArticle) {
                    self.factCheckOrgArray.append(factcheckArticle)
                } else {
                    duplicates += 1
                }
                //don't complete until the array is filled
                if self.factCheckOrgArray.count == articleArray.count - duplicates {
                    complete(self.factCheckOrgArray)
                } else {
                    print("Bad count:\n","factcheckorg count:", self.factCheckOrgArray.count, "article count:", articleArray.count)
                }
            }
            complete(nil)
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
    private func unwrapAndParseHtmlString(htmlString: String,
                                          leftSideString: String,
                                          rightSideString: String,
                                          searchString: String? = nil) -> String? {
        let contentArray = htmlString.components(separatedBy: leftSideString)
        if contentArray.count > 1 {
            let resultContent = contentArray[1].components(separatedBy: rightSideString)
            guard let searchString = searchString else {
                return resultContent[0].trimmingCharacters(in: .whitespaces)
            }
            let result = resultContent[0].components(separatedBy: searchString)
            return result[1].trimmingCharacters(in: .whitespaces)
        }
        let error = NSError(domain: "scraper.unwrapAndParseHtmlString",
                            code: 404,
                            userInfo: ["htmlString.components":"unable to separate by \(leftSideString)"])
        NSLog("\(error)")
        return nil
    }
    
    /**
        Returns utf8 encoded String from html data for parsing
     */
    func getHTMLString(url: URL,
                       complete: @escaping (_: String?) -> ()) {
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            if let error = error {
                print("Error retrieving html string from \(url): \(String(describing: error))")
                complete(nil)
                return
            }
          guard let data = data else {
            let error = NSError(domain: "scraper.getHTMLString",
                                code: 404,
                                userInfo: ["incoming data":"nil"])
            NSLog("\(error)")
            complete(nil)
            return
          }
          guard let htmlString = String(data: data,
                                        encoding: .utf8) else {
            let error = NSError(domain: "scraper.getHTMLString",
                                code: 404,
                                userInfo: ["htmlString":"Failure encoding to .utf8"])
            NSLog("\(error)")
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
                    let error = NSError(domain: "scraper.JSONOutput",
                                        code: 404,
                                        userInfo: ["articleRuling":"articleText is nil"])
                    NSLog("\(error)")
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
            print("Error encoding Snopes object into JSON \(error)")
            return Data()
        }
    }
    

}

