import Foundation

enum NetworkErrors: String, Error {
    case BadStatusCode
    case InvalidURL
    case FailedToDecodeData
}

protocol NetworkManagable {
    func fetchValue<T: Decodable>(of type: T.Type, for url: URL) async throws -> T
}

struct NetworkManager: NetworkManagable {
    let session: URLSession
    
    init(session: URLSession = URLSession.shared) {
        self.session = session
    }
    
    func fetchValue<T: Decodable>(of type: T.Type = T.self, for url: URL) async throws -> T {
        let (data, response) = try await session.data(from: url)
        guard let httpURLResponse = response as? HTTPURLResponse, httpURLResponse.isHttpURLResponseValid else {
            throw NetworkErrors.BadStatusCode
        }
        
        guard let decodedData = try? JSONDecoder().decode(type, from: data) else {
            throw NetworkErrors.FailedToDecodeData
        }
        
        return decodedData
    }
}
