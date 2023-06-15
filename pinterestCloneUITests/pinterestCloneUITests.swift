//
//  pinterestCloneUITests.swift
//  pinterestCloneUITests
//
//  Created by Денис on 05.06.2023.
//

import XCTest

final class pinterestCloneUITests: XCTestCase {
    
    private let app = XCUIApplication() //Переменная приложения
    
    override func setUpWithError() throws {
        continueAfterFailure = false
        
        app.launch()
    }
    
    //DONE
    func testAuth() throws {
        //тестируем сценарий авторизации
        
        app.buttons["Authenticate"].tap()
        let webView = app.webViews["UnsplashWebView"]
        XCTAssertTrue(webView.waitForExistence(timeout: 5))
        
        let loginTextField = webView.descendants(matching: .textField).element
        XCTAssertTrue(loginTextField.waitForExistence(timeout: 5))
        
        loginTextField.tap()
        loginTextField.typeText("ChakyrIT@gmail.com")
        //        webView.swipeUp()
        app.toolbars["Toolbar"].buttons["Done"].tap()
        
        let passwordTextField = webView.descendants(matching: .secureTextField).element
        XCTAssertTrue(passwordTextField.waitForExistence(timeout: 5))
        
        passwordTextField.tap()
        passwordTextField.typeText("Dante5594")
        //        webView.swipeUp()
        app.toolbars["Toolbar"].buttons["Done"].tap()
        
        let loginButton = webView.descendants(matching: .button).element
        loginButton.tap()
        
        
        let tablesQuery = app.tables
        let cell = tablesQuery.children(matching: .cell).element(boundBy: 0)
        XCTAssertTrue(cell.waitForExistence(timeout: 5))
        
        print(app.debugDescription)
    }
    
    func testFeed() throws {
        // Подождать, пока открывается и загружается экран ленты
        let tablesQuery = app.tables
        let cell = tablesQuery.children(matching: .cell).element(boundBy: 0)
        sleep(3)
        // Сделать жест «смахивания» вверх по экрану для его скролла
        tablesQuery.element.swipeUp()
                tablesQuery.element.swipeDown()
        // Поставить лайк в ячейке верхней картинки
        let firstCell = tablesQuery.cells.element(boundBy: 0)
        let likeButton = firstCell.buttons["LikeButton"]
        likeButton.tap()
        sleep(3)
        // Отменить лайк в ячейке верхней картинки
        likeButton.tap()
        sleep(3)
        // Нажать на верхнюю ячейку
        // Подождать, пока картинка открывается на весь экран
        firstCell.tap()
        sleep(5)
        // Увеличить картинку
        let image = app.scrollViews.images.element(boundBy: 0)
        image.pinch(withScale: 3, velocity: 1)
        sleep(3)
        // Уменьшить картинку
        image.pinch(withScale: 0.5, velocity: -1)
        sleep(3)
        // Вернуться на экран ленты
        app.buttons["BackButton"].tap()
        sleep(3)
    }
    
    
    func testProfile() throws {
        // Подождать, пока открывается и загружается экран ленты
        let imagesListTab = app.tabBars.buttons["ImagesList"]
        XCTAssertTrue(imagesListTab.waitForExistence(timeout: 5))
        // Перейти на экран профиля
        let profileTab = app.tabBars.buttons["Profile"]
        XCTAssertTrue(profileTab.waitForExistence(timeout: 5))
        profileTab.tap()
        sleep(3)
        // Проверить, что на нём отображаются ваши персональные данные
        let nameLabel = app.staticTexts["NameLabel"]
        let loginLabel = app.staticTexts["LoginLabel"]
        let descriptionLabel = app.staticTexts["DescriptionLabel"]
        XCTAssertTrue(nameLabel.waitForExistence(timeout: 5))
        XCTAssertTrue(loginLabel.waitForExistence(timeout: 5))
        XCTAssertTrue(descriptionLabel.waitForExistence(timeout: 5))
        // Нажать кнопку логаута
        let logoutButton = app.buttons["LogoutButton"]
        logoutButton.tap()
        sleep(3)
        // Подтвердить выход в Alert
        let alert = app.alerts["Пока, Пока!"]
        XCTAssertTrue(alert.waitForExistence(timeout: 5))
        let confirmButton = alert.buttons["yesAction"]
        confirmButton.tap()
        sleep(3)
        // Проверить, что открылся экран авторизации
        XCTAssertTrue(app.staticTexts["Войти"].exists)
        
    }
    
    
}
