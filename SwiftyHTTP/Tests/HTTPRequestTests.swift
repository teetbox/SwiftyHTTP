//
//  HTTPRequestTests.swift
//  SwiftyHTTP
//
//  Created by Matt Tian on 08/04/2018.
//  Copyright © 2018 TTSY. All rights reserved.
//

import XCTest

extension TaskType: Equatable {
    public static func ==(lhs: TaskType, rhs: TaskType) -> Bool {
        return "\(lhs)" == "\(rhs)"
    }
}

class HTTPRequestTests: XCTestCase {
    
    var sut: HttpRequest!
    
    let fakeBase = "http://www.fake.com"
    let fakePath = "/fake/path"
    
    override func setUp() {
        sut = HttpRequest(base: fakeBase, path: fakePath, method: .put, params: ["key": "value"], headers: ["key": "value"], sessionConfig: .standard)
    }
    
    func testInit() {
        XCTAssertEqual(sut.base, fakeBase)
        XCTAssertEqual(sut.path, fakePath)
        XCTAssertEqual(sut.method, .put)
        XCTAssertEqual(sut.params!["key"] as! String, "value")
        XCTAssertEqual(sut.headers!["key"], "value")
        XCTAssertEqual(sut.session, SessionManager.shared.getSession(with: .standard))
        XCTAssertNotNil(sut.urlString)
        XCTAssertNotNil(sut.urlRequest)
    }
    
    func testDataRequest() {
        sut = HttpDataRequest(base: fakeBase, path: fakePath, method: .get, params: ["key": "value"], headers: ["key": "value"], sessionConfig: .standard, bodyData: Data(), taskType: .data)
        XCTAssertEqual((sut as! HttpDataRequest).bodyData, Data())
        XCTAssertEqual((sut as! HttpDataRequest).taskType, .data)
        
        sut = HttpDataRequest(base: fakeBase, path: fakePath, method: .get, params: nil, headers: nil, sessionConfig: .standard, taskType: .download)
        XCTAssertEqual((sut as! HttpDataRequest).taskType, .download)
        
        let content = MultiPartContent(name: "", fileName: "", type: .png, data: Data())
        sut = HttpDataRequest(base: fakeBase, path: fakePath, method: .get, params: nil, headers: nil, sessionConfig: .standard, taskType: .upload(content))
        XCTAssertEqual((sut as! HttpDataRequest).taskType, .upload(content))
    }
    
    func testDataRequestWithTimeout() {
        SessionManager.shared.reset()
        sut = HttpDataRequest(base: fakeBase, path: fakePath, method: .get, params: ["key": "value"], headers: ["key": "value"], sessionConfig: .standard, timeoutForRequest: 15.0, timeoutForResource: 15.0, bodyData: Data(), taskType: .data)
        
        XCTAssertEqual(sut.session.configuration.timeoutIntervalForRequest, 15.0)
        XCTAssertEqual(sut.session.configuration.timeoutIntervalForResource, 15.0)
    }
    
    func testGoForDataRequest() {
        sut = HttpDataRequest(base: fakeBase, path: fakePath, method: .get, params: nil, headers: nil, sessionConfig: .ephemeral, bodyData: nil)
        
        (sut as! HttpDataRequest).go(completion: { _ in })
        let httpTask = (sut as! HttpDataRequest).go(completion: { _ in })
        XCTAssert(httpTask is HttpDataTask)
    }
    
    func testFakeDataRequest() {
        sut = FakeDataRequest(base: fakeBase, path: fakePath, method: .get, params: ["key": "value"], headers: ["key": "value"], sessionConfig: .standard, bodyData: Data(), taskType: .data)
        XCTAssertEqual(sut.base, fakeBase)
        XCTAssertEqual(sut.path, fakePath)
        XCTAssertEqual(sut.method, .get)
        XCTAssertEqual(sut.params!["key"] as! String, "value")
        XCTAssertEqual(sut.headers!["key"], "value")
        XCTAssertEqual(sut.session, SessionManager.shared.getSession(with: .standard))
        XCTAssertEqual((sut as! HttpDataRequest).bodyData, Data())
        XCTAssertEqual((sut as! HttpDataRequest).taskType, .data)
    }
    
    func testFileRequest() {
        let progress: ProgressClosure = { _, _, _ in }
        let completed: CompletedClosure = { _, _ in }
        
        sut = HttpFileRequest(base: fakeBase, path: fakePath, method: .get, params: ["key": "value"], headers: ["key": "value"], sessionConfig: .standard, taskType: .download, progress: progress, completed: completed)
        XCTAssertEqual(sut.base, fakeBase)
        XCTAssertEqual(sut.path, fakePath)
        XCTAssertEqual(sut.method, .get)
        XCTAssertEqual(sut.params!["key"] as! String, "value")
        XCTAssertEqual(sut.headers!["key"], "value")
        XCTAssertEqual(sut.session, SessionManager.shared.getSession(with: .standard))
        XCTAssertNotNil(sut.urlString)
        XCTAssertNotNil(sut.urlRequest)
        XCTAssertEqual((sut as! HttpFileRequest).taskType, .download)
        XCTAssertNotNil((sut as! HttpFileRequest).progress)
        XCTAssertNotNil((sut as! HttpFileRequest).completed)
        XCTAssertEqual((sut as! HttpFileRequest).sessionManager, SessionManager.shared)
        
        let content = MultiPartContent(name: "", fileName: "", type: .png, data: Data())
        sut = HttpFileRequest(base: fakeBase, path: fakePath, method: .post, params: ["key": "value"], headers: ["key": "value"], sessionConfig: .background("bg"), taskType: .upload(content), progress: progress, completed: completed)
        XCTAssertEqual(sut.method, .post)
        XCTAssertEqual(sut.session, SessionManager.shared.getSession(with: .background("bg")))
        XCTAssertEqual((sut as! HttpFileRequest).taskType, .upload(content))
        XCTAssertNotNil((sut as! HttpFileRequest).progress)
        XCTAssertNotNil((sut as! HttpFileRequest).completed)
        XCTAssertEqual((sut as! HttpFileRequest).sessionManager, SessionManager.shared)
    }
    
    func testGoForFileRequest() {
        sut = HttpFileRequest(base: fakeBase, path: fakePath, method:.get, params: nil, headers: nil, sessionConfig: .background("bg"), taskType: .download, completed: nil)
        
        (sut as! HttpFileRequest).go()
        let task = (sut as! HttpFileRequest).go()
        XCTAssert(task is HttpFileTask)
        
        let sessionManager = SessionManager.shared
        let fileTask = task as! HttpFileTask
        let savedTask: HttpTask = sessionManager[fileTask.sessionTask]!
        XCTAssertNotNil(savedTask)
    }
    
    func testRequestGroup() {
        let fileRequest = HttpFileRequest(base: fakeBase, path: fakePath, method: .get, params: nil, headers: nil, sessionConfig: .standard, taskType: .download, completed: nil)
        let fileRequest2 = HttpFileRequest(base: fakeBase, path: fakePath, method: .get, params: nil, headers: nil, sessionConfig: .standard, taskType: .download, completed: nil)
        let fileRequest3 = HttpFileRequest(base: fakeBase, path: fakePath, method: .get, params: nil, headers: nil, sessionConfig: .standard, taskType: .download, completed: nil)
        
        let group = HttpRequestGroup(lhs: fileRequest, rhs: fileRequest2, type: .sequential)
        XCTAssertFalse(group.isEmpty)
        XCTAssertEqual(group.type, .sequential)
        
        _ = group.append(fileRequest3)
        XCTAssertFalse(group.isEmpty)
        
        let tasks = group.go()
        XCTAssertEqual(tasks.count, 3)
    }
    
    func testGoForSequentialRequestGroup() {
        let file = HttpFileRequest(base: fakeBase, path: fakePath, method: .get, params: nil, headers: nil, sessionConfig: .standard, taskType: .download, completed: nil)
        let file2 = HttpFileRequest(base: fakeBase, path: fakePath, method: .get, params: nil, headers: nil, sessionConfig: .standard, taskType: .download, completed: nil)
        let file3 = HttpFileRequest(base: fakeBase, path: fakePath, method: .get, params: nil, headers: nil, sessionConfig: .standard, taskType: .download, completed: nil)
        
        let tasks = (file --> file2 --> file3).go()
        
        XCTAssertEqual(tasks.count, 3)
        XCTAssertEqual((tasks[0] as! HttpFileTask).state, .running)
        XCTAssertEqual((tasks[1] as! HttpFileTask).state, .suspended)
        XCTAssertEqual((tasks[2] as! HttpFileTask).state, .suspended)
    }
    
    func testGoForConcurrentRequestGroup() {
        let file = HttpFileRequest(base: fakeBase, path: fakePath, method: .get, params: nil, headers: nil, sessionConfig: .standard, taskType: .download, completed: nil)
        let file2 = HttpFileRequest(base: fakeBase, path: fakePath, method: .get, params: nil, headers: nil, sessionConfig: .standard, taskType: .download, completed: nil)
        let file3 = HttpFileRequest(base: fakeBase, path: fakePath, method: .get, params: nil, headers: nil, sessionConfig: .standard, taskType: .download, completed: nil)
        
        let tasks = (file ||| file2 ||| file3).go()
        
        XCTAssertEqual(tasks.count, 3)
        XCTAssertEqual((tasks[0] as! HttpFileTask).state, .running)
        XCTAssertEqual((tasks[1] as! HttpFileTask).state, .running)
        XCTAssertEqual((tasks[2] as! HttpFileTask).state, .running)
    }
    
    func testSessionTaskDidComplete() {
        let file = HttpFileRequest(base: fakeBase, path: fakePath, method: .get, params: nil, headers: nil, sessionConfig: .standard, taskType: .download, completed: nil)
        let file2 = HttpFileRequest(base: fakeBase, path: fakePath, method: .get, params: nil, headers: nil, sessionConfig: .standard, taskType: .download, completed: nil)
        let file3 = HttpFileRequest(base: fakeBase, path: fakePath, method: .get, params: nil, headers: nil, sessionConfig: .standard, taskType: .download, completed: nil)
        
        let group = file --> file2 --> file3
        let tasks = group.go()
        
        XCTAssertEqual(tasks.count, 3)
        XCTAssertEqual((tasks[0] as! HttpFileTask).state, .running)
        XCTAssertEqual((tasks[1] as! HttpFileTask).state, .suspended)
        XCTAssertEqual((tasks[2] as! HttpFileTask).state, .suspended)
        
        group.nextTask()
        XCTAssertEqual((tasks[1] as! HttpFileTask).state, .running)
        XCTAssertEqual((tasks[2] as! HttpFileTask).state, .suspended)
        
        group.nextTask()
        XCTAssertEqual((tasks[2] as! HttpFileTask).state, .running)
    }
    
    func testSetAuthorizationWithUsernameAndPassword() {
        let loginString = "username:password"
        let loginData = loginString.data(using: .utf8)!
        let base64LoginString = loginData.base64EncodedString()
        
        _ = sut.setAuthorization(username: "username", password: "password")
        
        XCTAssertEqual(sut.urlRequest?.value(forHTTPHeaderField: "Authorization"), "Basic \(base64LoginString)")
    }
    
    func testSetAuthorizationWithBasicToken() {
        _ = sut.setAuthorization(basicToken: "ABC")
        
        XCTAssertEqual(sut.urlRequest?.value(forHTTPHeaderField: "Authorization"), "Basic ABC")
    }
    
}
