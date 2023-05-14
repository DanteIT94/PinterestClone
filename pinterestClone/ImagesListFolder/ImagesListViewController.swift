//
//  ViewController.swift
//  pinterestClone
//
//  Created by Денис on 16.03.2023.
//

import UIKit

final class ImagesListViewController: UIViewController {

    //MARK: - Types

    //MARK: - Constants
    
    //MARK: Public Properties
    
    //MARK: IBOutlet
    @IBOutlet private var tableView: UITableView!
    
    //MARK: Private Properties
    private let ShowSingleImageSegueIdentifier = "ShowSingleImage"
    private let photosName: [String] = Array(0..<20).map{"\($0)"}
    private lazy var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        formatter.timeStyle = .none
        return formatter
    } ()
    
    //MARK: -Initializers
    
    //MARK: - viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
//        tabBarController?.tabBar.barTintColor = .YPBlack
//        tabBarController?.tabBar.isTranslucent = false
//        tableView.delegate = self
//        tableView.dataSource = self
//        ///Настраиваем ячейку таблицы "из кода" (обычно это делается из viewDidLoad)
//        tableView.register(ImagesListCell.self, forCellReuseIdentifier: ImagesListCell.reuseIdentifier)
        tableView.contentInset = UIEdgeInsets(top: 16, left: 0, bottom: 16, right: 0 )
    }
    
    //MARK: - Public methods
    //MARK: - Private Methods
    private func presentSingleImageView(for indexPath: IndexPath) {
        let singleImageVC = SingleImageViewController()
        let image = UIImage(named: photosName[indexPath.row])
        singleImageVC.image = image
        singleImageVC.modalPresentationStyle = .fullScreen
        present(singleImageVC, animated: true, completion: nil)
    }
}


//MARK: - Extensions
//MARK: - UITableViewDelegate
extension ImagesListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        ///Этот метод ответчает за действия, которые будут выполнены при тапе по ячейке (адрес ячейки содержиться в indexPath и передается в качетсве аргумента)
        if let cell = tableView.cellForRow(at: indexPath) as? ImagesListCell {
            cell.isSelected = false
        }
        presentSingleImageView(for: indexPath)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        guard let image = UIImage(named: photosName[indexPath.row]) else {
            return 0
        }
        //TODO- ПОВТОРИТЬ (сделал через авторское решение)⚠️
        let imageInsets = UIEdgeInsets(top: 4, left: 16, bottom: 4, right: 16)
        let imageViewWidth = tableView.bounds.width - imageInsets.left - imageInsets.right
        let imageWidth = image.size.width
        let scale = imageViewWidth / imageWidth
        let cellHeight = image.size.height * scale + imageInsets.top + imageInsets.bottom
        return cellHeight
    }
}

//MARK: - UITableViewDataSource
extension ImagesListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //данный метод опред. кол. ячеек в секции таблицы
        //Так как секция у нас одна - проигнорируем значение параметра section
        return 20
    }
    ///Метод возвращает ячейку (у Класса UITableView есть дефолтный конструктор без аргументов)
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        ///1) Добавляем метод, который из всех ячеек, зарегистрированных ранее, возвращает ячейку по идентификатору, добавленому ранее.
        let cell = tableView.dequeueReusableCell(withIdentifier: ImagesListCell.reuseIdentifier, for:  indexPath)
        ///2) Для работы с ячейкой как с экземпляром класса ImagesListCell - нужно сделать приведение типов
        guard let imageListCell = cell as? ImagesListCell else {
            return UITableViewCell()
        }
        ///3) Метод конфигурации ячейки (искать в классе ImageList)
        configCell(for: imageListCell, with: indexPath)
        ///4) Возвращаем ячейку
        return imageListCell
    }
}

extension ImagesListViewController {
    func configCell(for cell: ImagesListCell, with indexPath: IndexPath) {
        let imageName = "\(indexPath.row)"
        
        guard let image = UIImage(named: imageName) else { return }
        cell.dateLabel.text =  dateFormatter.string(from: Date())
        cell.cellImage.image = image
        
        let isLiked = indexPath.row % 2 == 0
        let likedImage = isLiked ? UIImage(named: "isLiked") : UIImage(named: "isUnliked")
        cell.likeButton.setImage(likedImage, for: .normal)
        
        //TODO: реализуем эффект нажатия на ячейку без серого выделения (✅DONE)
        let selectedView = UIView()
        ///Устанавливаем цвет фона
        selectedView.backgroundColor = UIColor.lightGray.withAlphaComponent(0.2)
        cell.selectedBackgroundView = selectedView
    }
}
