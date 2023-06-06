//
//  pinterestCloneUITestsLaunchTests.swift
//  pinterestCloneUITests
//
//  Created by Денис on 05.06.2023.
//

import XCTest

final class pinterestCloneUITestsLaunchTests: XCTestCase {
    
    override class var runsForEachTargetApplicationUIConfiguration: Bool {
        true
    }
    
    override func setUpWithError() throws {
        continueAfterFailure = false
    }
    
    func testLaunch() throws {
        let app = XCUIApplication()
        app.launch()
        
        let attachment = XCTAttachment(screenshot: app.screenshot())
        attachment.name = "Launch Screen"
        attachment.lifetime = .keepAlways
        add(attachment)
    }
}
