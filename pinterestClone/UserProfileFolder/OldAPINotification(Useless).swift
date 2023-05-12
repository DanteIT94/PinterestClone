//
//  OldAPINotification(Useless).swift
//  pinterestClone
//
//  Created by Денис on 08.05.2023.
//

/////Спринт 11 - Тема 3/7 - Урок 2/3
/////Перегружаем конструктор
//override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
//    super.init(nibName: nibName, bundle: bundle)
//    addObserver()
//}
//
/////Спринт 11 - Тема 3/7 - Урок 2/3
/////Опред. конструктор, необходимый для декодирования класса из Storyboard
//required init?(coder: NSCoder) {
//    super.init(coder: coder)
//    addObserver()
//}
//
//deinit{
//    removeObserver()
//}


    


/////Спринт 11 - Тема 3/7 - Урок 2/3
//private func addObserver() {
//    ///Добавляем наблюдателя в центр управления по умолч.
//    NotificationCenter.default.addObserver(
//        ///Класс, который будет получать уведомления
//        self,
//        ///Селектор вызываем на селф при опубликов. уведомления
//        selector: #selector(updateAvatar(notification:)),
//        ///Указываем имя уведомления
//        name: ProfileImageService.DidChangeNotfication,
//        ///Указываем nil, так как хотим уведомления от любых источников (могли бы передать в ProfileImageService.shared)
//        object: nil)
//}
//
//private func removeObserver() {
//    ///Отписываемся от уведомлений, метод вызывается из deinit
//    NotificationCenter.default.removeObserver(
//        self,
//        name: ProfileImageService.DidChangeNotfication,
//        object: nil)
//}
/////Данная аннотация нужна, потому что селектор можно создать только для Objc  методов класса
//@objc
/////Селектор для метода, в кот. мы получ. нотификац. -> Должен иметь аргумент типа Notification
/////В момент публикации нотифик. этот метод будет вызываться и в него будет передана нотифик.
//private func updateAvatar(notification: Notification) {
//    guard
//        ///До viewDidLoad аутлеты класса могут быть не проинициализированны -> если isViewLoaded =- false -> ливаем с катки
//        isViewLoaded,
//        let userInfo = notification.userInfo,
//        let profileImageURL = userInfo["URL"] as? String,
//        let url = URL(string: profileImageURL)
//    else { return }
//    
//    // TODO: - KingFisher
//}
