import Foundation

protocol ApiEndpointContract {
    var baseURL: URL { get }
    var queryParameters: [String: String] { get }
    var url: URL { get }
}
