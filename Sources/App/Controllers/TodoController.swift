import Vapor

/// Controls basic CRUD operations on `Todo`s.
final class TodoController: RouteCollection {
    
    func boot(router: Router) throws {
        router.post("todos", "create", use: createTodoHandler)
    }
    
    func createTodoHandler(_ req: Request) throws -> Future<HTTPResponseStatus> {
        //decode JSON from body
            let todo = try req.content
                .decode(Todo.self)
                //flatMap to pull out todo?
                let result = todo.flatMap({ (todo) -> EventLoopFuture<HTTPResponseStatus> in
                    //now it's decoded, save to database
                    _ = todo.save(on: req)
                    
                    let promise = req.eventLoop.newPromise(HTTPResponseStatus.self)
                    promise.succeed(result: .created)
                    return promise.futureResult //return for flatmap
                })
        return result //flatMapped array
    }
    
}
