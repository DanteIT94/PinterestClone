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
        
        view?.load(request: request)
    }
    
}
