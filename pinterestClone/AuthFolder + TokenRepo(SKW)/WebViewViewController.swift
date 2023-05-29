//
//  WebViewViewController.swift
//  pinterestClone
//
//  Created by Денис on 19.04.2023.
//

import UIKit
import WebKit


public protocol WebViewViewControllerProtocol: AnyObject {
    var presenter: WebViewPresenterProtocol? {get set}
    func load(request: URLRequest)
}

protocol WebViewViewControllerDelegate: AnyObject {
    ///WebViewViewController получил код
    func webViewViewController(_ vc: WebViewViewController, didAuthenticateWithCode code: String)
    ///Пользователь нажал кнопку назад и отменил авторизацию
    func webViewViewControllerDidCancel(_ vc: WebViewViewController)
}

final class WebViewViewController: UIViewController, WebViewViewControllerProtocol {

    
    
    weak var delegate: WebViewViewControllerDelegate?
    var presenter: WebViewPresenterProtocol?
    
    //MARK: - Private Properties
    private var estimatedProgressObservation: NSKeyValueObservation?
    
    //MARK: - Calculated Properties
    private let webView: WKWebView = {
        let webView = WKWebView()
        webView.translatesAutoresizingMaskIntoConstraints = false
        return webView
    }()
    
    ///Шкала прогресса загрузки веба
    private let progressView: UIProgressView = {
        let progressView = UIProgressView()
        progressView.translatesAutoresizingMaskIntoConstraints = false
        progressView.tintColor = .YPBackground
        return progressView
    }()
    
    private let backButton: UIButton = {
        let backButton = UIButton()
        backButton.translatesAutoresizingMaskIntoConstraints = false
        backButton.setTitle("", for: .normal)
        backButton.setImage(UIImage(named: "nav_back_button"), for: .normal)
        backButton.imageView?.contentMode = .scaleAspectFill
        backButton.addTarget(nil, action: #selector(didTapBackButton), for: .touchUpInside)
        return backButton
    }()
    
    //MARK: - ViewLifeCicle
    override func viewDidLoad() {
        super.viewDidLoad()
        createWebViewLayout()
        
        webView.navigationDelegate = self
        presenter?.viewDidLoad()
        
        configureProgressBarObserver()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
    }
    
    //MARK: - Methods
    ///Подсчет шкалы загрузки  веб-страницы
    private func updateProgress() {
        progressView.progress = Float(webView.estimatedProgress)
        progressView.isHidden = fabs(webView.estimatedProgress - 1.0) <= 0.0001
    }
    
    ///Конфигурируем URL-запрос для авторизации (ПЕРЕНЕСЕНО В PRESENTER)
//    private func createAuthURL() -> URL {
//        var urlComponents = URLComponents(string: UnsplashAuthorizeURLString)!
//        urlComponents.queryItems = [
//            URLQueryItem(name: "client_id", value: AccessKey),
//            URLQueryItem(name: "redirect_uri", value: RedirectURI),
//            URLQueryItem(name: "response_type", value: "code"),
//            URLQueryItem(name: "scope", value: AccessScope)
//        ]
//        let url  = urlComponents.url!
//        return url
//    }
    
   ///Привязываем обновление шкалы
    private func configureProgressBarObserver(){
        estimatedProgressObservation = webView.observe(
            \.estimatedProgress,
             options: [],
             changeHandler: {[weak self] _, _ in
                 guard let self = self else {return}
                 self.updateProgress()
             })
    }
    
    func load(request: URLRequest) {
        webView.load(request)
}
    
    ///Создаем WebView версткой + раставляем констрейты
    private func createWebViewLayout() {
        view.backgroundColor = .YPWhite
        
        view.addSubview(webView)
        view.addSubview(backButton)
        view.addSubview(progressView)
        
        ///Задаем пул констрейтов
        NSLayoutConstraint.activate([
            webView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            webView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            webView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            webView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            //-------------------------------------------------
            backButton.widthAnchor.constraint(equalToConstant: 24),
            backButton.heightAnchor.constraint(equalToConstant: 24),
            backButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
            backButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            //-------------------------------------------------
            progressView.centerYAnchor.constraint(equalTo: backButton.centerYAnchor),
            progressView.leadingAnchor.constraint(equalTo: backButton.trailingAnchor, constant: 8),
            progressView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -29)
        ])
        
    }
    
        @objc func didTapBackButton(_ sender: Any?) {
        delegate?.webViewViewControllerDidCancel(self)
    }
}

//MARK: - WKNavigationDelegate
extension WebViewViewController: WKNavigationDelegate {
    func webView(_ webView: WKWebView,
                 decidePolicyFor navigationAction: WKNavigationAction,
                 decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        if let code = code(from: navigationAction) {
            delegate?.webViewViewController(self, didAuthenticateWithCode: code)
            //TODO: process code
            decisionHandler(.cancel)
        } else {
            //TODO: process code
            decisionHandler(.allow)
        }
    }
    
    ///функция code(from:) - она возвращает код авторизации, если он получен
    private func code(from navigationAction: WKNavigationAction) -> String? {
        if
            let url = navigationAction.request.url,
            let urlComponents = URLComponents(string: url.absoluteString),
            urlComponents.path == "/oauth/authorize/native",
            let items = urlComponents.queryItems,
            let codeItem = items.first(where: {$0.name == "code"})
        {
            return codeItem.value
        } else {
            return nil
        }
    }
}

