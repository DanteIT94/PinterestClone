//
//  AuthViewController.swift
//  pinterestClone
//
//  Created by Денис on 18.04.2023.
//

import UIKit

class AuthViewController: UIViewController, WebViewViewControllerDelegate {
    
    let segueIdentifier = "ShowWebView"
    let oAuth2Services = OAuth2Services.shared
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == segueIdentifier {
            ///Через авторское guard-решение
            guard let webViewVC = segue.destination as? WebViewViewController  else {
                fatalError("Failed to prepare for \(segueIdentifier)")
            }
            webViewVC.delegate = self
        } else {
            super.prepare(for: segue, sender: sender)
        }
    }
    
    // METHODS:
    func webViewViewControllerDidCancel(_ vc: WebViewViewController) {
        dismiss(animated: true, completion: nil)
    }
    
    func webViewViewController(_ vc: WebViewViewController, didAuthenticateWithCode code: String) {
        oAuth2Services.fetchAuthToken(code) { result in
            switch result {
            case .success(let authToken):
                OAuth2TokenStorage().token = authToken
            case .failure(let error):
                print("Failed to fetch auth token: \(error)")
                
            }
        }
        
    }
}
