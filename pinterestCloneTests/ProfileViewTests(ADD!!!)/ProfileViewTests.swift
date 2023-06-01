//
//  ProfileViewTests.swift
//  ProfileViewTests
//
//  Created by Денис on 01.06.2023.
//

@testable import pinterestClone
import Foundation
import XCTest

final class ProfileViewTests: XCTestCase {

    //MARK: Test № 1
   func testUpdateAvatar() {
        //given
       let profileService = ProfileServiceMock()
       let profileImageService = ProfileServiceImageMock()
       let profileImageHelper = ProfileImageHelperMock()
       let presenter = ProfilePresenter(profileService: profileService, profileImageService: profileImageService, profileImageHelper: profileImageHelper)
       let profileVC = ProfileViewControllerSpy(presenter: presenter)
       
       //when
       profileImageService.avatarURL = ImageURLMock.successURL?.absoluteString
       presenter.updateAvatar()
       
       //then
       XCTAssertEqual(profileVC.image, ImagesMock.successImage)
    }
    
    //MARK: Test № 2
    func testSubscribeForAvatarUpdates() {
        //given
        let profileService = ProfileServiceMock()
        let profileImageService = ProfileServiceImageMock()
        let profileImageHelper = ProfileImageHelperMock()
        let presenter = ProfilePresenter(profileService: profileService, profileImageService: profileImageService, profileImageHelper: profileImageHelper)
        let profileVC = ProfileViewControllerSpy(presenter: presenter)
        
        let notificationName = Notification.Name("ProfileImageServiceDidChangeNotification")
        let expectedProfile = Profile(username: "John", name: "Dou", loginName: "12345")
        profileService.profile = expectedProfile
        //when
        presenter.subscribeForAvatarUpdates()
        NotificationCenter.default.post(
            name: notificationName,
            object: nil,
            userInfo: nil)
        //then
//        XCTAssertTrue(profileImageService.isFetchProfileImageURLCalled)
//        XCTAssertEqual(profileImageService.fetchProfileImageURLUsername, "success")
//        XCTAssertNotNil(profileImageService.fetchProfileImageURLCompletion)
//        XCTAssertTrue(profileVC.isUpdateProfileDetailsCalled)
//        XCTAssertTrue(profileVC.updatedProfileDetails! == expectedProfile)
    }
    
    
    
    

}
