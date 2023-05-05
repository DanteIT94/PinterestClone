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
    //MARK: -Properties
    let segueIdentifier = "ShowWebView"
    let oAuth2Services = OAuth2Services.shared
    
    weak var delegate: AuthViewControllerDelegate?
    
    //MARK: -viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        //            print("Auth Screen Controller loaded")
    }
    
    // MARK: -Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == segueIdentifier {
            ///Через авторское guard-решение
            guard
                let webViewVC = segue.destination as? WebViewViewController
            else {
                fatalError("Failed to prepare for \(segueIdentifier)")
            }
            webViewVC.delegate = self
        } else {
            super.prepare(for: segue, sender: sender)
        }
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
