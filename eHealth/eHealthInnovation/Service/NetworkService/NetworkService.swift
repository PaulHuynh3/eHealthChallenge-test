//
//  NetworkService.swift
//  eHealthInnovation
//
//  Created by Paul Huynh on 2021-10-07.
//


import Foundation

class NetworkService: FetchService {

    func fetch<T: Codable>(method: RequestMethod, url: URL?, result: @escaping (Result<T, NetworkError>) -> Void) {
        guard let url = url else {
            result(.failure(.invalidURL))
            return
        }
        var request = URLRequest(url: url)
        request.httpMethod = method.httpMethod

        let task = URLSession.shared.dataTask(with: url) { data, res, err in
            if let error = err {
                result(.failure(.error(error)))
                return
            }

            guard let data = data else {
                result(.failure(.noData))
                return
            }

            let decoder = JSONDecoder()
            do {
                let object = try decoder.decode(T.self, from: data)
                DispatchQueue.main.async {
                    result(.success(object))
                }
            } catch {
                DispatchQueue.main.async {
                    result(.failure(.error(error)))
                }
            }
        }
        task.resume()
    }
}

protocol FetchService {
    func fetch<T: Codable>(method: RequestMethod, url: URL?, result: @escaping (Result<T, NetworkError>) -> Void)
}

enum RequestMethod {
    case get
    case post
    case put
    case delete

    var httpMethod: String {
        switch self {
        case .get:
            return "GET"
        case .post:
            return "POST"
        case .put:
            return "PUT"
        case .delete:
            return "DELETE"
        }
    }
}

enum NetworkError: Error {
    case error(Error)
    case invalidURL
    case noData
}
