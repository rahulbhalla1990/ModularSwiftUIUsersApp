import XCTest
@testable import ModularSwiftUIUsersApp

final class UserServiceTests: XCTestCase {

    func testFetchUsers() async throws {
        // ✅ Correct triple-quoted JSON string
        let json = """
        [
          {
            "id": 1,
            "name": "John Doe",
            "username": "john",
            "email": "john@example.com"
          }
        ]
        """.data(using: .utf8)!

        MockURLProtocol.handler = { request in
            let response = HTTPURLResponse(
                url: request.url!,
                statusCode: 200,
                httpVersion: nil,
                headerFields: nil
            )!
            return (response, json)
        }

        let config = URLSessionConfiguration.ephemeral
        config.protocolClasses = [MockURLProtocol.self]
        let session = URLSession(configuration: config)

        let client = NetworkClient(session: session)
        let url = URL(string: "https://fake-json-api.mock.beeceptor.com/users")!
        let service = RemoteUserService(client: client, url: url)

        let users = try await service.fetchUsers()
        XCTAssertEqual(users.count, 1)
        XCTAssertEqual(users.first?.name, "John Doe")
    }
    
    func testFetchUsers_Failure() async throws {
        // Arrange: set up mock response to simulate a 500 error
        let errorJSON = """
        { "error": "Internal Server Error" }
        """.data(using: .utf8)!

        MockURLProtocol.handler = { request in
            let response = HTTPURLResponse(
                url: request.url!,
                statusCode: 500,    // Simulate a server failure
                httpVersion: nil,
                headerFields: nil
            )!
            return (response, errorJSON)
        }

        // Create a mock session
        let config = URLSessionConfiguration.ephemeral
        config.protocolClasses = [MockURLProtocol.self]
        let session = URLSession(configuration: config)

        // Inject into our service
        let client = NetworkClient(session: session)
        let url = URL(string: "https://fake-json-api.mock.beeceptor.com/users")!
        let service = RemoteUserService(client: client, url: url)

        // Act + Assert
        do {
            _ = try await service.fetchUsers()
            XCTFail("Expected fetchUsers to throw, but it succeeded.")
        } catch {
            // ✅ Expected: error should be thrown
            print("Received expected error: \\(error.localizedDescription)")
        }
    }
    
    func testFetchUsers_InvalidJSON() async throws {
        // Arrange
        let invalidJSON = "{ invalid json }".data(using: .utf8)!
        MockURLProtocol.handler = { request in
            let response = HTTPURLResponse(
                url: request.url!,
                statusCode: 200,
                httpVersion: nil,
                headerFields: nil
            )!
            return (response, invalidJSON)
        }

        let config = URLSessionConfiguration.ephemeral
        config.protocolClasses = [MockURLProtocol.self]
        let session = URLSession(configuration: config)
        let client = NetworkClient(session: session)
        let url = URL(string: "https://fake-json-api.mock.beeceptor.com/users")!
        let service = RemoteUserService(client: client, url: url)

        // Act + Assert using do/catch
        do {
            _ = try await service.fetchUsers()
            XCTFail("Expected decoding to throw, but it succeeded.")
        } catch {
            // ✅ Expected path — decoding should fail
            XCTAssertTrue(error is DecodingError, "Expected DecodingError but got \(error)")
        }
    }

    func testAppContainerBootstrap() {
        // Act
        let container = AppContainer.bootstrap()

        // Assert
        XCTAssertNotNil(container.userService, "AppContainer should initialize a valid UserService")
    }

    func testNetworkClient_ThrowsError() async {
        // Arrange
        let config = URLSessionConfiguration.ephemeral
        config.protocolClasses = [MockURLProtocol.self]
        let session = URLSession(configuration: config)
        let client = NetworkClient(session: session)

        // Set handler to throw (simulate failed request)
        MockURLProtocol.handler = { request in
            throw URLError(.badServerResponse)
        }

        let url = URL(string: "https://fake-json-api.mock.beeceptor.com/users")!

        // Act & Assert
        do {
            _ = try await client.fetchData(from: url)
            XCTFail("Expected URLError to be thrown")
        } catch {
            XCTAssertTrue(error is URLError, "Expected URLError but got \(error)")
        }
    }
    
    func testUserService_RefreshHandlesFailureGracefully() async throws {
        // Arrange
        MockURLProtocol.handler = { _ in
            throw URLError(.timedOut)
        }

        let config = URLSessionConfiguration.ephemeral
        config.protocolClasses = [MockURLProtocol.self]
        let session = URLSession(configuration: config)

        let client = NetworkClient(session: session)
        let url = URL(string: "https://fake-json-api.mock.beeceptor.com/users")!
        let service = RemoteUserService(client: client, url: url)

        // Act
        do {
            _ = try await service.fetchUsers()
        } catch {
            // Expected timeout error
        }

        // Assert
        var receivedUsers: [User] = []
        let cancellable = service.usersPublisher
            .sink { receivedUsers = $0 }

        XCTAssertTrue(receivedUsers.isEmpty, "Users should be empty after a failed refresh")
        cancellable.cancel()
    }




}

