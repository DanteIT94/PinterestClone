//
//  URLSession - GenericFunc.swift
//  pinterestClone
//
//  Created by Денис on 08.05.2023.
//

import UIKit

extension URLSession {
    enum NetworkError: Error {
        case httpStatusCode(Int)
        case urlRequestError(Error)
        case urlSessionError
    }
    
    
    func objectTask<T: Decodable>(
        for request: URLRequest,
        completion: @escaping (Result<T, Error>) -> Void
    ) -> URLSessionTask {
        let task = dataTask(with: request) { data, response, error in
            ///проверяем наличие ошибок
            guard error == nil else {
                DispatchQueue.main.async {
                    completion(.failure(NetworkError.urlRequestError(error!)))
                }
                return
            }
            
            ///Проверка на успешный HTTP-статус кода
            guard let httpResponse = response as? HTTPURLResponse,
                  (200..<300).contains(httpResponse.statusCode) else {
                DispatchQueue.main.async {
                    completion(.failure(NetworkError.httpStatusCode(0)))
                }
                return
            }
            ///Декодирование данных в тип "Т"
            do {
                let decoder = JSONDecoder()
                let decodedObject = try decoder.decode(T.self, from: data!)
                DispatchQueue.main.async {
                    completion(.success(decodedObject))
                }
            } catch {
                DispatchQueue.main.async {
                    completion(.failure(NetworkError.urlSessionError))
                }
            }
        }
        return task
    }
}
