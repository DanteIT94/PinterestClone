//
//  ViewController.swift
//  pinterestClone
//
//  Created by Денис on 16.03.2023.
//

import UIKit

class ImageListViewController: UIViewController {

    //MARK: Properties
    @IBOutlet private var tableView: UITableView!
    
    private let photosName: [String] = Array(0..<20).map{"\($0)"}
    private lazy var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        formatter.timeStyle = .none
        return formatter
    } ()
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        tableView.delegate = self
//        tableView.dataSource = self
//        ///Настраиваем ячейку таблицы "из кода" (обычно это делается из viewDidLoad)
//        tableView.register(ImagesListCell.self, forCellReuseIdentifier: ImagesListCell.reuseIdentifier)
        tableView.contentInset = UIEdgeInsets(top: 16, left: 0, bottom: 16, right: 0 )
        
    }

}

extension ImageListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //этот метод ответчает за действия, которые будут выполнены при тапе по ячейке (адрес ячейки содержиться в indexPath и передается в качетсве аргумента)
        if let cell = tableView.cellForRow(at: indexPath) as? ImagesListCell {
            cell.isSelected = false
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        guard let image = UIImage(named: photosName[indexPath.row]) else {
            return 0
        }
        //TODO- ПОВТОРИТЬ (сделал через авторское решение)
        let imageInsets = UIEdgeInsets(top: 4, left: 16, bottom: 4, right: 16)
        let imageViewWidth = tableView.bounds.width - imageInsets.left - imageInsets.right
        let imageWidth = image.size.width
        let scale = imageViewWidth / imageWidth
        let cellHeight = image.size.height * scale + imageInsets.top + imageInsets.bottom
        return cellHeight
    }
}

extension ImageListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //данный метод опред. кол, ячеек в секции таблицы
        //Так как секция у нас одна - проигнорируем значение параметра section
        return 20
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //Метод возвращает ячейку (у Класса UITableView есть дефолтный конструктор без аргументов)
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


extension ImageListViewController {
    func configCell(for cell: ImagesListCell, with indexPath: IndexPath) {
        let imageName = "\(indexPath.row)"
        
        guard let image = UIImage(named: imageName) else { return }
        cell.dateLabel.text =  dateFormatter.string(from: Date())
        cell.cellImage.image = image
        
        let isLiked = indexPath.row % 2 == 0
        let likedImage = isLiked ? UIImage(named: "RedLike") : UIImage(named: "WhiteLike")
        cell.likeButton.setImage(likedImage, for: .normal)
        
        //TODO- Вернуться и доработать градиентный слой
        ///Задаем градиентный слой ячейкам
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [UIColor.YPGradient0?.cgColor, UIColor.YPGradient20?.cgColor]
        gradientLayer.locations = [0.0, 1.0]
        gradientLayer.frame = CGRect(x: 0, y: cell.bounds.height - 30, width: cell.bounds.width, height: 30)
        ///Добавляем градиентный слой на задний план
        cell.layer.insertSublayer(gradientLayer, at: 0)
    }
}
