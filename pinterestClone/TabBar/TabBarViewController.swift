//
//  TabBarViewController.swift
//  pinterestClone
//
//  Created by Денис on 11.05.2023.
//

import UIKit

final class TabBarController: UITabBarController {
    
    private let profileService: ProfileServiceProtocol
    private let profileImageService: ProfileImageServiceProtocol
    private let profileImageHelper: ProfileImageHelperProtocol

    init(profileService: ProfileServiceProtocol, profileImageService: ProfileImageServiceProtocol, profileImageHelper: ProfileImageHelperProtocol) {
        self.profileService = profileService
        self.profileImageService = profileImageService
        self.profileImageHelper = profileImageHelper
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    //MARK: Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        tabBar.isTranslucent = false
        tabBar.barTintColor = .YPBlack
        tabBar.tintColor = .white
        
        let imagesListHelper = ImagesListHelper()
        let imagesListService = ImagesListService()
        let imagesListPresenter = ImagesListPresenter(imagesListHelper: imagesListHelper, imagesListServise: imagesListService)
        
        let imagesListViewController = ImagesListViewController(presenter: imagesListPresenter)
        
        imagesListViewController.tabBarItem = UITabBarItem(
            title: nil,
            image: UIImage(named: "tab_editorial_active"),
            selectedImage: nil)
        imagesListViewController.tabBarItem.accessibilityIdentifier = "ImagesList"
            
        let profilePresenter = ProfilePresenter(profileService: profileService,
                                                                                    profileImageService: profileImageService,
                                                                                    profileImageHelper: profileImageHelper)
        let profileViewController = ProfileViewController(presenter: profilePresenter)
        profileViewController.tabBarItem = UITabBarItem(
            title: nil,
            image: UIImage(named: "tab_profile_active"),
            selectedImage: nil)
        profileViewController.tabBarItem.accessibilityIdentifier = "Profile"
        
        self.viewControllers = [imagesListViewController, profileViewController]
    }
}
