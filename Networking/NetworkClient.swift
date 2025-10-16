import Foundation

public final class NetworkClient: NetworkClientProtocol {
    private let session: URLSession

    public init(session: URLSession = .shared) {
        self.session = session
    }

    public func fetchData(from url: URL) async throws -> (Data, URLResponse) {
        try await session.data(from: url)
    }
}
