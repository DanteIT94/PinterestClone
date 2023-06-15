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
    func stopImageTask(for url: URL)
}

final class ImagesListCell: UITableViewCell {
    //MARK: - Public Properties
    static let reuseIdentifier = "ImagesListCell"
    weak var delegate: ImagesListCellDelegate?
    
    let cellImage: UIImageView = {
        let cellImage = UIImageView()
        cellImage.translatesAutoresizingMaskIntoConstraints = false
        cellImage.contentMode = .scaleAspectFit
        cellImage.layer.cornerRadius = 16
        cellImage.layer.masksToBounds = true
        return cellImage
    }()
    
    //MARK: - Private Computered Properties
//    private var gradientLayer: CAGradientLayer!
    private var animationLayers = Set<CALayer>()
    private var imageURL: URL?
    
    private let likeButton: UIButton = {
        let likeButton = UIButton()
        likeButton.translatesAutoresizingMaskIntoConstraints = false
        likeButton.accessibilityIdentifier = "LikeButton"
        likeButton.setTitle("", for: .normal)
        likeButton.addTarget(nil, action: #selector(likeButtonClicked), for: .touchUpInside)
        return  likeButton
    }()
    
    private let gradientView: UIView = {
        let gradientView = UIView()
        gradientView.translatesAutoresizingMaskIntoConstraints = false
        gradientView.layer.cornerRadius = 16
        gradientView.clipsToBounds = true
        gradientView.layer.maskedCorners = CACornerMask([.layerMinXMaxYCorner, .layerMaxXMaxYCorner])
        return gradientView
    }()
    
    private let dateLabel: UILabel = {
        let dateLabel = UILabel()
        dateLabel.translatesAutoresizingMaskIntoConstraints = false
        dateLabel.font = .systemFont(ofSize: 13)
        dateLabel.textColor = .YPWhite
        return dateLabel
    }()
    
    private let gradient: CAGradientLayer = {
        let gradient = CAGradientLayer()
        gradient.colors = [UIColor.YPBlack?.withAlphaComponent(0).cgColor as Any, UIColor.YPBlack?.cgColor as Any]
        gradient.startPoint = CGPoint(x: 0.5, y: 0)
        gradient.endPoint = CGPoint(x: 0.5, y: 1)
        gradient.locations = [0, 1]
        gradient.opacity = 0.4
        return gradient
    }()
    
    private let animatedGradient: CAGradientLayer = {
       let animatedGradient = CAGradientLayer()
        animatedGradient.locations = [0, 0.1, 0.3]
        animatedGradient.colors = [
            UIColor(red: 0.682, green: 0.686, blue: 0.706, alpha: 1).cgColor,
            UIColor(red: 0.531, green: 0.533, blue: 0.553, alpha: 1).cgColor,
            UIColor(red: 0.431, green: 0.433, blue: 0.453, alpha: 1).cgColor
        ]
        animatedGradient.startPoint = CGPoint(x: 0, y: 0.5)
        animatedGradient.endPoint = CGPoint(x: 1, y: 0.5)
        animatedGradient.cornerRadius = 16
        animatedGradient.masksToBounds = true
        return animatedGradient
    }()
    
    //MARK: - Methods-initializers
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        createCell()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        gradient.frame = gradientView.bounds
        animatedGradient.frame = cellImage.bounds
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        //отменяем загрузку во избежании багов
        if let imageURL {
            delegate?.stopImageTask(for: imageURL)
        }
        removeAnimatedGradient()
    }
    
    //MARK: - Public Methods
    ///Метод для передачи данных об элементах отдельной ячейки
    func configureCellElements(image: UIImage, date: String?, isLiked: Bool, imageURL: URL) {
        cellImage.image = image
        dateLabel.text = date
        setIsLiked(isLiked)
        gradientView.layer.insertSublayer(gradient, at: 0)
        self.imageURL = imageURL
        removeAnimatedGradient()
    }
    
    func setAnimatedGradient() {
        animationLayers.insert(animatedGradient)
        cellImage.layer.addSublayer(animatedGradient)
        let gradientChangeAnimation = CABasicAnimation(keyPath: "locations")
        gradientChangeAnimation.duration = 1
        gradientChangeAnimation.repeatCount = .infinity
        gradientChangeAnimation.fromValue = [0, 0.1, 0.3]
        gradientChangeAnimation.toValue = [0, 0.8, 1]
        animatedGradient.add(gradientChangeAnimation, forKey: "locationsChange")
    }
    
    
    //MARK: - Private Methods
    
    private func createCell() {
        [cellImage, likeButton, gradientView, dateLabel].forEach { contentView.addSubview($0)}
        ///Задаем расположение элементов в ячейке
        NSLayoutConstraint.activate([
            cellImage.topAnchor.constraint(equalTo: topAnchor, constant: 4),
            cellImage.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -4),
            cellImage.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            cellImage.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            //--------------------------------------------------
            likeButton.trailingAnchor.constraint(equalTo: cellImage.trailingAnchor),
            likeButton.topAnchor.constraint(equalTo: cellImage.topAnchor),
            likeButton.heightAnchor.constraint(equalToConstant: 42),
            likeButton.widthAnchor.constraint(equalToConstant: 42),
            //--------------------------------------------------
            gradientView.heightAnchor.constraint(equalToConstant: 35),
            gradientView.leadingAnchor.constraint(equalTo: cellImage.leadingAnchor),
            gradientView.trailingAnchor.constraint(equalTo: cellImage.trailingAnchor),
            gradientView.bottomAnchor.constraint(equalTo: cellImage.bottomAnchor),
            //--------------------------------------------------
            dateLabel.leadingAnchor.constraint(equalTo: gradientView.leadingAnchor, constant: 5),
            dateLabel.trailingAnchor.constraint(equalTo: gradientView.trailingAnchor, constant: -8),
            dateLabel.bottomAnchor.constraint(equalTo: gradientView.bottomAnchor, constant: -8)
        ])
        contentView.layer.addSublayer(gradient)
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
    
    private func removeAnimatedGradient() {
        animationLayers.forEach { layers in
            layers.removeFromSuperlayer()
        }
    }
}
