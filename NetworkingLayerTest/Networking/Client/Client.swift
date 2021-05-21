//
//  Client.swift
//  NetworkingLayerTest
//
//  Created by Karol Nadratowski on 21/05/2021.
//

import Combine
import Foundation

typealias ResponsePublisher<R: Decodable> = AnyPublisher<R, Error>

/// Enum of API Errors
enum APIError: Error {
    /// Encoding issue when trying to send data.
    case encodingError(Error?)
    /// Encoding issue when trying to send data.
    case decodingError(Error?)
    /// No data recieved from the server.
    case noData
    /// The server response was invalid (unexpected format).
    case invalidResponse
    /// The request was rejected: 400-499
    case badRequest(String?)
    /// Encountered a server error.
    case serverError(String?)
    /// There was an error parsing the data.
    case parseError(String?)
    /// Authorization error: 401-403
    case unauthorized
    /// Unknown error.
    case unknown
   
}

// Inspirations:
// https://danielbernal.co/writing-a-networking-library-with-combine-codable-and-swift-5/
// https://medium.com/if-let-swift-programming/generic-networking-layer-using-combine-in-swift-ui-d23574c20368

protocol ClientProtocol: AnyObject {
    func execute<O: Decodable>(target: Target,
                               decodingType: O.Type,
                               queue: DispatchQueue,
                               retries: Int) -> AnyPublisher<O, Error>
    
    func execute<I: Encodable, O: Decodable>(target: Target,
                                             input: I,
                                             decodingType: O.Type,

                                             queue: DispatchQueue,
                                             retries: Int) -> AnyPublisher<O, Error>
}

final class Client: ClientProtocol {
    func execute<O: Decodable>(target: Target,
                               decodingType: O.Type,
                               queue: DispatchQueue = .main,
                               retries: Int = 0) -> AnyPublisher<O, Error> {
        let urlRequest = target.request
        
        return URLSession.shared.dataTaskPublisher(for: urlRequest)
            .tryMap {
                guard let response = $0.response as? HTTPURLResponse else {
                    throw APIError.invalidResponse
                }
                if (200...299).contains(response.statusCode) {
                    return $0.data
                } else if [401, 403].contains(response.statusCode) {
                    throw APIError.unauthorized
                } else {
                    throw APIError.invalidResponse
                }
            }
            .decode(type: O.self, decoder: target.decoder)
            .mapError { error in
                APIError.decodingError(error)
            }
            .receive(on: queue)
            .retry(retries)
            .eraseToAnyPublisher()
    }
    
    func execute<I: Encodable, O: Decodable>(target: Target,
                                             input: I,
                                             decodingType: O.Type,
                                             queue: DispatchQueue = .main,
                                             retries: Int = 0) -> AnyPublisher<O, Error> {
        Just(input)
            .encode(encoder: target.encoder)
            .mapError { error in
                APIError.encodingError(error)
            }
            .map { data -> URLRequest in
                var request = target.request
                request.httpBody = data
                return request
            }
            .flatMap {
                URLSession.shared.dataTaskPublisher(for: $0)
                    .tryMap {
                        guard let response = $0.response as? HTTPURLResponse else {
                            throw APIError.invalidResponse
                        }
                        if (200...299).contains(response.statusCode) {
                            return $0.data
                        } else if [401, 403].contains(response.statusCode) {
                            throw APIError.unauthorized
                        } else {
                            throw APIError.invalidResponse
                        }
                    }
                    .decode(type: O.self, decoder: target.decoder)
                    .mapError { error in
                        APIError.decodingError(error)
                    }
                    .receive(on: queue)
                    .retry(retries)
            }
            .eraseToAnyPublisher()
    }
}
