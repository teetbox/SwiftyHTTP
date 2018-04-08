//
//  SessionManager.swift
//  SwiftyHTTP
//
//  Created by Matt Tian on 04/04/2018.
//  Copyright © 2018 TTSY. All rights reserved.
//

import Foundation

class SessionManager: NSObject {
    
    static let shared = SessionManager()
    
    private var standard: URLSession?
    private var ephemeral: URLSession?
    private var background: URLSession?
    
    private var sessionTasks = [URLSessionTask: HttpFileTask]()
    private var requestGroup = [HttpFileTask: HttpRequestGroup]()
    
    private override init() {}
    
    /* ✅ */
    subscript(sessionTask: URLSessionTask) -> HttpFileTask? {
        set {
            sessionTasks[sessionTask] = newValue
        }
        get {
            return sessionTasks[sessionTask]
        }
    }
    
    /* ✅ */
    subscript(fileTask: HttpFileTask) -> HttpRequestGroup? {
        set {
            requestGroup[fileTask] = newValue
        }
        get {
            return requestGroup[fileTask]
        }
    }
    
    /* ✅ */
    func getSession(with config: SessionConfig, timeoutForRequest: TimeInterval = 60.0, timeoutForResource: TimeInterval = 7 * 24 * 60.0) -> URLSession {
        let configuration = getURLSessionConfig(with: config, timeoutForRequest: timeoutForRequest, timeoutForResource: timeoutForResource)
        
        switch config {
        case .standard:
            if standard == nil {
                standard = URLSession(configuration: configuration, delegate: self, delegateQueue: nil)
            }
            return standard!
        case .ephemeral:
            if ephemeral == nil {
                ephemeral = URLSession(configuration: configuration, delegate: self, delegateQueue: nil)
            }
            return ephemeral!
        case .background(let identifier):
            if (background == nil || background!.configuration.identifier != identifier) {
                background = URLSession(configuration: configuration, delegate: self, delegateQueue: nil)
            }
            return background!
        }
    }
    
    private func getURLSessionConfig(with config: SessionConfig, timeoutForRequest: TimeInterval, timeoutForResource: TimeInterval) -> URLSessionConfiguration {
        let sessionConfig: URLSessionConfiguration
        
        switch config {
        case .standard:
            sessionConfig = URLSessionConfiguration.default
        case .ephemeral:
            sessionConfig = URLSessionConfiguration.ephemeral
        case .background(let identifier):
            sessionConfig = URLSessionConfiguration.background(withIdentifier: identifier)
        }
        
        sessionConfig.timeoutIntervalForRequest = timeoutForRequest
        sessionConfig.timeoutIntervalForResource = timeoutForResource
        return sessionConfig
    }
    
    /* ✅ */
    func reset() {
        standard = nil
        ephemeral = nil
        background = nil
    }
    
}

extension SessionManager: URLSessionDelegate, URLSessionTaskDelegate, URLSessionDataDelegate, URLSessionDownloadDelegate {
    
    // URLSessionDelegate
    
    
    // URLSessionTaskDelegate
    
    func urlSession(_ session: URLSession, task: URLSessionTask, didSendBodyData bytesSent: Int64, totalBytesSent: Int64, totalBytesExpectedToSend: Int64) {
        if let fileTask = sessionTasks[task] {
            fileTask.progress?(bytesSent, totalBytesSent, totalBytesExpectedToSend)
        }
    }
    
    // When download task completed, this function is called.
    func urlSession(_ session: URLSession, task: URLSessionTask, didCompleteWithError error: Error?) {
        guard error != nil else { return }
        if let fileTask = sessionTasks[task] {
            fileTask.completed?(nil, HttpError.responseError(error!))
            if let group = requestGroup[fileTask] {
                group.nextTask()
            }
        }
    }
    
    // URLSessionDataDelegate
    
    // When upload task completed, this function is called.
    func urlSession(_ session: URLSession, dataTask: URLSessionDataTask, didReceive response: URLResponse, completionHandler: @escaping (URLSession.ResponseDisposition) -> Void) {
        if let httpURLResponse = response as? HTTPURLResponse {
            let statusCode = httpURLResponse.statusCode
            let httpStatus = HttpStatus(code: statusCode)
            
            var httpError: HttpError?
            if !httpStatus.isSuccessful {
                httpError = HttpError.statusCodeError(httpStatus)
            }
            
            if let fileTask = sessionTasks[dataTask] {
                fileTask.completed?(httpURLResponse.url, httpError)
                if let group = requestGroup[fileTask] {
                    group.nextTask()
                }
            }
        }
    }
    
    // URLSessionDownloadDelegate

    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didWriteData bytesWritten: Int64, totalBytesWritten: Int64, totalBytesExpectedToWrite: Int64) {
        if let fileTask = sessionTasks[downloadTask] {
            fileTask.progress?(bytesWritten, totalBytesWritten, totalBytesExpectedToWrite)
        }
    }
    
    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didFinishDownloadingTo location: URL) {
        if let fileTask = sessionTasks[downloadTask] {
            fileTask.completed?(location, nil)
            if let group = requestGroup[fileTask] {
                group.nextTask()
            }
        }
    }
    
}
