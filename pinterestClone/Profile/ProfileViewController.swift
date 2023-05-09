import UIKit
import Kingfisher

final class ProfileViewController: UIViewController {
    
    //MARK: - private properties
    private var avatarImage: UIImageView!
    private var nameLabel: UILabel!
    private var loginLabel: UILabel!
    private var descriptionLabel: UILabel!
    private var logoutButton: UIButton!
    
    private let profileService = ProfileService.shared
    private let profileImageService = ProfileImageService.shared
    private let tokenStorage = OAuth2TokenStorage()
    ///Проперти для хранения обсервера
    private var profileImageServiceObserver: NSObjectProtocol?
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .YPBlack
        ///Cоздаем функции для отображения лэйблов, Картин, кнопок
        createAvatarImage(safeArea: view.safeAreaLayoutGuide)
        createNameLabel(safeArea: view.safeAreaLayoutGuide)
        createLoginLabel(safeArea: view.safeAreaLayoutGuide)
        createDescriptionLabel(safeArea: view.safeAreaLayoutGuide)
        createLogoutButton(safeArea: view.safeAreaLayoutGuide)
        
        updateProfileDetails(profile: profileService.profile)
        subscribeForAvatarUpdates()
        updateAvatar()
    }
    
    
    //MARK: - private Methods
    private func createAvatarImage(safeArea: UILayoutGuide) {
        avatarImage = UIImageView()
        avatarImage.image = UIImage(named: "my_avatar")
        avatarImage.contentMode = .scaleAspectFill
        avatarImage.clipsToBounds = true
        
        avatarImage.layer.cornerRadius = 35
        avatarImage.layer.masksToBounds = true
        //        avatarImage.layer.borderWidth = 2
        //        avatarImage.layer.borderColor = UIColor.white.cgColor
        avatarImage.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(avatarImage)
        avatarImage.heightAnchor.constraint(equalToConstant: 70).isActive = true
        avatarImage.widthAnchor.constraint(equalToConstant: 70).isActive = true
        avatarImage.topAnchor.constraint(equalTo: safeArea.topAnchor, constant: 32).isActive = true
        avatarImage.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: 16).isActive = true
        
    }
    private func createNameLabel(safeArea: UILayoutGuide) {
        nameLabel = UILabel()
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(nameLabel)
        nameLabel.text = "Denis Chakyr"
        ///Шрифты (требуется корректирование)
        nameLabel.font = UIFont.systemFont(ofSize: 23, weight: .bold)
        nameLabel.textColor = UIColor.YPWhite
        nameLabel.leadingAnchor.constraint(equalTo: avatarImage.leadingAnchor).isActive = true
        nameLabel.topAnchor.constraint(equalTo: avatarImage.bottomAnchor, constant: 8).isActive = true
    }
    
    private func createLoginLabel(safeArea: UILayoutGuide) {
        loginLabel = UILabel()
        loginLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(loginLabel)
        loginLabel.text = "@ChakyrIT"
        loginLabel.font = UIFont.systemFont(ofSize: 13, weight: .regular)
        loginLabel.textColor = UIColor.YPGrey
        loginLabel.leadingAnchor.constraint(equalTo: nameLabel.leadingAnchor).isActive = true
        loginLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 8).isActive = true
    }
    
    private func createDescriptionLabel(safeArea: UILayoutGuide) {
        descriptionLabel = UILabel()
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(descriptionLabel)
        descriptionLabel.text = "Войти в Айти!"
        descriptionLabel.font = UIFont.systemFont(ofSize: 13, weight: .regular)
        descriptionLabel.textColor = UIColor.YPWhite
        descriptionLabel.leadingAnchor.constraint(equalTo: loginLabel.leadingAnchor).isActive = true
        descriptionLabel.topAnchor.constraint(equalTo: loginLabel.bottomAnchor, constant: 8).isActive = true
    }
    
    private func createLogoutButton(safeArea: UILayoutGuide) {
        logoutButton = UIButton.systemButton(
            with: UIImage(named: "logout_button") ?? UIImage(),
            target: self,
            action: nil
        )
        logoutButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(logoutButton)
        logoutButton.tintColor = .YPRed
        logoutButton.centerYAnchor.constraint(equalTo: avatarImage.centerYAnchor).isActive = true
        logoutButton.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: -26).isActive = true
    }
    
    private func updateProfileDetails(profile: Profile?) {
        if let profile = profile {
            nameLabel.text = profile.name
            loginLabel.text = profile.loginName
            descriptionLabel.text = profile.bio
        } else {
            nameLabel.text = "Error"
            loginLabel.text = "Error"
            descriptionLabel.text = "Error"
        }
    }
    
    private func updateAvatar() {
        guard
            let profileImageURL = profileImageService.avatarURL,
            let url = URL(string: profileImageURL)
        else {return}
        let placeholderImage = UIImage(systemName: "my_avatar")
        avatarImage.kf.setImage(with: url, placeholder: placeholderImage)
    }
    
    private func subscribeForAvatarUpdates() {
        profileImageServiceObserver = NotificationCenter.default.addObserver(
            forName: ProfileImageService.DidChangeNotfication,
            ///nil - т к мы хотим получать уведомления из любых источников
            object: nil,
            ///очередь, на которой мы хотим получать уведомления
            queue: .main
        ) { [weak self] _ in
            guard let self = self else {return}
            self.updateAvatar()
        }
        updateAvatar()
    }
    
}
