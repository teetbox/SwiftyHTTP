//
//  HTTPErrorTests.swift
//  SwiftyHTTP
//
//  Created by Matt Tian on 08/04/2018.
//  Copyright © 2018 TTSY. All rights reserved.
//

import XCTest

class HTTPErrorTests: XCTestCase {
    
    var sut: HttpError!
    
    override func setUp() {
        super.setUp()
    }
    
    func testInvalidURL() {
        sut = HttpError.invalidURL("~!@#$")
        XCTAssertEqual(sut.localizedDescription, "Invalid URL string: ~!@#$")
    }
    
    func testUnsupportedSession() {
        sut = HttpError.requestFailed(.dataRequestInBackgroundSession)
        XCTAssertEqual(sut.localizedDescription, "Data request can't run in background session")
    }
    
    func testParamsAndBodyDataUsedTogether() {
        sut = HttpError.requestFailed(.paramsAndBodyDataUsedTogether)
        XCTAssertEqual(sut.localizedDescription, "Params and bodyData should not be used together in dataRequest")
    }
    
}
