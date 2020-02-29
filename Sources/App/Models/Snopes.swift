//
//  Snopes.swift
//  App
//
//  Created by Kenny on 2/29/20.
//

import Foundation

struct Snopes: Article, Codable, Equatable {
    let articleDate: String //<li class="date breadcrumb-item">14 January 2020</li>
    let articleUrl: String //<a class="media post-230824 fact_check type-fact_check status-publish has-post-thumbnail hentry tag-alexa tag-memes fact_check_category-technology fact_check_rating-mixture" href="https://www.snopes.com/fact-check/alexa-cpr/">
    let headline: String
    let articleText: String //need to chain from articleUrl
    let articleImageUrl: String //733w,https://www.snopes.com/tachyon/2020/01/GettyImages-1185415382-e1579042787985.jpg?resize=865,452&amp;quality=65
    let ruling: String //need to chain from articleUrl
}
