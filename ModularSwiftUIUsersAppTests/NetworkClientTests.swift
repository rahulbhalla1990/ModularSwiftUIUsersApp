import XCTest
@testable import ModularSwiftUIUsersApp


final class NetworkClientTests: XCTestCase {

    func testFetchData_Success() async throws {
        // Mock data
        let json = """
        [{"id":1,"name":"John Doe"}]
        """.data(using: .utf8)!

        // Setup mock protocol handler
        MockURLProtocol.handler = { request in
            let response = HTTPURLResponse(url: request.url!,
                                           statusCode: 200,
                                           httpVersion: nil,
                                           headerFields: nil)!
            return (response, json)
        }

        let config = URLSessionConfiguration.ephemeral
        config.protocolClasses = [MockURLProtocol.self]
        let session = URLSession(configuration: config)

        let client = NetworkClient(session: session)
        let url = URL(string: "https://jsonplaceholder.typicode.com/users")!

        let (data, response) = try await client.fetchData(from: url)

        XCTAssertNotNil(data)
        XCTAssertEqual((response as? HTTPURLResponse)?.statusCode, 200)
    }

    func testFetchData_Failure() async {
        MockURLProtocol.handler = { request in
            throw URLError(.badServerResponse)
        }

        let config = URLSessionConfiguration.ephemeral
        config.protocolClasses = [MockURLProtocol.self]
        let session = URLSession(configuration: config)

        let client = NetworkClient(session: session)
        let url = URL(string: "https://jsonplaceholder.typicode.com/users")!

        do {
            _ = try await client.fetchData(from: url)
            XCTFail("Expected to throw an error")
        } catch {
            XCTAssertTrue(error is URLError)
        }
    }
}

