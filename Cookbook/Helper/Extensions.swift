import Foundation

extension HTTPURLResponse {
    var isHttpURLResponseValid: Bool {
        (200...299).contains(self.statusCode)
    }
}
