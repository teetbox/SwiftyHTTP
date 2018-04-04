//
//  HTTPTask.swift
//  SwiftyHTTP
//
//  Created by Matt Tian on 04/04/2018.
//  Copyright © 2018 TTSY. All rights reserved.
//

import Foundation

enum TaskType {
    case data
    case download
    case upload(MultiPartContent)
}

public protocol HttpTask {
    func suspend()
    func resume()
    func cancel()
}

class BlankHttpTask: HttpTask {
    func suspend() {}
    func resume() {}
    func cancel() {}
}

class HttpDataTask: HttpTask {
    
    let sessionTask: URLSessionTask
    
    /* ✅ */
    init(request: URLRequest, session: URLSession, taskType: TaskType = .data, completion: @escaping (HttpResponse) -> Void) {
        
        switch taskType {
        case .data:
            sessionTask = session.dataTask(with: request) { (data, response, error) in
                let httpResponse = HttpResponse(data: data, response: response, error: error)
                completion(httpResponse)
            }
        case .download:
            sessionTask = session.downloadTask(with: request) { (url, response, error) in
                let httpResponse = HttpResponse(url: url, response: response, error: error)
                completion(httpResponse)
            }
        case .upload(let content):
            if let url = content.url {
                sessionTask = session.uploadTask(with: request, fromFile: url) { (data, response, error) in
                    let httpResponse = HttpResponse(data: data, response: response, error: error)
                    completion(httpResponse)
                }
            } else {
                sessionTask = session.uploadTask(with: request, from: request.httpBody) { (data, response, error) in
                    let httpResponse = HttpResponse(data: data, response: response, error: error)
                    completion(httpResponse)
                }
            }
        }
    }
    
    func suspend() {
        sessionTask.suspend()
    }
    
    func resume() {
        sessionTask.resume()
    }
    
    func cancel() {
        sessionTask.cancel()
    }
    
}

extension HttpFileTask: Hashable {
    var hashValue: Int {
        return sessionTask.taskIdentifier
    }
    
    static func ==(lhs: HttpFileTask, rhs: HttpFileTask) -> Bool {
        return lhs.sessionTask == rhs.sessionTask
    }
}

class HttpFileTask: HttpTask {
    
    let sessionTask: URLSessionTask
    
    let taskType: TaskType
    let progress: ProgressClosure?
    let completed: CompletedClosure?
    
    var state: URLSessionTask.State {
        return sessionTask.state
    }
    
    /* ✅ */
    init(request: URLRequest, session: URLSession, taskType: TaskType, progress: ProgressClosure?, completed:  CompletedClosure?) {
        self.taskType = taskType
        self.progress = progress
        self.completed = completed
        
        switch taskType {
        case .data:
            // No need for data taskType
            fatalError("HttpFileTask can only be initialized by download or upload tsakType")
        case .download:
            sessionTask = session.downloadTask(with: request)
        case .upload(let content):
            if let url = content.url {
                sessionTask = session.uploadTask(with: request, fromFile: url)
            } else {
                guard let bodyData = request.httpBody else {
                    fatalError()
                }
                sessionTask = session.uploadTask(with: request, from: bodyData)
            }
        }
    }
    
    func suspend() {
        sessionTask.suspend()
    }
    
    func resume() {
        sessionTask.resume()
    }
    
    func cancel() {
        sessionTask.cancel()
    }
    
}
