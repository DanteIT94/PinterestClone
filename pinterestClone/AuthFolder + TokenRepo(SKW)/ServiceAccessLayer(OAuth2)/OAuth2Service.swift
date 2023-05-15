//
//  OAuth2Services.swift
//  pinterestClone
//
//  Created by Денис on 22.04.2023.
//

import UIKit

//MARK: - Класс-Сервис -> Слой Доступа к сервису (Service Access Layer)
final class OAuth2Service {
    //MARK: - Properties
    static let shared = OAuth2Service()
    
    private let urlSession = URLSession.shared
    
    private var task: URLSessionTask?
    
    private var lastCode: String?
    
    private let tokenStorage = OAuth2TokenStorage()

    private (set)  var authToken: String? {
        get {
            return tokenStorage.token
        }
        set {
            tokenStorage.token = newValue
        }
    }
    
    //MARK: - Methods
    
    ///Объявление метода fetchAuthToken для выполнения запроса на получение токена аутентификации.
    func fetchOAuthToken(_ code: String, completion: @escaping(Result<String, Error>) -> Void ) {
        ///проверка что метод вызывается из главного потока
        assert(Thread.isMainThread)
        ///Проверка на Post-запрос № 2 (Укороченная)
        //Если lastCode != code -> мы должны сделать запрос
        if lastCode == code {return}
        //Старый запрос отменяем, но если task==nil -> ничего не выполняем
        task?.cancel()

        lastCode = code
        
        let request = authTokenRequest(code: code)
        let task = object(for: request) { [weak self] result in
            DispatchQueue.main.async {
                guard let self = self else {return}
                switch result {
                case .success(let body):
                    let authToken = body.accessToken
                    self.authToken = authToken
                    completion(.success(authToken))//в случае успеха, токен аутентификации извлекается из ответа на запрос и сохраняется в OAuth2TokenStorage и в свойстве authToken
                    self.task = nil
                case .failure(let error):
                    completion(.failure(error))
                    self.lastCode = nil
                }
            }
        }
            self.task = task
            task.resume()
    }
}

//MARK: - Расширение для класса OAuth2Services
extension OAuth2Service {
    private func object(for request: URLRequest, completion: @escaping (Result<OAuthTokenResponseBody, Error>) -> Void) -> URLSessionTask {
        let decoder = JSONDecoder()
        return urlSession.data(for: request) { (result: Result<Data, Error>) in
            let response = result.flatMap {data -> Result<OAuthTokenResponseBody, Error> in
                Result { try decoder.decode(OAuthTokenResponseBody.self, from: data) }
            }
            completion(response)
        }
    }
    
    ///Определяем функцию authTokenRequest(code:), которая возвращает URLRequest.
    ///
    ///Вызываем метод makeHTTPRequest на классе URLRequest, передавая значения пути, метода, и базового URL, а также некоторых параметров, которые требуются для запроса токена аутентификации.
    private func authTokenRequest(code: String) -> URLRequest {
        URLRequest.makeHTTPRequest(
            path: "/oauth/token"
            + "?client_id=\(AccessKey)"
            + "&&client_secret=\(SecretKey)"
            + "&&redirect_uri=\(RedirectURI)"
            + "&&code=\(code)"
            + "&&grant_type=authorization_code",
            httpMethod: "POST"
            //        baseURL: URL(string: "https://unsplash.com")!
        )
    }
}

//MARK: - HTTP Request
extension URLRequest {
    static func makeHTTPRequest( path: String,
                                 httpMethod: String,
                                 baseURL: URL = URL(string: "https://unsplash.com")!) -> URLRequest {
        var request = URLRequest(url: URL(string: path, relativeTo: baseURL)!)
        request.httpMethod = httpMethod
        return request
    }
}

//MARK: - Network Connection
extension URLSession {
    func data(for request: URLRequest,
              completion: @escaping (Result<Data, Error>) -> Void) -> URLSessionTask  {
        ///Эта часть кода определяет замыкание fulfillCompletion, которое будет вызываться внутри метода dataTask после завершения запроса. В замыкании определен асинхронный вызов completion на главной очереди, передавая результат в качестве аргумента.
        let fulfillCompletion: (Result<Data, Error>) -> Void = { result in
            DispatchQueue.main.async {
                completion(result)
            }
        }
        ///Здесь определяется задача task с использованием метода dataTask(with:completionHandler:). При завершении запроса вызывается замыкание completionHandler, которое принимает параметры data, response и error.
        ///
        ///Если data, response и statusCode определены и код состояния находится в диапазоне 200-299, то вызывается замыкание fulfillCompletion с результатом в виде .success(data).
        let task = dataTask(with: request, completionHandler: {data, response, error in
            if let data = data,
               let response = response,
               let statusCode = (response as? HTTPURLResponse)?.statusCode
            {
                if 200..<300 ~= statusCode {
                    fulfillCompletion(.success(data))
                } else {
                    fulfillCompletion(.failure(NetworkError.httpStatusCode(statusCode)))
                }
            } else if let error = error {
                fulfillCompletion(.failure(NetworkError.urlRequestError(error)))
            } else {
                fulfillCompletion(.failure(NetworkError.urlSessionError))
            }
        })
        task.resume()
        return task
    }
}
