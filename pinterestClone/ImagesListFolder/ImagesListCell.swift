//
//  ImageListCell.swift
//  pinterestClone
//
//  Created by Денис on 18.03.2023.
//

import UIKit
import Kingfisher

protocol ImagesListCellDelegate: AnyObject {
    func imageListCellDidTapLike(_ cell: ImagesListCell)
}

final class ImagesListCell: UITableViewCell {
    //MARK: - Public Properties
    static let reuseIdentifier = "ImagesListCell"
    weak var delegate: ImagesListCellDelegate?
    
    //MARK: - Private Computered Properties
    private let dateLabel: UILabel = {
        let dateLabel = UILabel()
        dateLabel.translatesAutoresizingMaskIntoConstraints = false
        dateLabel.font = .systemFont(ofSize: 13)
        dateLabel.textColor = .YPWhite
        return dateLabel
    }()
    let cellImage: UIImageView = {
        let cellImage = UIImageView()
        cellImage.translatesAutoresizingMaskIntoConstraints = false
        cellImage.layer.cornerRadius = 16
        cellImage.layer.masksToBounds = true
        return cellImage
    }()
    private let likeButton: UIButton = {
        let likeButton = UIButton()
        likeButton.translatesAutoresizingMaskIntoConstraints = false
        likeButton.setTitle("", for: .normal)
        likeButton.addTarget(nil, action: #selector(likeButtonClicked), for: .touchUpInside)
        return  likeButton
    }()
    
    private var gradientLayer: CAGradientLayer!
    
    //MARK: - Methods-initializers
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        createCell()
        createGradientLayer()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        assertionFailure("Error")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        gradientLayer?.frame = CGRect(x: 0, y: cellImage.bounds.height - 35, width: cellImage.bounds.width, height: 35)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        //отменяем загрузку во избежании багов
        cellImage.kf.cancelDownloadTask()
    }
    
    //MARK: - Public Methods
    ///Метод для передачи данных об элементах отдельной ячейки
    func configureCellElements(image: UIImage, date: String, isLiked: Bool) {
        cellImage.image = image
        dateLabel.text = date
        setIsLiked(isLiked)
    }
    
    
    //MARK: - Private Methods
    private func createGradientLayer() {
        //MARK: - градиентный слой (✅DONE)
        ///Задаем градиентный слой ячейкам
        gradientLayer = CAGradientLayer()
        gradientLayer.colors = [UIColor.YPGradient0?.cgColor as Any, UIColor.YPGradient20?.cgColor as Any]
        gradientLayer.locations = [0.0, 1.0]
        //Установливаем границы градиента
        gradientLayer.frame = CGRect(x: 0, y: cellImage.bounds.height - 35, width: cellImage.bounds.width, height: 35)
        //Добавляем градиентный слой
        cellImage.layer.insertSublayer(gradientLayer, at: 0)
    }
    
    private func createCell() {
        contentView.addSubview(cellImage)
        contentView.addSubview(dateLabel)
        contentView.addSubview(likeButton)
        
        ///Задаем расположение элементов в ячейке
        NSLayoutConstraint.activate([
            dateLabel.leadingAnchor.constraint(equalTo: cellImage.leadingAnchor, constant: 5),
            dateLabel.trailingAnchor.constraint(equalTo: cellImage.trailingAnchor, constant: -8),
            dateLabel.bottomAnchor.constraint(equalTo: cellImage.bottomAnchor, constant: -8),
            //--------------------------------------------------
            likeButton.trailingAnchor.constraint(equalTo: cellImage.trailingAnchor),
            likeButton.topAnchor.constraint(equalTo: cellImage.topAnchor),
            likeButton.heightAnchor.constraint(equalToConstant: 42),
            likeButton.widthAnchor.constraint(equalToConstant: 42),
            //--------------------------------------------------
            cellImage.topAnchor.constraint(equalTo: topAnchor, constant: 4),
            cellImage.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -4),
            cellImage.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            cellImage.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16)
        ])
    }
    
     func setIsLiked(_ isLiked: Bool) {
        if isLiked {
            likeButton.setImage(UIImage(named: "isLiked"), for: .normal)
        } else {
            likeButton.setImage(UIImage(named:"isUnliked"), for: .normal)
        }
    }
    
    @objc private func likeButtonClicked() {
        delegate?.imageListCellDidTapLike(self)
    }
}
