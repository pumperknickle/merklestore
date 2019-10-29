import Vapor
import Bedrock
import CryptoStarterPack

typealias CryptoDelegateType = BaseCrypto

public func routes(_ router: Router) throws {
    router.get { req in
        return "It works!"
    }
	
	router.put("put", String.parameter) { req -> Future<HTTPStatus> in
        guard let contentToSet = try? req.parameters.next(String.self).bools(),
			let hash = CryptoDelegateType.hash(contentToSet) else {
            let promise: Promise<HTTPStatus> = req.eventLoop.newPromise()
            promise.succeed(result: HTTPStatus.notAcceptable)
            return promise.futureResult
        }
        return try req.keyedCache(for: .redis).set(hash.literal(), to: contentToSet)
            .transform(to: .ok)
    }
	
	router.get("get", String.parameter) { req -> Future<String> in
        guard let digestToGet = try? req.parameters.next(String.self) else {
            let promise: Promise<String> = req.eventLoop.newPromise()
            promise.succeed(result: "")
            return promise.futureResult
        }
        return try req.keyedCache(for: .redis).get(digestToGet, as: [Bool].self)
            .unwrap(or: Abort(.badRequest, reason: "No string set yet.")).flatMap { boolArray in
                let promise: Promise<String> = req.eventLoop.newPromise()
                promise.succeed(result: boolArray.literal())
                return promise.futureResult
        }
    }
}
