//
//  SwiftyHTTPAPITests.swift
//  SwiftyHTTP
//
//  Created by Matt Tian on 04/04/2018.
//  Copyright © 2018 TTSY. All rights reserved.
//

import XCTest
import SwiftyHTTP_macOS


class SwiftyHTTPAPITests: XCTestCase {
    
    var sut: SwiftyHTTP!
    
    let fakeBase = "http://www.fake.com"
    let fakePath = "/fake/path"
    
    override func setUp() {
        super.setUp()
        
        sut = SwiftyHTTP(base: fakeBase)
    }
    
    func testGet() {
        sut.get(fakePath) { response in }
        sut.get(fakePath, params: ["key": "value"]) { response in }
        sut.get(fakePath, headers: ["key": "value"]) { response in }
        sut.get(fakePath, params: ["key": "value"], headers: ["key": "value"]) { response in }
        
        let task = sut.get(fakePath) { _ in }
        XCTAssertNotNil(task)
    }
    
    func testPut() {
        sut.put(fakePath) { response in }
        sut.put(fakePath, params: ["key": "value"]) { response in }
        sut.put(fakePath, headers: ["key": "value"]) { response in }
        sut.put(fakePath, params: ["key": "value"], headers: ["key": "value"]) { response in }
        
        let task = sut.put(fakePath) { _ in }
        XCTAssertNotNil(task)
    }
    
    func testPost() {
        sut.post(fakePath) { response in }
        sut.post(fakePath, params: ["key": "value"]) { response in }
        sut.post(fakePath, bodyData: Data()) { response in }
        sut.post(fakePath, headers: ["key": "value"]) { response in }
        sut.post(fakePath, params: ["key": "value"], headers: ["key": "value"]) { response in }
        sut.post(fakePath, bodyData: Data(), headers: ["key": "value"]) { response in }
        
        let task = sut.post(fakePath) { _ in }
        XCTAssertNotNil(task)
    }
    
    func testDelete() {
        sut.delete(fakePath) { response in }
        sut.delete(fakePath, params: ["key": "value"]) { response in }
        sut.delete(fakePath, headers: ["key": "value"]) { response in }
        sut.delete(fakePath, params: ["key": "value"], headers: ["key": "value"]) { response in }
        
        let task = sut.delete(fakePath) { _ in }
        XCTAssertNotNil(task)
    }
    
    func testDataRequest() {
        var request = sut.dataRequest(path: fakePath)
        XCTAssertNotNil(request)
        
        request = sut.dataRequest(path: fakePath, method: .post)
        XCTAssertNotNil(request)
        
        request = sut.dataRequest(path: fakePath, params: ["key": "value"])
        XCTAssertNotNil(request)
        
        request = sut.dataRequest(path: fakePath, headers: ["key": "value"])
        XCTAssertNotNil(request)
        
        request = sut.dataRequest(path: fakePath, headers: ["key": "value"], bodyData: Data())
        XCTAssertNotNil(request)
        
        request = sut.dataRequest(path: fakePath, method: .put, params: ["key": "value"], headers: ["key": "value"])
        XCTAssertNotNil(request)
        
        request.go(completion: { _ in })
    }
    
    func testDownload() {
        sut.download(fakePath) { response in }
        sut.download(fakePath, params: ["key": "value"]) { response in }
        sut.download(fakePath, headers: ["key": "value"]) { response in }
        sut.download(fakePath, params: ["key": "value"], headers: ["key": "value"]) { response in }
        
        let task = sut.download(fakePath, completion: { _ in })
        XCTAssertNotNil(task)
    }
    
    func testUpload() {
        let content = MultiPartContent(name: "file", fileName: "swift.jpg", type: .jpg, data: Data())
        sut.upload(fakePath, content: content, completion: { _ in })
        
        let task = sut.upload(fakePath, content: content, params: ["key": "value"], headers: ["key": "value"], completion: { _ in })
        XCTAssertNotNil(task)
    }
    
    func testFileRequestForDownload() {
        var request = sut.fileRequest(downloadPath: fakePath, completed: { _, _ in })
        XCTAssertNotNil(request)
        
        request = sut.fileRequest(downloadPath: fakePath, method: .get, completed: { _, _ in })
        XCTAssertNotNil(request)
        
        request = sut.fileRequest(downloadPath: fakePath, params: ["key": "value"], completed: { _, _ in })
        XCTAssertNotNil(request)
        
        request = sut.fileRequest(downloadPath: fakePath, headers: ["key": "value"], completed: { _, _ in })
        XCTAssertNotNil(request)
        
        request = sut.fileRequest(downloadPath: fakePath, progress:{ _, _, _ in }, completed: { _, _ in })
        XCTAssertNotNil(request)
        
        request = sut.fileRequest(downloadPath: fakePath, method: .get, params: ["key": "value"], headers: ["key": "value"], progress: { _, _, _ in }, completed: { _, _ in })
        XCTAssertNotNil(request)
        
        let task = request.go()
        XCTAssertNotNil(task)
    }
    
    func testFileRequestForUpload() {
        let content = MultiPartContent(name: "", fileName: "", type: .png, data: Data())
        var request = sut.fileRequest(uploadPath: fakePath, content: content, progress:{ _, _, _ in }, completed: { _, _ in })
        XCTAssertNotNil(request)
        
        request = sut.fileRequest(uploadPath: fakePath, method: .post, content: content, params: ["key": "value"], headers: ["key": "value"], progress: nil, completed: { _, _ in })
        XCTAssertNotNil(request)
        
        let task = request.go()
        XCTAssertNotNil(task)
    }
    
    func testFakeResponse() {
        let fakeData = "data".data(using: .utf8)
        sut.fakeResponse = HttpResponse(data: fakeData)
        
        sut.get(fakePath) { response in
            XCTAssertEqual(response.data, fakeData)
        }
        
        sut.put(fakePath) { response in
            XCTAssertEqual(response.data, fakeData)
        }
        
        sut.post(fakePath) { response in
            XCTAssertEqual(response.data, fakeData)
        }
        
        sut.post(fakePath, params: ["key": "value"]) { response in
            XCTAssertEqual(response.data, fakeData)
        }
        
        sut.post(fakePath, bodyData: fakeData) { response in
            XCTAssertEqual(response.data, fakeData)
        }
        
        sut.delete(fakePath) { response in
            XCTAssertEqual(response.data, fakeData)
        }
        
        let url = URL(string: "/download/path")
        sut.fakeResponse = HttpResponse(url: url)
        
        sut.download(fakePath) { response in
            XCTAssertEqual(response.url, url)
        }
        
        let error = HttpError.statusCodeError(.badRequest)
        let content = MultiPartContent(name: "", fileName: "", type: .png, data: Data())
        sut.fakeResponse = HttpResponse(error: error)
        
        sut.upload(fakePath, content: content) { response in
            XCTAssertEqual(response.error?.localizedDescription, error.localizedDescription)
        }
    }
    
    func testTimeout() {
        XCTAssertEqual(sut.timeoutForRequest, 60.0)
        XCTAssertEqual(sut.timeoutForResource, 7 * 24 * 60.0)
        
        sut.timeoutForRequest = 15.0
        sut.timeoutForResource = 15.0
        
        XCTAssertEqual(sut.timeoutForRequest, 15.0)
        XCTAssertEqual(sut.timeoutForResource, 15.0)
    }
    
}
