//
//  FactcheckOrgArticle.swift
//  App
//
//  Created by Kenny on 4/12/20.
//

import Foundation

struct FactcheckOrgArticle: Article, Codable, Equatable {
    var articleDate: String
    var articleUrl: String
    var headline: String
    var articleText: String
    var articleImageUrl: String
}
