//
//  CheckThatFactScraperUnitTests.swift
//  CheckThatFactScraperUnitTests
//
//  Created by Kenny on 2/29/20.
//

import XCTest
@testable import App

struct MockDataLoader: NetworkDataLoader {
    let data: Data?
    let error: Error?
    
    func loadData(from request: URLRequest, completion: @escaping (Data?, Error?) -> Void) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            completion(self.data, self.error)
        }
    }
    
    func loadData(from url: URL, completion: @escaping (Data?, Error?) -> Void) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            completion(self.data, self.error)
        }
    }
}


