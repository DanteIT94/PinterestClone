//
//  SplashViewController.swift
//  pinterestClone
//
//  Created by Денис on 23.04.2023.
//

import UIKit
import ProgressHUD

class SplashViewController: UIViewController {
    private let tokenStorage = OAuth2TokenStorage()
    private let ShowAuthSegueIdentifier = "ShowAuth"
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if let _ = tokenStorage.token {
            /// Если токен сохранен, значит пользователь уже авторизован. Можно перенаправить на экран галереи-таблицы
            switchToTabBarController()
        } else {
            /// Если токен не сохранен, значит пользователь не был ранее авторизован. Можно перенаправить на экран авторизации
            performSegue(withIdentifier: ShowAuthSegueIdentifier, sender: nil)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setNeedsStatusBarAppearanceUpdate()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //            if let libraryPath = NSSearchPathForDirectoriesInDomains(.libraryDirectory, .userDomainMask, true).first {
        //            let preferencesPath = libraryPath + "/Preferences"
        //            print(preferencesPath)
        //        }
        //            print("Splash Screen Controller loaded")
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        .lightContent
    }
    
    private func switchToTabBarController() {
        guard let window = UIApplication.shared.windows.first else { fatalError("Invalid Configuration") }
        let tabBarController = UIStoryboard(name: "Main", bundle: .main)
            .instantiateViewController(withIdentifier: "TabBarViewController")
        window.rootViewController = tabBarController
    }
}

extension SplashViewController {
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        ///Проверяем переход на авторизацию
        if segue.identifier == ShowAuthSegueIdentifier {
            ///Идем к первому контролеру навигации
            guard
                let navigationController = segue.destination as? UINavigationController,
                let viewController = navigationController.viewControllers[0] as? AuthViewController
            else {fatalError("Failed to prepare for \(ShowAuthSegueIdentifier)")}
            
            ///Делегатом контроллера устанавливаем SplashVC
            viewController.delegate = self
        } else {
            super.prepare(for: segue, sender: sender)
        }
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
        OAuth2Services.shared.fetchOAuthToken(code) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success:
                UIBlockingProgressHUD.dismiss()
                self.switchToTabBarController()
            case .failure:
                print("Error")
                break
            }
        }
    }
}
