//
//  HTTPRequest.swift
//  SwiftyHTTP
//
//  Created by Matt Tian on 04/04/2018.
//  Copyright © 2018 TTSY. All rights reserved.
//

import Foundation

/* HttpRequest is a base class.
 * Common used properties such as urlString, urlRequest and session are generated in this class.
 */
public class HttpRequest {
    
    var urlString: String?
    var urlRequest: URLRequest?
    var httpError: HttpError?
    
    let base: String
    let path: String
    let method: HttpMethod
    let params: [String: Any]?
    let headers: [String: String]?
    let session: URLSession
    
    /* ✅ */
    init(base: String, path: String, method: HttpMethod, params: [String: Any]?, headers: [String: String]?, sessionConfig: SessionConfig, timeoutForRequest: TimeInterval = 60.0, timeoutForResource: TimeInterval = 7 * 24 * 60.0) {
        self.base = base
        self.path = path
        self.method = method
        self.params = params
        self.headers = headers
        self.session = SessionManager.shared.getSession(with: sessionConfig, timeoutForRequest: timeoutForRequest, timeoutForResource: timeoutForResource)
        
        do {
            let encodedURL = try URLEncoding.encord(base: base, path: path, params: params)
            urlRequest = URLRequest(url: encodedURL)
        } catch (let error as URLEncodingError) {
            httpError = HttpError.encodingFailed(error)
        } catch {
            fatalError()
        }
        
        if case .get = method {
            urlString = try? URLEncoding.composeURLString(base: base, path: path, params: params)
        } else {
            urlString = try? URLEncoding.composeURLString(base: base, path: path)
        }
        
        guard let urlString = urlString else {
            httpError = HttpError.requestFailed(.invalidURL(""))
            return
        }
        
        guard let url = URL(string: urlString) else {
            httpError = HttpError.requestFailed(.invalidURL(""))
            return
        }
        
        urlRequest = URLRequest(url: url)
        urlRequest?.httpMethod = method.rawValue
        
        if let params = params, method != HttpMethod.get {
            urlRequest?.httpBody = try? JSONSerialization.data(withJSONObject: params, options: [])
        }
    }
    
}

/* ✅ */
extension HttpRequest {
    
    public func setAuthorization(username: String, password: String) -> Self {
        let loginString = "\(username):\(password)"
        let loginData = loginString.data(using: .utf8)!
        let base64LoginString = loginData.base64EncodedString()
        
        urlRequest?.setValue("Basic \(base64LoginString)", forHTTPHeaderField: "Authorization")
        return self
    }
    
    public func setAuthorization(basicToken: String) -> Self {
        let basic = "Basic "
        var token = basicToken
        if token.hasPrefix(basic) {
            let spaceIndex = token.index(of: " ")!
            token = String(token[spaceIndex...])
        }
        
        urlRequest?.setValue("Basic \(token)", forHTTPHeaderField: "Authorization")
        return self
    }
}

extension HttpRequest {
    
    // Create HTTP body for upload request
    func createHttpBody(with content: MultiPartContent, params: [String: Any]?, boundary: String) -> Data? {
        var body = Data()
        
        if let params = params {
            for (key, value) in params {
                body.append("--\(boundary)\r\n")
                body.append("Content-Disposition: form-data; name=\"\(key)\"\r\n\r\n")
                body.append("\(value)\r\n")
            }
        }
        
        body.append("--\(boundary)\r\n")
        body.append("Content-Disposition: form-data; name=\"\(content.name)\"; filename=\"\(content.fileName)\"\r\n")
        body.append("Content-Type: \(content.type)\r\n\r\n")
        if let data = content.data {
            body.append(data)
        }
        body.append("\r\n")
        body.append("--\(boundary)--\r\n")
        
        return body
    }
    
    func generateBoundary() -> String {
        return "Boundary-\(UUID().uuidString)"
    }
    
}

extension Data {
    mutating func append(_ string: String, using encoding: String.Encoding = .utf8) {
        if let data = string.data(using: encoding) {
            append(data)
        }
    }
}

// MARK: - HttpDataRequest

/* HttpDataRequest subclass from HttpRequest.
 * This class handles all requests which has a completion callback.
 * It will map all request to HttpDataTask class which will create
 * session tasks using completionHandler as the callback.
 */
public class HttpDataRequest: HttpRequest {
    
    let bodyData: Data?
    let taskType: TaskType
    
    /* ✅ */
    init(base: String, path: String, method: HttpMethod, params: [String: Any]?, headers: [String: String]?, sessionConfig: SessionConfig, timeoutForRequest: TimeInterval = 15.0, timeoutForResource: TimeInterval = 7 * 24 * 60.0, bodyData: Data? = nil, taskType: TaskType = .data) {
        self.bodyData = bodyData
        self.taskType = taskType
        super.init(base: base, path: path, method: method, params: params, headers: headers, sessionConfig: sessionConfig, timeoutForRequest: timeoutForRequest, timeoutForResource: timeoutForResource)
        
        urlRequest?.setValue("application/json", forHTTPHeaderField: "Content-Type")
        urlRequest?.setValue("application/json", forHTTPHeaderField: "Accept")
        
        if case .upload(let content) = taskType {
            let boundary = generateBoundary()
            if content.url != nil {
                urlRequest?.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
            } else {
                urlRequest?.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
            }
            urlRequest?.httpBody = createHttpBody(with: content, params: params, boundary: boundary)
        }
        
        if let headers = headers {
            for (key, value) in headers {
                urlRequest?.setValue(value, forHTTPHeaderField: key)
            }
        }
    }
    
    /* ✅ */
    @discardableResult
    public func go(completion: @escaping (HttpResponse) -> Void) -> HttpTask {
        guard httpError == nil else {
            completion(HttpResponse(error: httpError))
            return BlankHttpTask()
        }
        
        guard let request = urlRequest else {
            fatalError()
        }
        
        let dataTask = HttpDataTask(request: request, session: session, taskType: taskType, completion: completion)
        dataTask.resume()
        return dataTask
    }
    
}

// MARK: - HttpFileRequest

public typealias ProgressClosure = (Int64, Int64, Int64) -> Void
public typealias CompletedClosure = (URL?, HttpError?) -> Void

/* HttpFileRequest subclass from HttpRequest
 * This class handles download and upload requests with multi callback closures
 * It will map all request to HttpFileTask class which will create
 * session tasks using session delegate as the callback.
 * It also supports gourp action which could be run in sequential or concurrent mode.
 */
public class HttpFileRequest: HttpRequest {
    
    let taskType: TaskType
    let progress: ProgressClosure?
    let completed: CompletedClosure?
    
    let sessionManager = SessionManager.shared
    
    /* ✅ */
    init(base: String, path: String, method: HttpMethod, params: [String : Any]?, headers: [String : String]?, sessionConfig: SessionConfig, taskType: TaskType, progress: ProgressClosure? = nil, completed: CompletedClosure?) {
        self.taskType = taskType
        self.progress = progress
        self.completed = completed
        super.init(base: base, path: path, method: method, params: params, headers: headers, sessionConfig: sessionConfig)
        
        if case .upload(let content) = taskType {
            let boundary = generateBoundary()
            if content.url != nil {
                urlRequest?.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
            } else {
                urlRequest?.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
            }
            urlRequest?.httpBody = createHttpBody(with: content, params: params, boundary: boundary)
        }
        
        if let headers = headers {
            for (key, value) in headers {
                urlRequest?.setValue(value, forHTTPHeaderField: key)
            }
        }
    }
    
    /* ✅ */
    @discardableResult
    public func go() -> HttpTask {
        guard httpError == nil else {
            completed?(nil, httpError)
            return BlankHttpTask()
        }
        
        guard let request = urlRequest else {
            fatalError()
        }
        
        let fileTask = HttpFileTask(request: request, session: session, taskType: taskType, progress: progress, completed: completed)
        sessionManager[fileTask.sessionTask] = fileTask
        fileTask.resume()
        
        return fileTask
    }
    
}

// MARK: - HttpRequestGroup

enum GroupType {
    case sequential
    case concurrent
}

/* HttpRequestGroup is used for grouping HttpFileRequest instances.
 * GroupType determines the run mode for its requests, either sequential or concurrent.
 */
public class HttpRequestGroup {
    
    private var requestQueue = Queue<HttpFileRequest>()
    private var taskQueue = Queue<HttpFileTask>()
    
    let type: GroupType
    let sessionManager = SessionManager.shared
    
    /* ✅ */
    public var isEmpty: Bool {
        return requestQueue.isEmpty
    }
    
    /* ✅ */
    init(lhs: HttpFileRequest, rhs: HttpFileRequest, type: GroupType) {
        self.type = type
        requestQueue.enqueue(lhs)
        requestQueue.enqueue(rhs)
    }
    
    /* ✅ */
    func append(_ request: HttpFileRequest) -> HttpRequestGroup {
        requestQueue.enqueue(request)
        return self
    }
    
    /* ✅ */
    @discardableResult
    public func go() -> [HttpTask] {
        var tasks = [HttpTask]()
        var fileRequest = requestQueue.dequeue()
        
        if fileRequest != nil {
            let task = fileTask(for: fileRequest!)
            // Add first task to sessionTasks
            sessionManager[task.sessionTask] = task
            // Add this group to requestGroup, only used for sequential group
            sessionManager[task] = self
            tasks.append(task)
            task.resume()
        } else {
            return tasks
        }
        
        fileRequest = requestQueue.dequeue()
        while fileRequest != nil {
            let task = fileTask(for: fileRequest!)
            // Add each task to sessionTasks
            sessionManager[task.sessionTask] = task
            switch type {
            case .sequential:
                taskQueue.enqueue(task)
                // Update value typed taskQueue of requestGroup
                sessionManager[task] = self
            case .concurrent:
                task.resume()
            }
            tasks.append(task)
            fileRequest = requestQueue.dequeue()
        }
        
        return tasks
    }
    
    /* ✅ */
    func nextTask() {
        if let task = taskQueue.dequeue() {
            task.resume()
        }
    }
    
    private func fileTask(for request: HttpFileRequest) -> HttpFileTask {
        let urlRequest = request.urlRequest!
        let session = request.session
        let taskType = request.taskType
        let progress = request.progress
        let completed = request.completed
        
        return HttpFileTask(request: urlRequest, session: session, taskType: taskType, progress: progress, completed: completed)
    }
    
}

infix operator -->: AdditionPrecedence
infix operator |||: AdditionPrecedence

/* ✅ */
extension HttpFileRequest {
    
    public static func -->(_ left: HttpFileRequest, _ right: HttpFileRequest) -> HttpRequestGroup {
        return HttpRequestGroup(lhs: left, rhs: right, type: .sequential)
    }
    
    public static func |||(_ left: HttpFileRequest, _ right: HttpFileRequest) -> HttpRequestGroup {
        return HttpRequestGroup(lhs: left, rhs: right, type: .concurrent)
    }
    
    public static func &&(_ left: HttpFileRequest, _ right: HttpFileRequest) -> HttpRequestGroup {
        return HttpRequestGroup(lhs: left, rhs: right, type: .sequential)
    }
    
    public static func ||(_ left: HttpFileRequest, _ right: HttpFileRequest) -> HttpRequestGroup {
        return HttpRequestGroup(lhs: left, rhs: right, type: .concurrent)
    }
    
}

/* ✅ */
extension HttpRequestGroup {
    
    public static func -->(_ group: HttpRequestGroup, _ request: HttpFileRequest) -> HttpRequestGroup {
        return group.append(request)
    }
    
    public static func |||(_ group: HttpRequestGroup, _ request: HttpFileRequest) -> HttpRequestGroup {
        return group.append(request)
    }
    
    public static func &&(_ group: HttpRequestGroup, _ request: HttpFileRequest) -> HttpRequestGroup {
        return group.append(request)
    }
    
    public static func ||(_ group: HttpRequestGroup, _ request: HttpFileRequest) -> HttpRequestGroup {
        return group.append(request)
    }
    
}

class FakeDataRequest: HttpDataRequest {
    
    public override func go(completion: @escaping (HttpResponse) -> Void) -> HttpTask {
        completion(HttpResponse(fakeRequest: self))
        return BlankHttpTask()
    }
    
}
