import Alamofire
import PromiseKit

// MARK: - Request

protocol NetworkRequestProtocol: class {
    var url: String { get }
    var method: HTTPMethod { get }
    var parameters: Parameters? { get }
    var headers: HTTPHeaders? { get }
    var succeedCodes: [Int] { get }

    init(_ networkClient: NetworkClientProtocol)
}

// MARK: - Client

protocol NetworkClientProtocol: class {
    func send<T: Codable>(request: NetworkRequestProtocol) -> Promise<T>
}
