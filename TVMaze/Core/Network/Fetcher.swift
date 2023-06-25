//
//  Fetcher.swift
//  TVMaze
//
//  Created by bruno on 25/06/23.
//

import Foundation

/// HTTP Methods
public enum HTTPMethod: String {
   case GET
   case POST
   case DELETE
   case PUT
}

public protocol Fetcher {
    
    /// The path to be appended to `baseURL` to form the full `URL`.
    var path: String { get }
    
    /// The HTTP method used in the request.
    var method: HTTPMethod { get }
    
    /// The task to be used in the request.
    var task: BaseCodable? { get }
    
    /// The request header key values
    var header: BaseCodable? { get }
}
