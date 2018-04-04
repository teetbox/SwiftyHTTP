//
//  HTTPResponse.swift
//  SwiftyHTTP
//
//  Created by Matt Tian on 04/04/2018.
//  Copyright © 2018 TTSY. All rights reserved.
//

import Foundation

protocol Response {
    var data: Data? { get }
    var urlResponse: URLResponse? { get }
    var error: HttpError? { get }
}

public struct HttpResponse: Response {
    
    public var data: Data?
    public var url: URL?    // Download task completion callback parameter
    public var urlResponse: URLResponse?
    public var error: HttpError?
    
    var fakeRequest: HttpDataRequest?
    
    public var json: [String: Any]? {
        return parseJSON()
    }
    
    public var jsonArray: [Any]? {
        return parseJSONArray()
    }
    
    /* ✅ */
    public init(data: Data? = nil, url: URL? = nil, response: URLResponse? = nil, error: Error? = nil) {
        self.data = data
        self.url = url
        self.urlResponse = response
        self.error = (error == nil) ? nil : error as? HttpError ?? HttpError.responseError(error!)
    }
    
    // MARK: - Methods
    
    private func parseJSON() -> [String: Any]? {
        guard data != nil else { return nil }
        
        if let json = try? JSONSerialization.jsonObject(with: data!) as? [String: Any] {
            return json
        }
        return nil
    }
    
    private func parseJSONArray() -> [Any]? {
        guard data != nil else { return nil }
        
        if let jsonArray = try? JSONSerialization.jsonObject(with: data!) as? [Any] {
            return jsonArray
        }
        return nil
    }
    
}

extension HttpResponse {
    
    init(fakeRequest: HttpRequest) {
        self.fakeRequest = fakeRequest as? HttpDataRequest
    }
    
}

struct DecodableResponse<T: Decodable>: Response {
    
    let data: Data?
    let urlResponse: URLResponse?
    let error: HttpError?
    
    var entity: T?
    
    init(data: Data?, response: URLResponse?, error: Error?) {
        self.data = data
        self.urlResponse = response
        self.error = (error == nil) ? nil : error as? HttpError ?? HttpError.responseError(error!)
    }
    
}
