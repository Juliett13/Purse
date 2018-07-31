import Alamofire
import PromiseKit
import SwiftKeychainWrapper

class Request
{
    static let contentType = "application/json"
    static var authorization: String {
        let token = KeychainWrapper.standard.string(forKey: "userToken")
        return "Bearer \(token ?? "")"
    }

    // MARK: - Operation

    class Operation {

        class Get: NetworkRequestProtocol
        {
            var url = "operation/"
            var method: HTTPMethod = .get
            var parameters: Parameters?
            var headers: HTTPHeaders?
            var succeedCodes = [200]

            private let networkClient: NetworkClientProtocol

            required init(_ networkClient: NetworkClientProtocol = NetworkClient.shared)
            {
                self.networkClient = networkClient
                self.headers = HTTPHeaders()
                self.headers?["Authorization"] = Request.authorization
            }

            init(accountId: Int?, networkClient: NetworkClientProtocol = NetworkClient.shared)
            {
                self.networkClient = networkClient
                self.headers = HTTPHeaders()
                self.headers?["Authorization"] = Request.authorization

                guard let accountId = accountId else {
                    return
                }

                url += "\(accountId)/"
            }

            func send() -> Promise<[OperationModel]>
            {
                return self.networkClient.send(request: self)
            }
        }

        // MARK: - Income

        class Income {
            class Get: NetworkRequestProtocol
            {
                var url = "operation/income/"
                var method: HTTPMethod = .get
                var parameters: Parameters?
                var headers: HTTPHeaders?
                var succeedCodes = [200]

                private let networkClient: NetworkClientProtocol

                required init(_ networkClient: NetworkClientProtocol = NetworkClient.shared)
                {
                    self.networkClient = networkClient
                    self.headers = HTTPHeaders()
                    self.headers?["Authorization"] = Request.authorization
                }

                init(accountId: Int?, networkClient: NetworkClientProtocol = NetworkClient.shared)
                {
                    self.networkClient = networkClient
                    self.headers = HTTPHeaders()
                    self.headers?["Authorization"] = Request.authorization

                    guard let accountId = accountId else {
                        return
                    }

                    url += "\(accountId)/"
                }

                func send() -> Promise<[OperationModel]>
                {
                    return self.networkClient.send(request: self)
                }
            }

            class Post: NetworkRequestProtocol
            {
                var url = "operation/income/"
                var method: HTTPMethod = .post
                var parameters: Parameters?
                var headers: HTTPHeaders?
                var succeedCodes = [200, 201]

                private let networkClient: NetworkClientProtocol

                required init(_ networkClient: NetworkClientProtocol)
                {
                    self.networkClient = networkClient
                    self.headers = HTTPHeaders()
                    self.headers?["Authorization"] = Request.authorization
                    self.headers?["Content-Type"] = Request.contentType
                }

                init(sum: Int, accountId: Int, comment: String, networkClient: NetworkClientProtocol = NetworkClient.shared)
                {
                    self.networkClient = networkClient
                    self.headers = HTTPHeaders()
                    self.headers?["Authorization"] = Request.authorization
                    self.headers?["Content-Type"] = Request.contentType
                    self.parameters = Parameters()
                    self.parameters?["sum"] = sum
                    self.parameters?["accountId"] = accountId
                    self.parameters?["comment"] = comment
                }

                func send() -> Promise<OperationModel>
                {
                    return self.networkClient.send(request: self)
                }
            }
        }

        // MARK: - Outgo

        class Outgo {
            class Get: NetworkRequestProtocol
            {
                var url = "operation/outgo/"
                var method: HTTPMethod = .get
                var parameters: Parameters?
                var headers: HTTPHeaders?
                var succeedCodes = [200]

                private let networkClient: NetworkClientProtocol

                required init(_ networkClient: NetworkClientProtocol = NetworkClient.shared)
                {
                    self.networkClient = networkClient
                    self.headers = HTTPHeaders()
                    self.headers?["Authorization"] = Request.authorization
                }

                init(accountId: Int?, networkClient: NetworkClientProtocol = NetworkClient.shared)
                {
                    self.networkClient = networkClient
                    self.headers = HTTPHeaders()
                    self.headers?["Authorization"] = Request.authorization

                    guard let accountId = accountId else {
                        return
                    }

                    url += "\(accountId)/"
                }

                func send() -> Promise<[OperationModel]>
                {
                    return self.networkClient.send(request: self)
                }
            }

            class Post: NetworkRequestProtocol
            {
                var url = "operation/outgo/"
                var method: HTTPMethod = .post
                var parameters: Parameters?
                var headers: HTTPHeaders?
                var succeedCodes = [200, 201]

                private let networkClient: NetworkClientProtocol

                required init(_ networkClient: NetworkClientProtocol)
                {
                    self.networkClient = networkClient
                    self.headers = HTTPHeaders()
                    self.headers?["Authorization"] = Request.authorization
                    self.headers?["Content-Type"] = Request.contentType
                }

                init(sum: Int, accountId: Int, comment: String, networkClient: NetworkClientProtocol = NetworkClient.shared)
                {
                    self.networkClient = networkClient
                    self.headers = HTTPHeaders()
                    self.headers?["Authorization"] = Request.authorization
                    self.headers?["Content-Type"] = Request.contentType
                    self.parameters = Parameters()
                    self.parameters?["accountId"] = accountId
                    self.parameters?["sum"] = sum
                    self.parameters?["comment"] = comment
                }

                func send() -> Promise<OperationModel>
                {
                    return self.networkClient.send(request: self)
                }
            }
        }

        // MARK: - Transfer

        class Transfer {
            class Get: NetworkRequestProtocol
            {
                var url = "operation/transfer/"
                var method: HTTPMethod = .get
                var parameters: Parameters?
                var headers: HTTPHeaders?
                var succeedCodes = [200]

                private let networkClient: NetworkClientProtocol

                required init(_ networkClient: NetworkClientProtocol = NetworkClient.shared)
                {
                    self.networkClient = networkClient
                    self.headers = HTTPHeaders()
                    self.headers?["Authorization"] = Request.authorization
                }

                init(accountId: Int?, networkClient: NetworkClientProtocol = NetworkClient.shared)
                {
                    self.networkClient = networkClient
                    self.headers = HTTPHeaders()
                    self.headers?["Authorization"] = Request.authorization

                    guard let accountId = accountId else {
                        return
                    }

                    url += "\(accountId)/"
                }

                func send() -> Promise<[OperationModel]>
                {
                    return self.networkClient.send(request: self)
                }
            }

            class Post: NetworkRequestProtocol
            {
                var url = "operation/transfer/"
                var method: HTTPMethod = .post
                var parameters: Parameters?
                var headers: HTTPHeaders?
                var succeedCodes = [200, 201]

                private let networkClient: NetworkClientProtocol

                required init(_ networkClient: NetworkClientProtocol)
                {
                    self.networkClient = networkClient
                    self.headers = HTTPHeaders()
                    self.headers?["Authorization"] = Request.authorization
                    self.headers?["Content-Type"] = Request.contentType
                }

                init(sum: Int, firstAccountId: Int, secondAccountId: Int, comment: String, networkClient: NetworkClientProtocol = NetworkClient.shared)
                {
                    self.networkClient = networkClient
                    self.headers = HTTPHeaders()
                    self.headers?["Authorization"] = Request.authorization
                    self.headers?["Content-Type"] = Request.contentType
                    self.parameters = Parameters()
                    self.parameters?["sum"] = sum
                    self.parameters?["firstAccountId"] = firstAccountId
                    self.parameters?["secondAccountId"] = secondAccountId
                    self.parameters?["comment"] = comment
                }

                func send() -> Promise<OperationModel>
                {
                    return self.networkClient.send(request: self)
                }
            }
        }
    }

    // MARK: - Account

    class Account
    {
        class Post: NetworkRequestProtocol
        {
            var url = "account/"
            var method: HTTPMethod = .post
            var parameters: Parameters?
            var headers: HTTPHeaders?
            var succeedCodes = [200, 201]

            private let networkClient: NetworkClientProtocol

            required init(_ networkClient: NetworkClientProtocol)
            {
                self.networkClient = networkClient
                self.headers = HTTPHeaders()
                self.headers?["Authorization"] = Request.authorization
                self.headers?["Content-Type"] = Request.contentType
            }

            init(sum: Int, description: String, networkClient: NetworkClientProtocol = NetworkClient.shared)
            {
                self.networkClient = networkClient
                self.headers = HTTPHeaders()
                self.headers?["Authorization"] = Request.authorization
                self.headers?["Content-Type"] = Request.contentType
                self.parameters = Parameters()
                self.parameters?["sum"] = sum
                self.parameters?["description"] = description
            }

            func send() -> Promise<AccountModel>
            {
                return self.networkClient.send(request: self)
            }
        }


        class Get: NetworkRequestProtocol
        {
            var url = "account/"
            var method: HTTPMethod = .get
            var parameters: Parameters?
            var headers: HTTPHeaders?
            var succeedCodes = [200]

            private let networkClient: NetworkClientProtocol

            required init(_ networkClient: NetworkClientProtocol = NetworkClient.shared)
            {
                self.networkClient = networkClient
                self.headers = HTTPHeaders()
                self.headers?["Authorization"] = Request.authorization
            }

            func send() -> Promise<[AccountModel]>
            {
                return self.networkClient.send(request: self)
                self.headers = HTTPHeaders()
                self.headers?["Authorization"] = Request.authorization
            }
        }

    }

    // MARK: - User

    class User
    {
        class Post: NetworkRequestProtocol
        {
            var url = "user/"
            var method: HTTPMethod = .post
            var parameters: Parameters?
            var headers: HTTPHeaders?
            var succeedCodes = [200, 201]

            private let networkClient: NetworkClientProtocol

            required init(_ networkClient: NetworkClientProtocol)
            {
                self.networkClient = networkClient
                self.headers = HTTPHeaders()
                self.headers?["Content-Type"] = Request.contentType
            }

            init(name: String, password: String, networkClient: NetworkClientProtocol = NetworkClient.shared)
            {
                self.networkClient = networkClient
                self.headers = HTTPHeaders()
                self.headers?["Content-Type"] = Request.contentType
                self.parameters = Parameters()
                self.parameters?["name"] = name
                self.parameters?["password"] = password
            }

            func send() -> Promise<UserModel>
            {
                return self.networkClient.send(request: self)
            }
        }

        class Login
        {
            class Post: NetworkRequestProtocol
            {
                var url = "user/login/"
                var method: HTTPMethod = .post
                var parameters: Parameters?
                var headers: HTTPHeaders?
                var succeedCodes = [200, 201]

                private let networkClient: NetworkClientProtocol

                required init(_ networkClient: NetworkClientProtocol)
                {
                    self.networkClient = networkClient
                    self.headers = HTTPHeaders()
                    self.headers?["Content-Type"] = Request.contentType
                }

                init(name: String, password: String, networkClient: NetworkClientProtocol = NetworkClient.shared)
                {
                    self.networkClient = networkClient
                    self.headers = HTTPHeaders()
                    self.headers?["Content-Type"] = Request.contentType
                    self.parameters = Parameters()
                    self.parameters?["name"] = name
                    self.parameters?["password"] = password
                }

                func send() -> Promise<UserModel>
                {
                    return self.networkClient.send(request: self)
                }
            }
        }
    }
}
