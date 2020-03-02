import Vapor
/// Register your application's routes here.
public func routes(_ router: Router) throws {
    let todoController = TodoController() //conforms to RouteController
    let scraper = Scraper.instance
    try router.register(collection: todoController) // /todos
    router.get("/") {req in
        return "Hey"
    }
    router.get("snopes") {req in
        return scraper._snopesArray
    }
}

extension Snopes: Content {
    
}
