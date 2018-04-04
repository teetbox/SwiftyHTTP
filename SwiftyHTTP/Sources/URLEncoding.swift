//
//  URLEncoding.swift
//  SwiftyHTTP
//
//  Created by Matt Tian on 04/04/2018.
//  Copyright © 2018 TTSY. All rights reserved.
//

import Foundation

struct URLEncoding {
    
    static func encord(base: String, path: String, params: [String: Any]?) throws -> URL {
        guard let encodedBase = base.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) else {
            throw URLEncodingError.invalidBase(base)
        }
        
        guard let encodedPath = path.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed) else {
            throw URLEncodingError.invalidPath(path)
        }
        
        guard let encodedURL = URL(string: encodedBase + encodedPath) else {
            throw URLEncodingError.invalidURL(base + path)
        }
        
        return encodedURL
    }
    
    static func composeURLString(base: String, path: String, params: [String: Any]? = nil) throws -> String {
        var urlString = base + path
        if let params = params {
            urlString += queryString(with: params)
        }
        return urlString
    }
    
    static func encord(base: String, path: String) throws -> URL {
        guard let url = URL(string: base + path) else {
            throw HttpError.requestFailed(.invalidURL(base + path))
        }
        
        return url
    }
    
    static func encord(urlString: String, method: HttpMethod, params: [String: Any]?) throws -> URL {
        if let url = composeURL(urlString: urlString, method: method, params: params) {
            return url
        } else {
            throw HttpError.requestFailed(.invalidURL(urlString))
        }
    }
    
    private static func composeURL(urlString: String, method: HttpMethod, params: [String: Any]?) -> URL? {
        guard method == .get, let params = params else {
            return nil
        }
        var url = urlString
        url += queryString(with: params)
        return URL(string: url)
    }
    
    private static func queryString(with params: [String: Any]) -> String {
        var queryString = "?"
        
        for (key, value) in params {
            queryString += "\(key)=\(value)&"
        }
        
        return queryString
    }
    
}
