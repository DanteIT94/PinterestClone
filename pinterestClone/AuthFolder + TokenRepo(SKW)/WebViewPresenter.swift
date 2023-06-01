//
//  WebViewPresenter.swift
//  pinterestClone
//
//  Created by Денис on 29.05.2023.
//

import UIKit

//fileprivate let UnsplashAuthorizeURLString = "https://unsplash.com/oauth/authorize"

public protocol WebViewPresenterProtocol: AnyObject {
    var view: WebViewViewControllerProtocol? {get set}
    func viewDidLoad()
    func didUpdateProgressValue(_ newValue: Double)
    func code (from url: URL) -> String?
}

final class WebViewPresenter:WebViewPresenterProtocol {

    //MARK: Properties
    weak var view: WebViewViewControllerProtocol?
    
    //MARK: AuthHelper
    var authHelper: AuthHelperProtocol
    
    init(authHelper: AuthHelperProtocol) {
        self.authHelper = authHelper
    }
    //-------------------------------------------------
    
    //-MARK: Methods
    
    func viewDidLoad() {
        let request = authHelper.authRequest()
        
        view?.load(request: request)
        
        didUpdateProgressValue(0)
    }
    
    func code (from url: URL) -> String? {
        authHelper.code(from: url)
    }
    
    func didUpdateProgressValue(_ newValue: Double) {
        let newProgressValue = Float(newValue)
        view?.setProgressValue(newProgressValue)
        
        let shouldHideProgress = shouldHideProgress(for: newProgressValue)
        view?.setProgressHidden(shouldHideProgress)
    }
    
    ///Функция вычисления того, должен ли быть скрыт progressView во WebView (ДЛЯ ТЕСТИРОВАНИЯ). 
    func shouldHideProgress(for value: Float) -> Bool {
        abs(value - 1.0) <= 0.0001
    }
    
}
