//
//  DatabaseService.swift
//  App
//
//  Created by Kenny on 2/29/20.
//

import Foundation

class DatabaseService {
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
        URLSession.shared.dataTask(with: snopesRequest) { (_, response, error) in
            if let error = error {
                complete(error)
                return
            }
            complete(nil)
        }.resume()
    }
}
