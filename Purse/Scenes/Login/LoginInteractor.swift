import Foundation
import Alamofire

// REVIEW: Interactor should not depend on you network or other layer implementation. 
class LoginInteractor: Queryable
{
    unowned var presenter: LoginPresenterProtocol
    
    init(presenter: LoginPresenterProtocol) {
        self.presenter = presenter
    }
}

// MARK: - LoginInteractorProtocol

extension LoginInteractor: LoginInteractorProtocol {
    func createUser(credentials: [String : Any], onSuccess: @escaping (NSDictionary) -> (), onFailure: @escaping () -> ()) {
        let url = "user/"
        userQuery(url: url, credentials: credentials, onSuccess: onSuccess, onFailure: onFailure)
    }
    
    // REVIEW: dont's use dictionary, use DTO objects. And why pass data on success if not using it?
    // Also consider to create a networkClient to handle requests with Alamofire and creating Request objects
    // Check Codable protocol or ObjectMapper framework.
    func loginUser(credentials: [String : Any], onSuccess: @escaping (NSDictionary) -> (), onFailure: @escaping () -> ()) {
        let url = "user/login/"
        userQuery(url: url, credentials: credentials, onSuccess: onSuccess, onFailure: onFailure)
    }
    
    func userQuery(url: String,
                   credentials: [String : Any],
                   onSuccess: @escaping (NSDictionary) -> (),
                   onFailure: @escaping () -> ()) {
        let onSuccess: (Any) -> () = {any in
            if let dict = any as? NSDictionary
            {
                // REVIEW: Check again code style docs, functions must start with lowercase
                // self.tokenObtained(data: dict)
                self.TokenObtained(data: dict)
                onSuccess(dict)
            }
        }
        
        post(url: url, headers: [:], credentials: credentials, onSuccess: onSuccess, onFailure: onFailure)
    }
    
    private func TokenObtained(data: NSDictionary)
    {
        // REVIEW: Not value, at least object(forkey) or use subscript! Fix it everywhere.
        token = data.value(forKey: "token") as? String
        username = data.value(forKey: "username") as? String

        print(token)

        // !! save in keychain
        
    }
}

// REVIEW: Example of the requests structure

// request protocol
protocol NetworkRequestProtocol: class
{
    var url: String { get }
    var method: HTTPMethod { get }
    var parameters: Parameters? { get }
    var headers: HTTPHeaders? { get }
    var succeedCodes: [Int] { get }
    
    init(_ networkClient: NetworkClientProtocol)
}

enum Result<T: Codable>
{
    case success(T)
    case failure(Error)
}

// Handles all your requests
protocol NetworkClientProtocol: class
{
    // func send<T: BaseMappable>(request: NetworkRequestProtocol, useCache cache: Bool) -> Promise<T> if you use ObjectMapper
    
    // PromiseKit is fantastic, check it out.
    //func send<T: Codable>(request: NetworkRequestProtocol) -> Promise<T>
    
    // Or simply result enum
    func send<T: Codable>(request: NetworkRequestProtocol, completion: (Result<T>) -> Void)
}

class NetworkClient: NetworkClientProtocol
{
    let serverURL: String
    
    static let shared : NetworkClient =  {
        let instance = NetworkClient(serverURL: "YOUR_URL")
        return instance
    }()
    
    init(serverURL: String)
    {
        self.serverURL = serverURL
    }
    
    func send<T: Codable>(request: NetworkRequestProtocol, completion: (Result<T>) -> Void)
    {
        // Work with alamofire there. obtain data from NetworkRequestProtocol object
    }
}

// Idea is to easily split requests into groups and types. Make then reusable across the whole app.

class Request
{
    class User
    {
        // post version of "user/"
        class Post
        {
            
        }
        
        // get version of "user/"
        class Get
        {
            
        }
        
        class Login
        {
            class Post: NetworkRequestProtocol
            {
                var url = "user/login/"
                var method: HTTPMethod = .post
                var parameters: Parameters? // credentials in you current implemantation
                var headers: HTTPHeaders?
                var succeedCodes = [200]
                
                private let networkClient: NetworkClientProtocol
                
                required init(_ networkClient: NetworkClientProtocol)
                {
                    self.networkClient = networkClient
                }
                
                init(login: String, password: String, networkClient: NetworkClientProtocol = NetworkClient.shared)
                {
                    self.networkClient = networkClient
                    self.parameters?["login"] = login
                    self.parameters?["password"] = password
                }
                
                func send<T:Response>(completion: @escaping (Result<T>) -> Void)
                {
                    self.networkClient.send(request: self, completion: completion)
                }
                
                class Response: Codable
                {
                    // REVIEW: Request call example
                    func reauestExample()
                    {
                        let request = Request.User.Login.Post(login: "login_from_input", password: "password_from_input")
                        request.send{ result in
                            switch result
                            {
                            case .success(let response):
                                break
                                // handle success
                                
                            case .failure(let error):
                                // handle failure
                                break
                            }
                        }
                    }
                }
            }
        }
    }
}
