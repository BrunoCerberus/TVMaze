//
//  FetcherError.swift
//  TVMaze
//
//  Created by bruno on 25/06/23.
//

import Foundation

public enum FetcherError: Error {
    case generic
    case connection
    case parse(String)
}

extension FetcherError: Equatable {
    public var message: String {
        return localizedDescription
    }
    
    public var code: Int {
        switch self {
        case .generic:
            return 1
        case .connection:
            return 2
        case .parse:
            return 3
        }
    }
}

extension FetcherError: LocalizedError {
    public var localizedDescription: String {
        switch self {
        case .generic:
            return "Something went wrong, please try again"
        case .connection:
            return "Connection issues"
        case let .parse(errorMessage):
            return "An error ocurred when trying to parse the request: \(errorMessage)"
        }
    }
}

extension Error {
    public func getDescription() -> String {
        return (self as NSError).description
    }
}
