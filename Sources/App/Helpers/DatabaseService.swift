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
    var allFirebaseResults: [Article] = []
    typealias complete = (Error?) -> Void
    
    //=======================
    // MARK: - Create/Update
    func put(article: Article,
             to url: URL,
             complete: @escaping complete = {_ in }) {
        guard var request = NetworkService.createRequest(url: url,
                                                         method: .put,
                                                         headerType: .contentType,
                                                         headerValue: .json) else { return }

        encodeArticle(article: article,
                      request: &request) { error in
            if let error = error {
                print("error encoding Article\(article): ", error)
            } else {
                NSLog("Article: \(article) saved to Firebase")
                complete(nil)
            }
        }
    }
}

private func encodeArticle<T: Encodable>(article: T,
                                         request: inout URLRequest,
                                         complete: @escaping complete = {_ in }) {
    let articleData = NetworkService.encode(from: article,
                                           request: &request)
    guard let articleRequest = articleData.request else { return }
    URLSession.shared.dataTask(with: articleRequest) { (_, _, error) in
        if let error = error {
            complete(error)
            return
        }
        complete(nil)
    }.resume()
}


func updateArticles(articles: [Article]) {
    let scraper = Scraper.instance
    var articles: [Article] = []
    self.fetchArticlesFromFirebase { error in
        articles = self.allFirebaseResults
        let articlesToCompare = scraper.snopesArray.filter { //count is 3 fromSnopes
            !articles.contains($0) //count should be 2
        }

        let existingHeadlines = articles.map { $0.headline }
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
            for (index, snopesArticle) in articles.enumerated() {
                if updatedArticle.headline == snopesArticle.headline {
                    articles[index].articleDate = updatedArticle.articleDate
                    articles[index].articleImageUrl = updatedArticle.articleImageUrl
                    articles[index].articleText = updatedArticle.articleText
                    articles[index].articleUrl = updatedArticle.articleUrl
                    articles[index].ruling = updatedArticle.ruling
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
                self.allFirebaseResults = dict.map {$1}
                complete(nil)
            } catch {
                print(error)
                complete(error)
            }
        }
    }.resume()
}
