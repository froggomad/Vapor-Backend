import Vapor

/// Called after your application has initialized.
public func boot(_ app: Application) throws {
    let scraper = Scraper.instance
    scraper.getHTMLString(url: scraper.snopesBaseURL) { (result) in
        guard let result = result else {
            NSLog("\(NSError(domain: "bootScraper", code: 400, userInfo: ["Boot Error":"Invalid Result from scraper"]))")
            return
        }
        scraper.scrapeSnopes(htmlString: result) { snopes in
            if let snopes = snopes {
                print("scraping started\n")
                var snopesCopy = snopes
                snopesCopy = snopes.sorted(by: {$0.articleDate > $1.articleDate}) //this isn't chronological, but numerical by the first digit because we're sorting a String and not a Date
                for snopesArticle in snopesCopy {
                    print(snopesArticle.articleDate)
                    print(snopesArticle.headline)
                    print(snopesArticle.ruling) //unwrapped at assignment
                    print()
                }
                print("scraping complete")
            }
        }
    }
    scraper.getHTMLString(url: scraper.factcheckOrgBaseUrl) { (htmlString) in
        guard let htmlString = htmlString else {
            NSLog(
                """
                Error getting factcheckorg html: \(#file), \(#function), \(#line)
                """)
            return
        }
        scraper.scrapeFactCheckOrg(htmlString: htmlString) { articles in
            guard let articles = articles else {
                NSLog(
                    """
                    Error scraping articles: \(#file), \(#function), \(#line)
                    """)
                return
            }
            var articlesCopy = articles
            articlesCopy = articles.sorted(by: {$0.articleDate > $1.articleDate}) //this isn't chronological, but alphabetical
            for factcheckArticle in articlesCopy {
                print(factcheckArticle.articleDate)
                print(factcheckArticle.headline)
                print()
            }
        }
    }
}
