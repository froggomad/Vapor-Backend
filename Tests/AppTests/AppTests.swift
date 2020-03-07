@testable import App
import XCTest
import Foundation

final class AppTests: XCTestCase {
    
    func testSnopesFirebaseUrlConstruction() {
        let testURL = TestData.baseFirebaseURL.appendingPathComponent("snopes")
            .appendingPathExtension("json")
        XCTAssertEqual(testURL, TestData.goodSnopesFirebaseURL)
    }
    
    func testSnopesEncodeRequest() {
        let request = NetworkService.createRequest(url: URL(string: "https://check-that-fact.firebaseio.com/snopes.json"),
                                                   method: .put,
                                                   headerType: .contentType,
                                                   headerValue: .json)
        
        XCTAssertEqual(request!.url, TestData.goodSnopesFirebaseURL)
        XCTAssertEqual(request?.httpMethod, "PUT")
        XCTAssertEqual(request!.allHTTPHeaderFields!["Content-Type"],"application/json")
    }
    
    func testSnopesEncode() {
        let snopesEncoded = NetworkService.encode(from: TestData.mockSnopesArticle, request: &TestData.snopesPutRequest!)
        XCTAssertNotNil(snopesEncoded.request)
        XCTAssertNil(snopesEncoded.error)
    }
    
    func testSnopesDecodeRequest() {
        let request = NetworkService.createRequest(url: URL(string: "https://check-that-fact.firebaseio.com/snopes.json"),
                                                   method: .get,
                                                   headerType: .contentType,
                                                   headerValue: .json)
        XCTAssertEqual(request!.url, TestData.goodSnopesFirebaseURL)
        XCTAssertEqual(request?.httpMethod, "GET")
        XCTAssertEqual(request!.allHTTPHeaderFields!["Content-Type"],"application/json")
    }
    
    func testSnopesDecode() {
        let snopesDecoded = try? NetworkService.decode(to: Snopes.self, data: TestData.goodJSONData)
        XCTAssertNotNil(snopesDecoded)
        XCTAssertEqual(snopesDecoded, TestData.mockSnopesArticle)
    }
    
    func testBadSnopesDecode() {
        let snopesGarbage = try? NetworkService.decode(to: Snopes.self, data: TestData.badJSONData)
        XCTAssertNil(snopesGarbage)
    }
    
    func testSnopesArticleUpdateStrategy() {
        var snopesArticles = TestData.articlesFromServer //count is 2
        let articlesToCompare = TestData.articlesFromSnopes.filter { //count is 3 fromSnopes
            !snopesArticles.contains($0) //count should be 2
        }
        
        let existingHeadlines = snopesArticles.map { $0.headline }
        let articlesToUpdate = articlesToCompare.filter {
            if existingHeadlines.contains($0.headline) {
                return true
            }
            snopesArticles.append($0)
            return false
        }
        
        for updatedArticle in articlesToUpdate {
            for (index, article) in snopesArticles.enumerated() {
                if updatedArticle.headline == article.headline {
                    snopesArticles[index].articleDate = updatedArticle.articleDate
                    snopesArticles[index].articleImageUrl = updatedArticle.articleImageUrl
                    snopesArticles[index].articleText = updatedArticle.articleText
                    snopesArticles[index].articleUrl = updatedArticle.articleUrl
                    snopesArticles[index].ruling = updatedArticle.ruling
                }
            }
        }
        XCTAssertEqual(snopesArticles.count, 3) //nothing should have been appended
        XCTAssertEqual(articlesToCompare.count, 2) //1 article from Snopes is different from the articles on the server
        XCTAssertEqual(articlesToUpdate.count, 1) //this should differ from articlesToCompare if there were articles to add - there are none to add in this example
    }
}
