import Foundation

public protocol NetworkClientProtocol {
    func fetchData(from url: URL) async throws -> (Data, URLResponse)
}
