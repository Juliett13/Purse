import PromiseKit

class NetworkClient {
    let serverURL: String

    static let shared : NetworkClient =  {
        let instance = NetworkClient(serverURL: "http://localhost:8080/")
        return instance
    }()

    init(serverURL: String)
    {
        self.serverURL = serverURL
    }
}

// MARK: - NetworkClientProtocol

extension NetworkClient: NetworkClientProtocol {
    func send<T: Codable>(request: NetworkRequestProtocol) -> Promise<T> {
        return firstly {
            Alamofire
                .request(
                    serverURL + request.url,
                    method: request.method,
                    parameters: request.parameters,
                    encoding: JSONEncoding.default,
                    headers: request.headers
                ).validate(statusCode: request.succeedCodes)
                .responseData()
            }.map { args in
                return try JSONDecoder().decode(T.self, from: args.data)
        }
    }
}
