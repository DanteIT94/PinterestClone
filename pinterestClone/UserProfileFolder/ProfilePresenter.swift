//
//  ProfilePresenter.swift
//  pinterestClone
//
//  Created by Денис on 30.05.2023.
//

import Foundation
import Kingfisher
import ProgressHUD
import WebKit

protocol ProfilePresenterProtocol: AnyObject  {
    var view: ProfileViewControllerProtocol? {get set}
    func subscribeForAvatarUpdates()
    func accountLogout()
    func updateAvatar()
    func retrieveImage(url: URL, options: KingfisherOptionsInfo?, completion: @escaping (Result<UIImage, Error>) -> Void)
}


final class ProfilePresenter: ProfilePresenterProtocol {
    
    //MARK: - Properties
    weak var view: ProfileViewControllerProtocol?
    
    //MARK: - Private Properties
    private var profileImageServiceObserver: NSObjectProtocol?
    private let profileService: ProfileServiceProtocol
    private let profileImageService: ProfileImageServiceProtocol
    private let tokenStorage = OAuth2TokenStorage()
    
    //MARK: - Initilizers
    init(profileService: ProfileServiceProtocol, profileImageService: ProfileImageServiceProtocol) {
        self.profileService = profileService
        self.profileImageService = profileImageService
    }
    
    //MARK: - Methods
    //    ✅
    func retrieveImage(url: URL, options: KingfisherOptionsInfo?, completion: @escaping (Result<UIImage, Error>) -> Void) {
        KingfisherManager.shared.retrieveImage(with: url, options: options) { result in
            switch result {
            case .success(let avatarResult):
                completion(.success(avatarResult.image))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    //    ✅
    func updateAvatar() {
        guard
            let profileImageURL = profileImageService.avatarURL,
            let url = URL(string: profileImageURL)
        else {return}
        
        let processor = RoundCornerImageProcessor(radius: .point(61))
        
        retrieveImage(url: url, options: [.processor(processor)]) { [weak self] result in
            guard let self else { return }
            switch result {
            case .success(let avatar):
                self.view?.updateProfileAvatar(avatar: avatar)
            case .failure(_):
                if let placeholderImage = UIImage(named: "my_avatar") {
                    self.view?.updateProfileAvatar(avatar: placeholderImage)
                }
            }
        }
    }
//    ✅
    func subscribeForAvatarUpdates() {
        profileImageServiceObserver = NotificationCenter.default.addObserver(
            forName: profileImageService.DidChangeNotfication,
            ///nil - т к мы хотим получать уведомления из любых источников
            object: nil,
            ///очередь, на которой мы хотим получать уведомления
            queue: .main
        ) { [weak self] _ in
            guard let self = self else {return}
            self.updateAvatar()
        }
        if let profile = profileService.profile {
            view?.updateProfileDetails(profile: profile)
        }
    }
//    ✅
    func accountLogout() {
        UIBlockingProgressHUD.show()
        guard let window = UIApplication.shared.windows.first else { return }
        tokenStorage.deleteToken()
        ///Чистим куки из хранилища
        HTTPCookieStorage.shared.removeCookies(since: Date.distantPast)
        WKWebsiteDataStore.default().fetchDataRecords(ofTypes: WKWebsiteDataStore.allWebsiteDataTypes()) { records in
            ///Массив полученных записей удаляем из хранилища
            records.forEach { record in
                WKWebsiteDataStore.default().removeData(ofTypes: record.dataTypes, for: [record], completionHandler: {})
            }
        }
        let profileService = ProfileService()
        let profileImageService = ProfileImageService()
        let splashVC = SplashViewController(profileService: profileService, profileImageService: profileImageService)
        window.rootViewController = splashVC
        UIBlockingProgressHUD.dismiss()
    }
}
