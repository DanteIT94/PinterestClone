//
//  WebViewPresenter.swift
//  pinterestClone
//
//  Created by Денис on 29.05.2023.
//

import UIKit

fileprivate let UnsplashAuthorizeURLString = "https://unsplash.com/oauth/authorize"

public protocol WebViewPresenterProtocol: AnyObject {
    var view: WebViewViewControllerProtocol? {get set}
    func viewDidLoad()
    func didUpdateProgressValue(_ newValue: Double)
}

final class WebViewPresenter:WebViewPresenterProtocol {

    //-MARK: Properties
    weak var view: WebViewViewControllerProtocol?
    
    //-MARK: Methods
    
    func viewDidLoad() {
        var urlComponents = URLComponents(string: UnsplashAuthorizeURLString)!
        urlComponents.queryItems = [
            URLQueryItem(name: "client_id", value: AccessKey),
            URLQueryItem(name: "redirect_uri", value: RedirectURI),
            URLQueryItem(name: "response_type", value: "code"),
            URLQueryItem(name: "scope", value: AccessScope)
        ]
        let url  = urlComponents.url!
        let request = URLRequest(url: url)
        
        
        didUpdateProgressValue(0)
        
        view?.load(request: request)
    }
    
    func didUpdateProgressValue(_ newValue: Double) {
        let newProgressValue = Float(newValue)
        view?.setProgressValue(newProgressValue)
        
        let shouldHideProgress = shouldHideProgress(for: newProgressValue)
        view?.setProgressHidden(shouldHideProgress)
    }
    
    ///Функция вычисления того, должен ли быть скрыт progressView во WebView (ДЛЯ ТЕСТИРОВАНИЯ). 
    private func shouldHideProgress(for value: Float) -> Bool {
        abs(value - 1.0) <= 0.0001
    }
    
}
