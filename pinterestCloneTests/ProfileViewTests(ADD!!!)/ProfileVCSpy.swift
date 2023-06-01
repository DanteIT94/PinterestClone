//
//  ProfileVCSpy.swift
//  ProfileViewTests
//
//  Created by Денис on 01.06.2023.
//

@testable import pinterestClone
import UIKit

final class ProfileViewControllerSpy: ProfileViewControllerProtocol {
    var presenter: pinterestClone.ProfilePresenterProtocol
    var image: UIImage?
    
    var isUpdateProfileDetailsCalled = false
    var updatedProfileDetails: Profile?
    
    init(presenter: ProfilePresenterProtocol) {
        self.presenter = presenter
        presenter.view = self
    }
    
    func updateProfileDetails(profile: pinterestClone.Profile?) {
        isUpdateProfileDetailsCalled = true
        updatedProfileDetails = profile
    }
    
    func updateProfileAvatar(avatar: UIImage) {
        self.image = avatar
    }
    
    
}
