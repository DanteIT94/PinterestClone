//
//  TabBarViewController.swift
//  pinterestClone
//
//  Created by Денис on 11.05.2023.
//

import UIKit

final class TabBarController: UITabBarController {
    
    override func awakeFromNib() {
        super.awakeFromNib()
        let storyboard = UIStoryboard(name: "Main", bundle: .main)
        
        let imagesListViewController = storyboard.instantiateViewController(
            withIdentifier: "ImagesListViewController")
            
        let profileViewController = ProfileViewController()
        profileViewController.tabBarItem = UITabBarItem(
            title: nil,
            image: UIImage(named: "tab_profile_active"),
            selectedImage: nil)
//        storyboard.instantiateViewController(
//            withIdentifier: "ProfileViewController")
        
        self.viewControllers = [imagesListViewController, profileViewController]
    }
}