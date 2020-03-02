//
//  TestJSON.swift
//  App
//
//  Created by Kenny on 2/29/20.
//

import Foundation

enum TestData {
    //=======================
    // MARK: - JSON Data
    //NOTE, all "\" characters removed to avoid illegal escapes
    static let goodJSONData = """
        {
            "articleDate": "3/21/1980",
            "articleUrl": "http://kennydubroff.com",
            "headline": "A star is born",
            "articleText": "Yuk yuk",
            "articleImageUrl": "http://kennydubroff.com/images/kenny.jpg",
            "ruling": "true"
        }
    """.data(using: .utf8)!


    static let badJSONData = """
    {
        {
            "headline": "No, Quaden Bayles Did Not Commit Suicide",
            "articleText": "nnttttttn<script type="application/ld+json">{"@context":"http://schema.org","@type":"WebPage","name":"No, Quaden Bayles Did Not Commit Suicide","description":"Hoax social media posts attempted to lure clicks from unsuspecting users with yet another false report about a bullied boy."}</script>nn<script type="application/ld+json">{"@context":"http://schema.org","@type":"Article","headline":"No, Quaden Bayles Did Not Commit Suicide","image":"https://www.snopes.com/uploads/2020/02/quaden_image.jpg","description":"Hoax social media posts attempted to lure clicks from unsuspecting users with yet another false report about a bullied boy.","mainEntityOfPage":"https://www.snopes.com/fact-check/quaden-bayles-suicide-hoax/","author":{"@type":"Organization","name":"Snopes","url":"https://www.snopes.com","logo":"https://www.snopes.com/content/themes/snopes/dist/images/logo-main.png","sameAs":["https://twitter.com/snopes","https://www.facebook.com/snopes/","https://www.linkedin.com/company/snopes.com"]},"publisher":{"@type":"Organization","name":"Snopes","url":"https://www.snopes.com","logo":"https://www.snopes.com/content/themes/snopes/dist/images/logo-main.png","sameAs":["https://twitter.com/snopes","https://www.facebook.com/snopes/","https://www.linkedin.com/company/snopes.com"]},"datePublished":"2020-02-29T15:47:00+00:00"}</script>nn<article class="snopes-post post-238398 fact_check type-fact_check status-publish has-post-thumbnail hentry fact_check_category-junk-news fact_check_rating-false">nnt<div class="header-wrapper card">nt<div class="card-header">ntnnt<nav class="breadcrumbs" aria-label="breadcrumb">ntt<ol class="breadcrumb">nttttttt<li class="breadcrumb-item">nttttt<antttttthref="https://www.snopes.com/"nttttttttttt>nttttttHomettttt</a>ntttt</li>ntttttttt<li class="breadcrumb-item">nttttt<antttttthref="https://www.snopes.com/fact-check/"nttttttttttt>nttttttFact Checksttttt</a>ntttt</li>ntttttttt<li class="breadcrumb-item">nttttt<antttttthref="https://www.snopes.com/fact-check/category/junk-news/"nttttttttttt>nttttttJunk Newsttttt</a>ntttt</li>ntttttttt<li class="breadcrumb-item">nttttt<antttttthref="https://www.snopes.com/fact-check/quaden-bayles-suicide-hoax/"nttttttaria-current="page"ttttt>nttttttNo, Quaden Bayles Did Not Commit Suicidettttt</a>ntttt</li>ntttttt</ol>nt</nav>nnt</div>nnt<header class="post-header">nttn<h1 class="title">No, Quaden Bayles Did Not Commit Suicide</h1>nnt<h2 class="subtitle">Hoax social media posts attempted to lure clicks from unsuspecting users with yet another false report about a bullied boy.</h2>nnn<div class="authors-wrapper">nnt<ul class="authors">nnttttt<li>nttttttttt<a class="author" href="https://www.snopes.com/author/snopes/">David Mikkelson</a>nttttttt</li>nttnt</ul>nn</div>nn<div class="dates-wrapper">nnt<ul class="dates">nnttttt<li class="date-item">ntttt<span class="label">Published</span>ntttt<span class="date date-published">29 February 2020</span>nttt</li>nttnttnt</ul>nn</div>nt</header>nntnntntnttntt<div class="featured-media-wrapper featured-image">nnttt<figure class="featured-media">nnttttnttttt<div class="image-wrapper">ntttttt<imgntttttttsrc="https://www.snopes.com/content/themes/snopes/dist/images/lazyload-placeholder.png"ntttttttdata-lazy-src="https://www.snopes.com/tachyon/2020/02/quaden_image.jpg?resize=865,452"ntttttttdata-lazy-srcset="https://www.snopes.com/tachyon/2020/02/quaden_image.jpg?resize=80,80&amp;quality=65 80w,https://www.snopes.com/tachyon/2020/02/quaden_image.jpg?resize=180,180&amp;quality=65 180w,https://www.snopes.com/tachyon/2020/02/quaden_image.jpg?resize=375,211&amp;quality=65 375w,https://www.snopes.com/tachyon/2020/02/quaden_image.jpg?resize=416,234&amp;quality=65 416w,https://www.snopes.com/tachyon/2020/02/quaden_image.jpg?resize=542,305&amp;quality=65 542w,https://www.snopes.com/tachyon/2020/02/quaden_image.jpg?resize=733,412&amp;quality=65 733w,https://www.snopes.com/tachyon/2020/02/quaden_image.jpg?resize=865,452&amp;quality=65 865w,https://www.snopes.com/tachyon/2020/02/quaden_image.jpg?resize=1200,630&amp;quality=65 1200w"ntttttttdata-lazy-sizes="(min-width: 1136px) 810px, 100vw"ntttttttalt=""ntttttt>nttttt</div>tnnttttnttttnttttttttttt</figure>ntt</div>nnttntnntn<nav class="share-links social-buttons card-footer nav">nt<a class="nav-item btn-round socialShare-link" target="_blank" href="http://www.facebook.com/sharer.php?u=https%3A%2F%2Fwww.snopes.com%2Ffact-check%2Fquaden-bayles-suicide-hoax%2F"><i class="fab fa-facebook-f"></i></a>nt<a class="nav-item btn-round socialShare-link" target="_blank" href="https://twitter.com/intent/tweet?url=https%3A%2F%2Fwww.snopes.com%2Ffact-check%2Fquaden-bayles-suicide-hoax%2F&#038;text=No%2C%20Quaden%20Bayles%20Did%20Not%20Commit%20Suicide&#038;via=snopes&#038;hashtags="><i class="fab fa-twitter"></i></a>nt<a class="nav-item btn-round socialShare-link" target="_blank" href="http://pinterest.com/pin/create/button/?url=https%3A%2F%2Fwww.snopes.com%2Ffact-check%2Fquaden-bayles-suicide-hoax%2F"><i class="fab fa-pinterest"></i></a>nt<a class="nav-item btn-round socialShare-link" target="_blank" href="https://reddit.com/submit?url=https%3A%2F%2Fwww.snopes.com%2Ffact-check%2Fquaden-bayles-suicide-hoax%2F&#038;title=No%2C%20Quaden%20Bayles%20Did%20Not%20Commit%20Suicide"><i class="fab fa-reddit-alien"></i></a>nt<a class="nav-item btn-round socialShare-link" target="_blank" href="mailto:?subject=No%2C%20Quaden%20Bayles%20Did%20Not%20Commit%20Suicide&#038;body=https%3A%2F%2Fwww.snopes.com%2Ffact-check%2Fquaden-bayles-suicide-hoax%2F"><i class="fas fa-envelope"></i></a>n</nav>nn</div>nn<div id="smg-zone-main-after-feature" class="smg-zone smg-zone-main-after-feature"><div class="smg-zone-group smg-zone-group-monetized-main-after-feature"><div class="smg-zone-widget smg-zone-widget-ads-freestar  ">nt<div class="creative">ntt<divntttid="post-featured-1"ntttclass="post-featured"ntt>nttt<script data-cfasync="false" type="text/javascript">nttttfreestar.queue.push(function () { googletag.display('post-featured-1'); });nttt</script>ntt</div>nt</div>nn</div></div></div>ntntt<div class="claim-wrapper card">nnttt<h3 class="card-header">Claim</h3>nnttt<div class="claim">nntttt<p>The BBC reported in February 2020 that Quaden Bayles had committed suicide.</p>nnttttnttt</div>nntt</div>nnttnttnttt<div class="rating-wrapper card">nntttt<h3 class="card-header">Rating</h3>nntttt<div class="media-list">nnttttt<div class="media rating">nnttttttttttttt<figure>ntttttttt<a target="_blank" href="https://www.snopes.com/fact-check/rating/false/">nttttttttt<img class="" src="https://www.snopes.com/tachyon/2018/03/rating-false.png" alt=""/>ntttttttt</a>nttttttt</figure>nttttttntttttt<div class="media-body">nttttttt<h5 class="rating-label-false">False</h5>nttttttt<a class="rating-help-link" target="_blank" href="https://www.snopes.com/fact-check/rating/false/">About this rating <i class="fas fa-external-link-alt ml-1"></i></a>ntttttt</div>nnttttt</div>nntttttntttttntttttntttt</div>nnttt</div>nnttt<div id="smg-zone-main-after-rating" class="smg-zone smg-zone-main-after-rating"><div class="smg-zone-group smg-zone-group-group-single-fact-check-main-after-rating"><div class="smg-zone-widget smg-zone-widget-alerts-banners-general-support  "><a href="https://www.snopes.com/projects/founding-members/?utm_source=snopes-fact-check-rating-support-button&#038;utm_medium=native&#038;utm_campaign=fm2020&#038;utm_content=support-snopes" class="d-block w-100">nt<div class="banner-alert is-clickable has-caret has-caret-top-left bg-secondary">ntt<h4 class="banner-text">Do you rely on Snopes reporting? Become a member today.</h4>ntt<div class="banner-icon banner-icon-right">nttt<i class="fas fa-angle-right"></i>ntt</div>nt</div>n</a>n</div><div class="smg-zone-widget smg-zone-widget-ads-freestar  ">nt<div class="creative">ntt<divntttid="rating-1"ntttclass="rating"ntt>nttt<script data-cfasync="false" type="text/javascript">nttttfreestar.queue.push(function () { googletag.display('rating-1'); });nttt</script>ntt</div>nt</div>nn</div></div></div>nttntnt<div class="content-wrapper card">nnttttt<h3 class="card-header">Origin</h3>nttntt<div class="content">nttt<p>In February 2020, news reports circulated about a 9-year-old boy with dwarfism named Quaden Bayles who had received emotional and financial support from a number of celebrities and online do-gooders after he was bullied at school for being “ugly.” Comedian Brad Williams set up a GoFundMe <a href="https://www.thewrap.com/quaden-bayles-family-turns-down-disneyland-trip-will-donate-470000-to-charity/" target="_blank" rel="noopener noreferrer">campaign</a> for Quaden which quickly raised several hundred thousand dollars.</p>n<p>Quaden soon became the target of a scurrilous and <a href="https://www.snopes.com/fact-check/quaden-bayles-18-years-old/" target="fa" rel="noopener noreferrer">false rumor</a> that he was not a bullied child but rather an 18-year-old scammer who was promoting a false story to gather donations for personal gain.</p>n<p>Barely had that rumor begun to subside when more social media posts began to pop up claiming that Quaden had committed suicide, offering headlines such as “BuIIied KlD REC0RDED HlS SUlClDE — QUADEN.BAYLES’ Died by Suicide after Bullying Worsens at School — BBC NEWS EXCLUSIVE”</p>n<p><img src="https://www.snopes.com/content/themes/snopes/dist/images/lazyload-placeholder.png" alt class="aligncenter size-full wp-image-238400" style="border:2px solid black" data-lazy-src="https://www.snopes.com/tachyon/2020/02/quaden.jpg?resize=1164,648" data-lazy-srcset="https://www.snopes.com/tachyon/2020/02/quaden.jpg?w=1164 1164w, https://www.snopes.com/tachyon/2020/02/quaden.jpg?resize=768,428 768w" data-lazy-sizes="(max-width: 1164px) 100vw, 1164px" data-recalc-dims="1"><noscript><img src="https://www.snopes.com/tachyon/2020/02/quaden.jpg?resize=1164,648" alt="" class="aligncenter size-full wp-image-238400" style="border:2px solid black" srcset="https://www.snopes.com/tachyon/2020/02/quaden.jpg?w=1164 1164w, https://www.snopes.com/tachyon/2020/02/quaden.jpg?resize=768,428 768w" sizes="(max-width: 1164px) 100vw, 1164px" data-recalc-dims="1"></noscript></p>n<p>Quaden Bayles has not committed suicide, and what these posts linked to was neither the real BBC News website nor a genuine BBC News report.   These social media posts were hoaxes that sent readers who clicked through on them to landing pages on disreputable websites.  Users are advised to stay away from those sites by avoiding clicking on any web links related to this false report.</p>nn<div id="smg-zone-content-after" class="smg-zone smg-zone-content-after"><div class="smg-zone-group smg-zone-group-content-after-letter"><div class="smg-zone-widget smg-zone-widget-custom-founding-members-post-footer  ">n<div class="card team-letter team-letter-founding-member">nt<div class="card-header">ntt<div>nttt<span>Snopes.com</span>ntt</div>ntt<div>nttt<span>Since 1994</span>ntt</div>nt</div>nt<div class="card-body p-0">ntt<div>nttt<h5 class="card-title">Help Supercharge Snopes For 2020</h5>nttt<p class="card-text">nttttWe have big plans. We need your help.nttt</p>ntt</div>ntt<imgntttclass="stamp-image"ntttsrc="https://www.snopes.com/content/themes/snopes/dist/images/lazyload-placeholder.png"ntttdata-lazy-src="https://www.snopes.com/tachyon/2019/12/team-snopes-stamp-cream.png?resize=865,865"ntttdata-lazy-srcset="https://www.snopes.com/tachyon/2019/12/team-snopes-stamp-cream.png?resize=80,80 80w,https://www.snopes.com/tachyon/2019/12/team-snopes-stamp-cream.png?resize=180,180 180w,https://www.snopes.com/tachyon/2019/12/team-snopes-stamp-cream.png?resize=375,375 375w,https://www.snopes.com/tachyon/2019/12/team-snopes-stamp-cream.png?resize=416,416 416w,https://www.snopes.com/tachyon/2019/12/team-snopes-stamp-cream.png?resize=542,542 542w,https://www.snopes.com/tachyon/2019/12/team-snopes-stamp-cream.png?resize=733,733 733w,https://www.snopes.com/tachyon/2019/12/team-snopes-stamp-cream.png?resize=865,865 865w,https://www.snopes.com/tachyon/2019/12/team-snopes-stamp-cream.png?resize=1200,1200 1200w,"ntttalt=""ntt>nt</div>nt<div class="card-footer">ntt<a href="https://www.snopes.com/projects/founding-members/?utm_source=snopes-post-footer-letter&#038;utm_medium=native&#038;utm_campaign=fm2020&#038;utm_content=become-a-member">ntttBecome a member!ntt</a>nt</div>n</div>n</div></div></div>tt</div>nnttn<div class="footer-wrapper">nn",
            "articleImageUrl": "https:www.snopes.comtachyon202002quaden_image.jpg?resize=865,452",
            "articleUrl": "https:www.snopes.comfact-checkquaden-bayles-suicide-hoax",
            "ruling": "false",
            "articleDate": "29 February 2020"
        }
    """.data(using: .utf8)!

    static let baseFirebaseURL = URL(string: "https://check-that-fact.firebaseio.com")!
    static let goodSnopesFirebaseURL = URL(string: "https://check-that-fact.firebaseio.com/snopes.json")!

    static var snopesPutRequest = NetworkService.createRequest(url: goodSnopesFirebaseURL,
                                                        method: .put,
                                                        headerType: .contentType,
                                                        headerValue: .json)

    static var snopesGetRequst = NetworkService.createRequest(url: goodSnopesFirebaseURL,
                                                       method: .get,
                                                       headerType: .contentType,
                                                       headerValue: .json)

    static let mockSnopesArticle = Snopes(articleDate: "3/21/1980",
                                   articleUrl: "http://kennydubroff.com",
                                   headline: "A star is born",
                                   articleText: "Yuk yuk",
                                   articleImageUrl: "http://kennydubroff.com/images/kenny.jpg",
                                   ruling: "true")
    
    static let articlesFromServer: [Snopes] = [
        Snopes(articleDate: "3/21/1980",
        articleUrl: "http://kennydubroff.com",
        headline: "A star is born",
        articleText: "Yuk yuk",
        articleImageUrl: "http://kennydubroff.com/images/kenny.jpg",
        ruling: "true"),
        
        Snopes(articleDate: "3/22/1980",
        articleUrl: "http://kennydubroff.com",
        headline: "Another star is born",
        articleText: "Ok then",
        articleImageUrl: "foof",
        ruling: "false")
    ]
    
    static let articlesFromSnopes: [Snopes] = [
        Snopes(articleDate: "3/21/1980",
        articleUrl: "http://kennydubroff.com",
        headline: "A star is born",
        articleText: "Yuk yuk",
        articleImageUrl: "http://kennydubroff.com/images/kenny.jpg",
        ruling: "true"),
        
        Snopes(articleDate: "3/29/1980",
        articleUrl: "http://kennydubroff.com",
        headline: "Another star is born",
        articleText: "Ok then",
        articleImageUrl: "http://kennydubroff.com/images/kenny.jpg",
        ruling: "maybe"),
        
        Snopes(articleDate: "3/29/1980",
        articleUrl: "http://kennydubroff.com",
        headline: "Add this article",
        articleText: "Ok then",
        articleImageUrl: "http://kennydubroff.com/images/kenny.jpg",
        ruling: "maybe")
    ]


}
