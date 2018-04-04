//
//  HTTPStatus.swift
//  SwiftyHTTP
//
//  Created by Matt Tian on 04/04/2018.
//  Copyright © 2018 TTSY. All rights reserved.
//

import Foundation

public enum HttpStatus: Int {
    // Informational
    case `continue` = 100,
    switchingProtocols = 101
    
    // Successful
    case ok = 200,
    created = 201,
    accepted = 202,
    nonAuthoritativeInformation = 203,
    noContent = 204,
    resetContent = 205,
    partialContent = 206
    
    // Redirection
    case multipleChoices = 300,
    movedPermanently = 301,
    found = 302, seeOther = 303,
    notModified = 304,
    useProxy = 305,
    temporaryRedirect = 307
    
    // Client Error
    case badRequest = 400,
    unauthorized = 401,
    paymentRequired = 402,
    forbidden = 403,
    notFound = 404,
    methodNotAllowed = 405,
    notAcceptable = 406,
    proxyAuthenticationRequired = 407,
    requestTimeout = 408,
    conflict = 409,
    gone = 410,
    lengthRequired = 411,
    preconditionFailed = 412,
    requestEntityTooLarge = 413,
    requestUrlTooLong = 414,
    unsupportedMediaType = 415,
    requestedRangeNotSatisfiable = 416,
    expectationFailed = 417
    
    // Server Error
    case internalServerError = 500,
    notImplemented = 501,
    badGateway = 502,
    serviceUnavailable = 503,
    gatewayTimeout = 504,
    httpVersionNotSupported = 505
    
    // Unknown Error
    case unknown = 0
    
    init(code: Int) {
        self = HttpStatus(rawValue: code) ?? .unknown
    }
    
    var isSuccessful: Bool {
        return rawValue >= 200 && rawValue < 300
    }
    
    var description: String {
        switch self {
        case .continue:
            return "Continue"
        case .switchingProtocols:
            return "Switching Protocols"
        case .ok:
            return "OK"
        case .created:
            return "Created"
        case .accepted:
            return "Accepted"
        case .nonAuthoritativeInformation:
            return "Non-Authoritative Information"
        case .noContent:
            return "No Content"
        case .resetContent:
            return "Reset Content"
        case .partialContent:
            return "Partial Content"
        case .multipleChoices:
            return "Multiple Choices"
        case .movedPermanently:
            return "Moved Permanently"
        case .found:
            return "Found"
        case .seeOther:
            return "See Other"
        case .notModified:
            return "Not Modified"
        case .useProxy:
            return "Use Proxy"
        case .temporaryRedirect:
            return "Temporary Redirect"
        case .badRequest:
            return "Bad Request"
        case .unauthorized:
            return "Unauthorized"
        case .paymentRequired:
            return "Payment Required"
        case .forbidden:
            return "Forbidden"
        case .notFound:
            return "Not Found"
        case .methodNotAllowed:
            return "Method Not Allowed"
        case .notAcceptable:
            return "Not Acceptable"
        case .proxyAuthenticationRequired:
            return "Proxy Authentication Required"
        case .requestTimeout:
            return "Request Timeout"
        case .conflict:
            return "Conflict"
        case .gone:
            return "Gone"
        case .lengthRequired:
            return "Length Required"
        case .preconditionFailed:
            return "Precondition Failed"
        case .requestEntityTooLarge:
            return "Request Entity Too Large"
        case .requestUrlTooLong:
            return "Request-URL Too Long"
        case .unsupportedMediaType:
            return "Unsupported Media Type"
        case .requestedRangeNotSatisfiable:
            return "Requested Range Not Satisfiable"
        case .expectationFailed:
            return "Expectation Failed"
        case .internalServerError:
            return "Internal Server Error"
        case .notImplemented:
            return "Not Implemented"
        case .badGateway:
            return "Bad Gateway"
        case .serviceUnavailable:
            return "Service Unavailable"
        case .gatewayTimeout:
            return "Gateway Timeout"
        case .httpVersionNotSupported:
            return "HTTP Version Not Supported"
        case .unknown:
            return "Unknown HTTP Status Code"
        }
    }
    
}
