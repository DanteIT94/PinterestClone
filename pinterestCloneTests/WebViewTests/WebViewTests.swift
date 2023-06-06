//
//  pinterestCloneTests.swift
//  pinterestCloneTests
//
//  Created by Денис on 29.05.2023.
//
@testable import pinterestClone
import Foundation
import XCTest

//MARK: - ЗАГЛУШКИ ДЛЯ ТЕСТОВ!!!
final class WebViewPresenterSpy: WebViewPresenterProtocol {
    var viewDidLoadCalled: Bool = false
    var view: WebViewViewControllerProtocol?
    
    func viewDidLoad() {
        viewDidLoadCalled = true
    }
    
    func didUpdateProgressValue(_ newValue: Double) {
    }
    
    func code(from url: URL) -> String? {
        return nil
    }
}

final class WebViewControllerSpy: WebViewViewControllerProtocol {
    var presenter: pinterestClone.WebViewPresenterProtocol?
    
    var loadRequestCalled: Bool = false
    
    func load(request: URLRequest) {
        loadRequestCalled = true
    }
    
    func setProgressValue(_ newValue: Float) {
    }
    
    func setProgressHidden(_ isHidden: Bool) {
    }
}


//-MARK: -Начало
final class WebViewTests: XCTestCase {
    //MARK: Тест № 1 - Связь webVC & Presenter
    func testViewControllerCallsViewDidLoad() {
        //given
        let webVC = WebViewViewController()
        let presenter = WebViewPresenterSpy()
        webVC.presenter = presenter
        presenter.view = webVC
        //when
        _ = webVC.view
        //then
        XCTAssertTrue(presenter.viewDidLoadCalled)
    }
    
    //MARK: Тест № 2 - вызов loadRequest
    func testPresenterCallsLoadRequest () {
        //given
        let viewController = WebViewControllerSpy()
        let authHelper = AuthHelper()
        let presenter = WebViewPresenter(authHelper: authHelper)
        viewController.presenter = presenter
        presenter.view = viewController
        //when
        presenter.viewDidLoad()
        //then
        XCTAssertTrue(viewController.loadRequestCalled)
    }
    
    //MARK: Тест № 3 ProgressView (меньше 0.0001)
    
    func testProgressVisibleLessThanOne() {
        //given
        let authHelper = AuthHelper()
        let presenter = WebViewPresenter(authHelper: authHelper)
        let progress: Float = 1.0
        //when
        let shouldHideProgress = presenter.shouldHideProgress(for: progress)
        //then
        switch progress {
        case 1.0:
            XCTAssertTrue(shouldHideProgress)
            print("Загрузка завершена")
        case 0..<1.0:
            XCTAssertFalse(shouldHideProgress)
            print("Загрузка не окончена")
        default:
            return
        }
    }
    
    //MARK: Тест № 4-5 Тестируем Helper
    ///Получение ссылки авторизации authURL
    func testAuthHelperAuthURL() {
        //given
        let configuration = AuthConfiguration.standard
        let authHelper = AuthHelper(configuration: configuration)
        //when
        let url = authHelper.authURL()
        let urlString = url.absoluteString
        //then
        XCTAssertTrue(urlString.contains(configuration.authURLString))
        XCTAssertTrue(urlString.contains(configuration.accessKey))
        XCTAssertTrue(urlString.contains(configuration.redirectURI))
        XCTAssertTrue(urlString.contains("code"))
        XCTAssertTrue(urlString.contains(configuration.accessScope))
    }
    
    func testCodeFromURL() {
        //given
        var urlComponents = URLComponents(string: "https://unsplash.com/oauth/authorize/native")
        urlComponents?.queryItems = [URLQueryItem(name: "code", value: "test code")]
        let url = urlComponents?.url!
        let authHelper = AuthHelper()
        
        //when
        let code = authHelper.code(from: url!)
        
        //then
        XCTAssertEqual(code, "test code")
    }
}
