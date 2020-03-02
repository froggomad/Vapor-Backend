//
//  NetworkDataLoader+loadData.swift
//  App
//
//  Created by Kenny on 2/29/20.
//

import Foundation

import Foundation

extension URLSession: NetworkDataLoader {
    func loadData(from url: URL, completion: @escaping (Data?, Error?) -> Void) {
        
    }
    
    func loadData(from request: URLRequest, completion: @escaping (Data?, Error?) -> Void) {
        self.dataTask(with: request) { (data, response, error) in
            completion(data, error)
        }.resume()
    }
}
