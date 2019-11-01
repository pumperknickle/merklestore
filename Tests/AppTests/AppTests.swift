import App
import XCTest
import Vapor
import CryptoStarterPack
import Bedrock

final class AppTests: XCTestCase {
    func testNothing() throws {
        // Add your tests here
        XCTAssert(true)
    }
	
	func testSaveAndRetrieve() throws {
		var config = Config.default()
		var services = Services.default()
		var env = Environment.testing
		try App.configure(&config, &env, &services)
		let app = try Application(config: config, environment: env, services: services)
		try App.boot(app)
		
		let someInformation = "Hello World".toBoolArray().literal()
		let hashOfInformation = BaseCrypto.hash(someInformation.bools())!
		
		let responder = try app.make(Responder.self)
		let request = HTTPRequest(method: .PUT, url: URL(string: "put/" + someInformation)!)
		let wrappedRequest = Request(http: request, using: app)

		let response = try responder.respond(to: wrappedRequest).wait()
		XCTAssertTrue(response.http.status == .ok)
		
		let getRequest = HTTPRequest(method: .GET, url: URL(string: "get/" + hashOfInformation.literal())!)
		let wrappedGetRequest = Request(http: getRequest, using: app)
		
		let getResponse = try responder.respond(to: wrappedGetRequest).wait()
		let dataContentOfResponse = getResponse.http.body.data!
		let contentOfResponse = String(bytes: dataContentOfResponse, encoding: .utf8)
		XCTAssertTrue(getResponse.http.status == .ok)
		XCTAssertNotNil(contentOfResponse)
		XCTAssertEqual(contentOfResponse!, someInformation)
	}

    static let allTests = [
        ("testNothing", testNothing)
    ]
}
