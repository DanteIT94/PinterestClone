//
//  AuthViewController.swift
//  pinterestClone
//
//  Created by Денис on 18.04.2023.
//

import UIKit

protocol AuthViewControllerDelegate: AnyObject {
    func authViewController(_ vc: AuthViewController, didAuthenticateWithCode code: String)
}

final class AuthViewController: UIViewController {
    //MARK: - Properties
    weak var delegate: AuthViewControllerDelegate?
    
    //MARK: - Private Properties
    private let segueIdentifier = "ShowWebView"
    private let oAuth2Service = OAuth2Service.shared
    
    //MARK: - Calculated Properties
    private let authLogo: UIImageView = {
        let authLogo = UIImageView()
        authLogo.translatesAutoresizingMaskIntoConstraints = false
        authLogo.image = UIImage(named: "auth_screen_logo")
        authLogo.contentMode = .scaleAspectFill
        return authLogo
    }()
    
    private let enterButton: UIButton = {
        let enterButton = UIButton()
        enterButton.translatesAutoresizingMaskIntoConstraints = false
        enterButton.backgroundColor = .YPWhite
        enterButton.setTitle("Войти", for: .normal)
        enterButton.setTitleColor(.YPBlack, for: .normal)
        enterButton.titleLabel?.font = .systemFont(ofSize: 17, weight: .bold)
        enterButton.layer.cornerRadius = 16
        enterButton.layer.masksToBounds = true
        enterButton.addTarget(nil, action: #selector(enterButtonTapped), for: .touchUpInside)
        return enterButton
    }()
    
    
    //MARK: - ViewLifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        createLayout()
    }
    
    //MARK: - Private Methods
    
    @objc func enterButtonTapped() {
        let webVC = WebViewViewController()
        let webViewPresenter = WebViewPresenter()
        
        webVC.delegate = self
        
        webVC.presenter = webViewPresenter
        webViewPresenter.view = webVC
        
        webVC.modalPresentationStyle = .fullScreen
        present(webVC, animated: true)
        
        
    }
    
    private func createLayout() {
        view.backgroundColor = .YPBlack
        
        view.addSubview(enterButton)
        view.addSubview(authLogo)
        
        NSLayoutConstraint.activate([
            authLogo.widthAnchor.constraint(equalToConstant: 60),
            authLogo.heightAnchor.constraint(equalToConstant: 60),
            authLogo.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            authLogo.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            //--------------------------------------------------------------
            enterButton.heightAnchor.constraint(equalToConstant: 48),
            enterButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            enterButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            enterButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -90)//возможны корректировки
        ])
    }
}

// MARK: -WebViewViewControllerDelegate через расширение
extension AuthViewController: WebViewViewControllerDelegate {
    func webViewViewControllerDidCancel(_ vc: WebViewViewController) {
        dismiss(animated: true)
    }
    
    func webViewViewController(_ vc: WebViewViewController, didAuthenticateWithCode code: String) {
        delegate?.authViewController(self, didAuthenticateWithCode: code)
    }
}
