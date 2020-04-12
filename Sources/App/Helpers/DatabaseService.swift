//
//  DatabaseService.swift
//  App
//
//  Created by Kenny on 2/29/20.
//

import Foundation

class DatabaseService {
    //=======================
    // MARK: - Properties
    let dbURL = URL(string: "https://check-that-fact.firebaseio.com")!
    var firebaseSnopesResults: [Snopes] = []
    typealias complete = (Error?) -> Void
    
    //=======================
    // MARK: - Create/Update
    func put(article: Article, to url: URL, complete: @escaping complete = {_ in }) {
        guard var request = NetworkService.createRequest(url: url, method: .put, headerType: .contentType, headerValue: .json) else { return }
        if let snopesArticle = article as? Snopes {
            encodeSnopesArticle(snopesArticle: snopesArticle, request: &request) { error in
                if let error = error {
                    print("error encoding Snopes Article\(snopesArticle): ", error)
                }
            }
        } else {
            
        }
        //success
        complete(nil)
    }
    
    private func encodeSnopesArticle(snopesArticle: Snopes, request: inout URLRequest, complete: @escaping complete = {_ in }) {
        let snopesData = NetworkService.encode(from: snopesArticle, request: &request)
        guard let snopesRequest = snopesData.request else { return }
        URLSession.shared.dataTask(with: snopesRequest) { (_, _, error) in
            if let error = error {
                complete(error)
                return
            }
            complete(nil)
        }.resume()
    }
    
    
    func updateArticles(articles: [Article]) {
        let scraper = Scraper.instance
        var snopesArticles: [Snopes] = []
        self.fetchArticlesFromFirebase { error in
            snopesArticles = self.firebaseSnopesResults
            let articlesToCompare = scraper.snopesArray.filter { //count is 3 fromSnopes
                !snopesArticles.contains($0) //count should be 2
            }
            
            let existingHeadlines = snopesArticles.map { $0.headline }
            let articlesToUpdate = articlesToCompare.filter {
                if existingHeadlines.contains($0.headline) {
                    return true
                }
                let firebaseArticleURL = DatabaseService().dbURL.appendingPathComponent("Snopes")
                    .appendingPathComponent($0.headline)
                    .appendingPathExtension("json")
                self.put(article: $0, to: firebaseArticleURL)
                return false
            }
            
            for updatedArticle in articlesToUpdate {
                for (index, snopesArticle) in snopesArticles.enumerated() {
                    if updatedArticle.headline == snopesArticle.headline {
                        snopesArticles[index].articleDate = updatedArticle.articleDate
                        snopesArticles[index].articleImageUrl = updatedArticle.articleImageUrl
                        snopesArticles[index].articleText = updatedArticle.articleText
                        snopesArticles[index].articleUrl = updatedArticle.articleUrl
                        snopesArticles[index].ruling = updatedArticle.ruling
                        let firebaseArticleURL = DatabaseService().dbURL.appendingPathComponent("Snopes")
                            .appendingPathComponent(updatedArticle.headline)
                            .appendingPathExtension("json")
                        self.put(article: updatedArticle, to: firebaseArticleURL)
                    }
                }
            }
        }
        
    }
    
    //=======================
    // MARK: - Read
    func fetchArticlesFromFirebase<T: Decodable>(endpoint: Endpoint,
                                   complete: @escaping complete = {_ in }) {
        let url = dbURL.appendingPathComponent(endpoint.rawValue)
        guard let decodingRequest = NetworkService.createRequest(url: url,
                                                                 method: .get,
                                                                 headerType: .contentType,
                                                                 headerValue: .json) else { return }
        URLSession.shared.dataTask(with: decodingRequest) { (data, _, error) in
            if let error = error {
                complete(error)
                return
            }
            if let data = data {
                do {
                    let dict = try NetworkService.decode(to: [String:T].self, data: data)
                    self.firebaseSnopesResults = dict.map {$1}
                    complete(nil)
                } catch {
                    print(error)
                    complete(error)
                }
            }
        }.resume()
    }
}
