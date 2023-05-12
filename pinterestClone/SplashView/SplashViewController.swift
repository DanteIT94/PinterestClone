//
//  SplashViewController.swift
//  pinterestClone
//
//  Created by Денис on 23.04.2023.
//

import UIKit
import ProgressHUD

class SplashViewController: UIViewController {
    private let oauth2Service = OAuth2Service()
    private let tokenStorage = OAuth2TokenStorage()
    private let profileService = ProfileService.shared
    private let profileImageService = ProfileImageService.shared
    private let ShowAuthSegueIdentifier = "ShowAuth"
    
    private var splashLogoImage: UIImageView!
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if let token = tokenStorage.token {
            fetchProfile(token: token)
        } else {
            //            performSegue(withIdentifier: ShowAuthSegueIdentifier, sender: nil)
            presentAuthViewController()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setNeedsStatusBarAppearanceUpdate()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        createSplashLogoImage(safeArea: view.safeAreaLayoutGuide)
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
        let tabBarController = UIStoryboard(
            name: "Main",
            bundle: .main)
            .instantiateViewController(withIdentifier: "TabBarViewController")
        window.rootViewController = tabBarController
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
    
    private func presentAuthViewController() {
//        let authVC = AuthViewController()
        let authVC = UIStoryboard(
            name: "Main",
            bundle: .main).instantiateViewController(withIdentifier: "AuthViewController")
//        authVC.delegate = self
        authVC.modalPresentationStyle = .fullScreen
        present(authVC, animated: true)
    }
}

extension SplashViewController {
    //    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    //        ///Проверяем переход на авторизацию
    //        if segue.identifier == ShowAuthSegueIdentifier {
    //            ///Идем к первому контролеру навигации
    //            guard
    //                let navigationController = segue.destination as? UINavigationController,
    //                let viewController = navigationController.viewControllers[0] as? AuthViewController
    //            else {fatalError("Failed to prepare for \(ShowAuthSegueIdentifier)")}
    //
    //            ///Делегатом контроллера устанавливаем SplashVC
    //            viewController.delegate = self
    //        } else {
    //            super.prepare(for: segue, sender: sender)
    //        }
    //    }
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
                UIBlockingProgressHUD.dismiss()
                break
            }
        }
    }
    
    private func fetchProfile(token: String) {
        profileService.fetchProfile(token) {[weak self] result in
            DispatchQueue.main.async {
                guard let self = self else {return}
                switch result {
                case .success (let result):
                    self.profileImageService.fetchProfileImageURL(username: result.username) { _ in }
                    UIBlockingProgressHUD.dismiss()
                    self.switchToTabBarController()
                case .failure:
                    let alert = UIAlertController(title: "Что-то пошло не так(", message: "Не удалось войти в систему", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "Ок", style: .default, handler: nil))
                    self.present(alert, animated: true, completion: nil)
                    break
                }
            }
        }
    }
}
