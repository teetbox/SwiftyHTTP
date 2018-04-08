//
//  HTTPStatusTests.swift
//  SwiftyHTTP
//
//  Created by Matt Tian on 08/04/2018.
//  Copyright © 2018 TTSY. All rights reserved.
//

import XCTest

class HTTPStatusTests: XCTestCase {
    
    var sut: HttpStatus!
    
    func testInit() {
        sut = HttpStatus(code: 100)
        XCTAssertEqual(sut, .continue)
        XCTAssertEqual(sut.description, "Continue")
        
        sut = HttpStatus(code: 101)
        XCTAssertEqual(sut, .switchingProtocols)
        XCTAssertEqual(sut.description, "Switching Protocols")
        
        sut = HttpStatus(code: 200)
        XCTAssertEqual(sut, .ok)
        XCTAssertEqual(sut.description, "OK")
        
        sut = HttpStatus(code: 201)
        XCTAssertEqual(sut, .created)
        XCTAssertEqual(sut.description, "Created")
        
        sut = HttpStatus(code: 202)
        XCTAssertEqual(sut, .accepted)
        XCTAssertEqual(sut.description, "Accepted")
        
        sut = HttpStatus(code: 203)
        XCTAssertEqual(sut, .nonAuthoritativeInformation)
        XCTAssertEqual(sut.description, "Non-Authoritative Information")
        
        sut = HttpStatus(code: 204)
        XCTAssertEqual(sut, .noContent)
        XCTAssertEqual(sut.description, "No Content")
        
        sut = HttpStatus(code: 205)
        XCTAssertEqual(sut, .resetContent)
        XCTAssertEqual(sut.description, "Reset Content")
        
        sut = HttpStatus(code: 206)
        XCTAssertEqual(sut, .partialContent)
        XCTAssertEqual(sut.description, "Partial Content")
        
        sut = HttpStatus(code: 300)
        XCTAssertEqual(sut, .multipleChoices)
        XCTAssertEqual(sut.description, "Multiple Choices")
        
        sut = HttpStatus(code: 301)
        XCTAssertEqual(sut, .movedPermanently)
        XCTAssertEqual(sut.description, "Moved Permanently")
        
        sut = HttpStatus(code: 302)
        XCTAssertEqual(sut, .found)
        XCTAssertEqual(sut.description, "Found")
        
        sut = HttpStatus(code: 303)
        XCTAssertEqual(sut, .seeOther)
        XCTAssertEqual(sut.description, "See Other")
        
        sut = HttpStatus(code: 304)
        XCTAssertEqual(sut, .notModified)
        XCTAssertEqual(sut.description, "Not Modified")
        
        sut = HttpStatus(code: 305)
        XCTAssertEqual(sut, .useProxy)
        XCTAssertEqual(sut.description, "Use Proxy")
        
        sut = HttpStatus(code: 307)
        XCTAssertEqual(sut, .temporaryRedirect)
        XCTAssertEqual(sut.description, "Temporary Redirect")
        
        sut = HttpStatus(code: 400)
        XCTAssertEqual(sut, .badRequest)
        XCTAssertEqual(sut.description, "Bad Request")
        
        sut = HttpStatus(code: 401)
        XCTAssertEqual(sut, .unauthorized)
        XCTAssertEqual(sut.description, "Unauthorized")
        
        sut = HttpStatus(code: 402)
        XCTAssertEqual(sut, .paymentRequired)
        XCTAssertEqual(sut.description, "Payment Required")
        
        sut = HttpStatus(code: 403)
        XCTAssertEqual(sut, .forbidden)
        XCTAssertEqual(sut.description, "Forbidden")
        
        sut = HttpStatus(code: 404)
        XCTAssertEqual(sut, .notFound)
        XCTAssertEqual(sut.description, "Not Found")
        
        sut = HttpStatus(code: 405)
        XCTAssertEqual(sut, .methodNotAllowed)
        XCTAssertEqual(sut.description, "Method Not Allowed")
        
        sut = HttpStatus(code: 406)
        XCTAssertEqual(sut, .notAcceptable)
        XCTAssertEqual(sut.description, "Not Acceptable")
        
        sut = HttpStatus(code: 407)
        XCTAssertEqual(sut, .proxyAuthenticationRequired)
        XCTAssertEqual(sut.description, "Proxy Authentication Required")
        
        sut = HttpStatus(code: 408)
        XCTAssertEqual(sut, .requestTimeout)
        XCTAssertEqual(sut.description, "Request Timeout")
        
        sut = HttpStatus(code: 409)
        XCTAssertEqual(sut, .conflict)
        XCTAssertEqual(sut.description, "Conflict")
        
        sut = HttpStatus(code: 410)
        XCTAssertEqual(sut, .gone)
        XCTAssertEqual(sut.description, "Gone")
        
        sut = HttpStatus(code: 411)
        XCTAssertEqual(sut, .lengthRequired)
        XCTAssertEqual(sut.description, "Length Required")
        
        sut = HttpStatus(code: 412)
        XCTAssertEqual(sut, .preconditionFailed)
        XCTAssertEqual(sut.description, "Precondition Failed")
        
        sut = HttpStatus(code: 413)
        XCTAssertEqual(sut, .requestEntityTooLarge)
        XCTAssertEqual(sut.description, "Request Entity Too Large")
        
        sut = HttpStatus(code: 414)
        XCTAssertEqual(sut, .requestUrlTooLong)
        XCTAssertEqual(sut.description, "Request-URL Too Long")
        
        sut = HttpStatus(code: 415)
        XCTAssertEqual(sut, .unsupportedMediaType)
        XCTAssertEqual(sut.description, "Unsupported Media Type")
        
        sut = HttpStatus(code: 416)
        XCTAssertEqual(sut, .requestedRangeNotSatisfiable)
        XCTAssertEqual(sut.description, "Requested Range Not Satisfiable")
        
        sut = HttpStatus(code: 417)
        XCTAssertEqual(sut, .expectationFailed)
        XCTAssertEqual(sut.description, "Expectation Failed")
        
        sut = HttpStatus(code: 500)
        XCTAssertEqual(sut, .internalServerError)
        XCTAssertEqual(sut.description, "Internal Server Error")
        
        sut = HttpStatus(code: 501)
        XCTAssertEqual(sut, .notImplemented)
        XCTAssertEqual(sut.description, "Not Implemented")
        
        sut = HttpStatus(code: 502)
        XCTAssertEqual(sut, .badGateway)
        XCTAssertEqual(sut.description, "Bad Gateway")
        
        sut = HttpStatus(code: 503)
        XCTAssertEqual(sut, .serviceUnavailable)
        XCTAssertEqual(sut.description, "Service Unavailable")
        
        sut = HttpStatus(code: 504)
        XCTAssertEqual(sut, .gatewayTimeout)
        XCTAssertEqual(sut.description, "Gateway Timeout")
        
        sut = HttpStatus(code: 505)
        XCTAssertEqual(sut, .httpVersionNotSupported)
        XCTAssertEqual(sut.description, "HTTP Version Not Supported")
        
        sut = HttpStatus(code: 999)
        XCTAssertEqual(sut, .unknown)
        XCTAssertEqual(sut.description, "Unknown HTTP Status Code")
    }
    
    func testIsSuccessful() {
        sut = HttpStatus(code: 199)
        XCTAssertFalse(sut.isSuccessful)
        
        sut = HttpStatus(code: 200)
        XCTAssert(sut.isSuccessful)
        
        sut = HttpStatus(code: 299)
        XCTAssertFalse(sut.isSuccessful)
        
        sut = HttpStatus(code: 300)
        XCTAssertFalse(sut.isSuccessful)
        
        sut = HttpStatus(code: 400)
        XCTAssertFalse(sut.isSuccessful)
        
        sut = HttpStatus(code: 500)
        XCTAssertFalse(sut.isSuccessful)
    }
    
}
