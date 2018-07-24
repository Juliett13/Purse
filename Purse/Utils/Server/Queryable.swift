import Alamofire


let API_ROOT_URL = "http://localhost:8080/" 

var id: Int? // !!
var token: String? // !!
var username: String? // !!


protocol Queryable {
    func get(url: String, headers: [String: String], onSuccess: @escaping (Any) -> (), onFailure: @escaping  () -> ())
    func post(url: String, headers: [String: String], credentials: [String: Any], onSuccess: @escaping (Any) -> (), onFailure: @escaping () -> ())
}

extension Queryable {

    func get(url: String, headers: [String: String], onSuccess: @escaping (Any) -> (), onFailure: @escaping  () -> ()) {
        Alamofire
            .request(API_ROOT_URL + url, method: .get, encoding: JSONEncoding.default, headers: headers)
            .validate(statusCode: 200..<300)
            .responseJSON { response in
                switch response.result {
                case .success:
                    if let result = response.result.value
                    {
                        onSuccess(result)
                    }
                case .failure:
                    onFailure()
                }
        }
    }
    
    func post(url: String, headers: [String: String], credentials: [String: Any], onSuccess: @escaping (Any) -> (), onFailure: @escaping () -> ()) {
        Alamofire
            .request(API_ROOT_URL + url, method: .post, parameters: credentials, encoding: JSONEncoding.default, headers: headers)
            .validate(statusCode: 200..<300)
            .responseJSON { response in
                switch response.result {
                case .success:
                    if let result = response.result.value
                    {
                        onSuccess(result)
                    }
                case .failure:
                    onFailure()
                }
        }
    }
}


