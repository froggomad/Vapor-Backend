<h3>This backend built with:</h3>
<p align="center">
    <img src="https://user-images.githubusercontent.com/1342803/36623515-7293b4ec-18d3-11e8-85ab-4e2f8fb38fbd.png" width="320" alt="API Template">
    <br>
    <br>
    <a href="http://docs.vapor.codes/3.0/">
        <img src="http://img.shields.io/badge/read_the-docs-2196f3.svg" alt="Documentation">
    </a>
    <a href="https://discord.gg/vapor">
        <img src="https://img.shields.io/discord/431917998102675485.svg" alt="Team Chat">
    </a>
    <a href="LICENSE">
        <img src="http://img.shields.io/badge/license-MIT-brightgreen.svg" alt="MIT License">
    </a>
    <a href="https://circleci.com/gh/vapor/api-template">
        <img src="https://circleci.com/gh/vapor/api-template.svg?style=shield" alt="Continuous Integration">
    </a>
    <a href="https://swift.org">
        <img src="http://img.shields.io/badge/swift-5.1-brightgreen.svg" alt="Swift 5.1">
    </a>
</p>

# Push Snopes to Firebase branch
<hr>
The "/snopes" endpoint will be used to trigger an async function that pushes the JSON to Firebase Realtime Database via the REST API
<hr>
<br>
<br>

# 2 Apps, 1 language, full stack!
<img src="Both-Apps.png" alt="Screenshot"/>
<hr>

## Backend Running on localhost
<img src="Back%20End.png" alt="Vapor Instance Screenshot"/>
<caption>Backend server running on Vapor written in Swift</caption>

### The server runs a script that scrapes https://snopes.com/fact-check
An object holding text variables is initialized using dynamic values and encoded into JSON. The JSON is made available on a GET endpoint ("http://localhost:8080/snopes")
<hr>

## Frontend Running on device
<img src="Front%20End.png" alt="Front End Screenshot"/>
<caption>Front End App running on iPhone 11 Simulator</caption>

### The Frontend downloads JSON data and decodes into identical object (Data model was literally copy/pasted with 1 minor change - encodable conformity was changed to decodable conformity)
The results are displayed on a tableView. One of the scraped variables is the article's text in html. This is displayed on a detail view using a WkWebview.
<hr>

Normally something even this simple would require the use of at least 2 programming languages (one to create a web-facing interface using a server-side language such as node.js) and one for the frontend (using Swift for both in this case).

I was able to put this together in just a couple hours, using a process I'm wholly unfamiliar with. The convenience of using one development environment and one language is priceless. Encoding/decoding is a breeze, data modeling - not even a concern.
