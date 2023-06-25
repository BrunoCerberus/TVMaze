//
//  APIDataFetcher.swift
//  TVMaze
//
//  Created by bruno on 25/06/23.
//

import Foundation

open class APIDataFetcher<T: Fetcher> {
    
    var debug: Bool
    
    public init(debug: Bool = false) {
        self.debug = debug
    }
    
    public func fetch<V: Codable>(
        target: T,
        dataType: V.Type,
        completion: ((Result<V, Error>) -> Void)?
    ) {
        let url: String = target.path
        let parameters: [String: Any] = target.task?.dictionary() ?? [:]
        let method: HTTPMethod = target.method
        
        guard let urlRequest: URL = URL(string: url) else {
            completion?(.failure(FetcherError.generic))
            return
        }
        
        var request: URLRequest = URLRequest(url: urlRequest)
        request.httpMethod = method.rawValue
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        if let headerOpts: [String: Any] = target.header?.dictionary(), !headerOpts.isEmpty {
            target.header?.dictionary()?.forEach { key, value in
                if let value: String = value as? String {
                    request.addValue(value, forHTTPHeaderField: key)
                }
            }
        }
        
        let session: URLSession = URLSession.shared
        
        if method == .POST || method == .PUT || method == .DELETE {
            guard let httpBody: Data = try? JSONSerialization.data(withJSONObject: parameters, options: [.sortedKeys]) else {
                return
            }
            request.httpBody = httpBody
        }
        
        session.dataTask(with: request) { dataRequest, response, error in
            if self.debug {
                self.debugResponse(request, dataRequest, response, error)
            }
            
            guard let data: Data = dataRequest else {
                completion?(.failure(FetcherError.generic))
                return
            }
            
            do {
                let decoder: JSONDecoder = JSONDecoder()
                let decodedResponse: V = try decoder.decode(dataType.self, from: data)
                completion?(.success(decodedResponse))
            } catch {
                if self.debug {
                    print("\n\n===========Error===========")
                    print("Error Code: \(error._code)")
                    print("Error Messsage: \(error.localizedDescription )")
                    print(error as Any)
                    print("===========================\n\n")
                }
                
                completion?(.failure(FetcherError.parse(self.getParseMessage(
                    dataRequest: dataRequest,
                    request: request,
                    response: response,
                    error: error
                ))))
                return
            }
        }
        .resume()
    }
}

private extension APIDataFetcher {
    private func debugResponse(
        _ request: URLRequest,
        _ responseData: Data?,
        _ response: URLResponse?,
        _ error: Error?
    ) {
        let uuid: String = UUID().uuidString
        print("\n↗️ ======= REQUEST =======")
        print("↗️ REQUEST #: \(uuid)")
        print("↗️ URL: \(request.url?.absoluteString ?? "")")
        print("↗️ HTTP METHOD: \(request.httpMethod ?? "GET")")
        
        if let requestHeaders: [String: String] = request.allHTTPHeaderFields,
           let requestHeadersData: Data = try? JSONSerialization.data(withJSONObject: requestHeaders, options: .prettyPrinted),
           let requestHeadersString: String = String(data: requestHeadersData, encoding: .utf8) {
            print("↗️ HEADERS:\n\(requestHeadersString)")
        }
        
        if let requestBodyData: Data = request.httpBody,
           let requestBody: String = String(data: requestBodyData, encoding: .utf8) {
            print("↗️ BODY: \n\(requestBody)")
        }
        
        if let httpResponse: HTTPURLResponse = response as? HTTPURLResponse {
            print("\n↙️ ======= RESPONSE =======")
            switch httpResponse.statusCode {
            case 200...202, 204, 205:
                print("↙️ CODE: \(httpResponse.statusCode) - ✅")
            case 400...505:
                print("↙️ CODE: \(httpResponse.statusCode) - 🆘")
            default:
                print("↙️ CODE: \(httpResponse.statusCode) - ✴️")
            }
            
            if let responseHeadersData: Data = try? JSONSerialization.data(withJSONObject: httpResponse.allHeaderFields, options: .prettyPrinted),
               let responseHeadersString: String = String(data: responseHeadersData, encoding: .utf8) {
                print("↙️ HEADERS:\n\(responseHeadersString)")
            }
            
            if let responseBodyData: Data = responseData, let responseBody: String = String(data: responseBodyData, encoding: .utf8),
               !responseBody.isEmpty {
                
                print("↙️ BODY:\n\(responseBody)\n")
            }
        }
        
        if let urlError: URLError = error as? URLError {
            print("\n❌ ======= ERROR =======")
            print("❌ CODE: \(urlError.errorCode)")
            print("❌ DESCRIPTION: \(urlError.localizedDescription)\n")
        }
        
        print("======== END OF: \(uuid) ========\n\n")
    }
    
    private func getParseMessage(dataRequest: Data?, request: URLRequest, response: URLResponse?, error: Error) -> String {
        var responseStatusCode: String = ""
        var responseBody: String = ""
        
        if let httpResponse: HTTPURLResponse = response as? HTTPURLResponse {
            responseStatusCode = String(httpResponse.statusCode)
        }
        
        if let data = dataRequest, let body = String(data: data, encoding: .utf8) {
            responseBody = body
        }
        
        var parseResponse: String = ""
        parseResponse += "[REQUEST_URL: \(request.url?.absoluteString ?? "")] "
        parseResponse += "[RESPONSE_CODE: \(responseStatusCode)] "
        parseResponse += "[RESPONSE_BODY: \(responseBody)] "
        parseResponse += "[PARSE: \(error.getDescription())]"
        
        return parseResponse
    }
}
