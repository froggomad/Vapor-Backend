//
//  Article.swift
//  App
//
//  Created by Kenny on 2/29/20.
//

import Foundation

protocol Article: Codable {
    var articleDate: String {get}
    var articleUrl: String {get}
    var headline: String {get}
    var articleText: String {get}
    var articleImageUrl: String {get}
}
