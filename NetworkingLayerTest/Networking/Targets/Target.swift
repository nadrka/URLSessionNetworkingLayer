//
//  Endpoint.swift
//  URLSessionNetworkingTest
//
//  Created by Karol Nadratowski on 14/05/2021.
//
import Foundation

public typealias Parameters = [String: Any]?
public typealias Headers = [String: String]?
public typealias Path = String

public enum Method: String {
    case get = "GET"
    case post = "POST"
    case put = "PUT"
    case patch = "PATCH"
    case delete = "DELETE"
}

public protocol Target {
    var method: Method { get }
    var base: String { get }
    var path: Path { get }
    var headers: Headers { get }
    var queryItems: [URLQueryItem]? { get }
    var request: URLRequest { get }
    var decoder: JSONDecoder { get }
    var encoder: JSONEncoder { get }
}

extension Target {
    var headers: Headers {
        nil
    }
    
    var queryItems: [URLQueryItem]? {
        nil
    }
    
    var url: URL {
        var components = URLComponents()
        components.host = base
        components.path = path
        components.queryItems = queryItems ?? []
        
        guard let url = components.url else {
            preconditionFailure("Invalid URL components: \(components)")
        }
        
        return url
    }
    
    var request: URLRequest {
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = method.rawValue
            
        headers?.forEach { (key, value) in
            urlRequest.setValue(value, forHTTPHeaderField: key)
        }
        
        return urlRequest
    }
}

// MARK: JSON
extension Target {
    var decoder: JSONDecoder {
        JSONDecoder()
    }
    
    var encoder: JSONEncoder {
        JSONEncoder()
    }
}
