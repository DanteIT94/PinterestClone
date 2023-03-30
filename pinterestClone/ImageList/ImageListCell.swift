//
//  ImageListCell.swift
//  pinterestClone
//
//  Created by Денис on 18.03.2023.
//

import UIKit
final class ImagesListCell: UITableViewCell {
    //MARK: - Public Properties
    static let reuseIdentifier = "ImagesListCell"
    var gradientLayer: CAGradientLayer!
    //MARK: - IBOutlet
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var cellImage: UIImageView!
    @IBOutlet weak var likeButton: UIButton!
    
    //MARK: - Methods
    override func awakeFromNib() {
        super.awakeFromNib()
        //TODO: - градиентный слой (✅DONE)
        ///Задаем градиентный слой ячейкам
        gradientLayer = CAGradientLayer()
        gradientLayer.colors = [UIColor.YPGradient0?.cgColor as Any, UIColor.YPGradient20?.cgColor as Any]
        gradientLayer.locations = [0.0, 1.0]
        
        //Установливаем границы градиента
        gradientLayer.frame = CGRect(x: 0, y: cellImage.bounds.height - 35, width: cellImage.bounds.width, height: 35)
//        gradientLayer.frame = CGRect(x: 0, y: bounds.height - 35, width: bounds.width, height: 35)
        
        //Добавляем градиентный слой
        cellImage.layer.insertSublayer(gradientLayer, at: 0)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        gradientLayer.frame = CGRect(x: 0, y: cellImage.bounds.height - 35, width: cellImage.bounds.width, height: 35)
    }
    
}
