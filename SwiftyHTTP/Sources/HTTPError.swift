//
//  HTTPError.swift
//  SwiftyHTTP
//
//  Created by Matt Tian on 04/04/2018.
//  Copyright © 2018 TTSY. All rights reserved.
//

import Foundation

public enum HttpError: Error {
    
    case invalidURL(String)
    case requestFailed(RequestFailedReason)
    case encodingFailed(URLEncodingError)
    case responseError(Error)
    case statusCodeError(HttpStatus)
    
    public enum RequestFailedReason {
        case invalidURL(String)
        case paramsAndBodyDataUsedTogether
        case dataRequestInBackgroundSession
    }
    
}

public enum URLEncodingError: Error {
    case invalidURL(String)
    case invalidBase(String)
    case invalidPath(String)
    case invalidParams([String: Any])
}

extension HttpError: LocalizedError {
    
    public var localizedDescription: String {
        switch self {
        case .invalidURL(let urlString):
            return "Invalid URL string: \(urlString)"
        case .requestFailed(let reason):
            return reason.localizedDescription
        case .encodingFailed(let error):
            return error.localizedDescription
        case .responseError(let error):
            return error.localizedDescription
        case .statusCodeError(let statusCode):
            return "HTTP Status Code: \(statusCode.rawValue) - " + statusCode.description
        }
    }
    
}

extension HttpError.RequestFailedReason: LocalizedError {
    
    public var localizedDescription: String {
        switch self {
        case .invalidURL(let url):
            return "Invalid URL: \(url)"
        case .paramsAndBodyDataUsedTogether:
            return "Params and bodyData should not be used together in dataRequest"
        case .dataRequestInBackgroundSession:
            return "Data request can't run in background session"
        }
    }
    
}

extension URLEncodingError: LocalizedError {
    
    public var localizedDescription: String {
        switch self {
        case .invalidBase(let base):
            return "Invalid base: \(base)"
        case .invalidPath(let path):
            return "Invalid path: \(path)"
        case .invalidURL(let urlString):
            return "Invalid url: \(urlString)"
        case .invalidParams(let params):
            return "Invalid params: \(params)"
        }
    }
    
}
