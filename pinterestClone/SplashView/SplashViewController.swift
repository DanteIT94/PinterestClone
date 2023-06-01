//
//  SplashViewController.swift
//  pinterestClone
//
//  Created by Денис on 23.04.2023.
//

import UIKit
import ProgressHUD

class SplashViewController: UIViewController {
    //MARK: - Private Properties
    private let oauth2Service = OAuth2Service()
    private let tokenStorage = OAuth2TokenStorage()
    private let profileService: ProfileServiceProtocol
    private let profileImageService: ProfileImageServiceProtocol
    private let ShowAuthSegueIdentifier = "ShowAuth"
    
    private var splashLogoImage: UIImageView!
    
    init(profileService: ProfileServiceProtocol, profileImageService: ProfileImageServiceProtocol) {
        self.profileService = profileService
        self.profileImageService = profileImageService
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Life Cycle
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        createSplashLogoImage(safeArea: view.safeAreaLayoutGuide)
        
        if let token = tokenStorage.token {
            fetchProfile(token: token)
        } else {
            presentAuthViewController()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setNeedsStatusBarAppearanceUpdate()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        .lightContent
    }
    
    // MARK: - Private Methods
    private func switchToTabBarController() {
        guard let window = UIApplication.shared.windows.first else {
                    assertionFailure("Invalid config")
                    showAlertViewController()
                    return
                }
        let tabBarController = TabBarController(profileService: profileService, profileImageService: profileImageService)
        window.rootViewController = tabBarController
    }
    ///Переход на AuthViewController
    private func presentAuthViewController() {
        let authVC = AuthViewController()
        authVC.delegate = self
        authVC.modalPresentationStyle = .fullScreen
        present(authVC, animated: true)
    }
}

//MARK: - createSplashLogo
extension SplashViewController {
    ///Отрисовываем дубликат стартового Лого
    private func createSplashLogoImage(safeArea: UILayoutGuide) {
        view.backgroundColor = .YPBlack
        splashLogoImage = UIImageView()
        splashLogoImage.image = UIImage(named: "LaunchScreen")
        splashLogoImage.contentMode = .scaleAspectFill
        splashLogoImage.clipsToBounds = true
        
        splashLogoImage.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(splashLogoImage)
        splashLogoImage.heightAnchor.constraint(equalToConstant: 75.11).isActive = true
        splashLogoImage.widthAnchor.constraint(equalToConstant: 72.52).isActive = true
        splashLogoImage.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        splashLogoImage.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
    }
}

// MARK: - AuthViewControllerDelegate
extension SplashViewController: AuthViewControllerDelegate {
    func authViewController(_ vc: AuthViewController, didAuthenticateWithCode code: String) {
        dismiss(animated: true) { [weak self] in
            guard let self = self else { return }
            self.fetchOAuthToken(code)
        }
        UIBlockingProgressHUD.show()
    }
    
    private func fetchOAuthToken(_ code: String) {
        oauth2Service.fetchOAuthToken(code) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success (let token):
                self.fetchProfile(token: token)
            case .failure:
                showAlertViewController()
                
                break
            }
            UIBlockingProgressHUD.dismiss()
        }
    }
    
    private func fetchProfile(token: String) {
        profileService.fetchProfile(token) {[weak self] result in
            DispatchQueue.main.async {
                guard let self = self else {return}
                switch result {
                case .success (let result):
                    self.profileImageService.fetchProfileImageURL(username: result.username) { _ in }
                    self.switchToTabBarController()
                case .failure:
                    self.showAlertViewController()
                    break
                }
                UIBlockingProgressHUD.dismiss()
            }
        }
    }

    private func showAlertViewController() {
        let alertVC = UIAlertController(
            title: "Что-то пошло не так(",
            message: "Не удалось войти в систему",
            preferredStyle: .alert)
        let action = UIAlertAction(title: "Ok", style: .default)
        alertVC.addAction(action)
        present(alertVC, animated: true)
    }
}
