//
//  ViewController.swift
//  pinterestClone
//
//  Created by Денис on 16.03.2023.
//

import UIKit
import Kingfisher
import ProgressHUD

protocol ImagesListViewControllerProtocol: AnyObject {
    func updateTableViewAnimated(from oldCount: Int, to newCount: Int)
    func configureCellElements(cell: ImagesListCell, image: UIImage, date: String?, isLiked: Bool, imageURL: URL)
}

final class ImagesListViewController: UIViewController {
    
    
    //MARK: -Private Properties
    private var imagesListHelper: ImagesListHelperProtocol
    var presenter: ImagesListPresenterProtocol
    private let ShowSingleImageSegueIdentifier = "ShowSingleImage"
    private let tableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    //MARK: -Initizilizer
    init(presenter: ImagesListPresenterProtocol, imagesListHelper: ImagesListHelperProtocol) {
        self.presenter = presenter
        self.imagesListHelper = imagesListHelper
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        createTableViewLayout()
        /// Настраиваем ячейку таблицы "из кода" (обычно это делается из viewDidLoad)
        tableView.register(ImagesListCell.self, forCellReuseIdentifier: "ImagesListCell")
        tableView.contentInset = UIEdgeInsets(top: 16, left: 0, bottom: 16, right: 0 )
        
        tableView.delegate = self
        tableView.dataSource = self
        
        presenter.view = self
        
        presenter.fetchPhotosNextPage()
    }
    
    //MARK: - Private Methods
    private func createTableViewLayout() {
        view.addSubview(tableView)
        tableView.backgroundColor = .YPBlack
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }
    
    private func presentSingleImageView(for indexPath: IndexPath) {
        guard let url = URL(string: presenter.photos[indexPath.row].largeImageURL) else {return}
        let singleImageVC = SingleImageViewController(fullImageUrl: url)
        singleImageVC.modalPresentationStyle = .fullScreen
        present(singleImageVC, animated: true, completion: nil)
    }
    
    func configCell(for cell: ImagesListCell, with indexPath: IndexPath) {
        guard let date = presenter.photos[indexPath.row].createdAt else { return }
        let dateString = date.dateTimeString
        
        guard let url = URL(string: presenter.photos[indexPath.row].thumbImageURL) else {return}
        cell.setAnimatedGradient()
        cell.cellImage.kf.indicatorType = .activity
        
        imagesListHelper.fetchImagesListImage(url: url, options: nil) { [weak self] result in
            guard let self = self else {return}
            switch result {
            case .success(let image):
                configureCellElements(cell: cell, image: image, date: dateString, isLiked: presenter.photos[indexPath.row].likedByUser, imageURL: url)
            case .failure(_):
                guard let placeholderImage = UIImage(named: "image_placeholder") else { return }
                configureCellElements(cell: cell, image: placeholderImage, date: "Error", isLiked: false, imageURL: url)
            }
            /// эффект нажатия на ячейку без серого выделения
            let selectedView = UIView()
            /// Устанавливаем цвет фона
            selectedView.backgroundColor = UIColor.lightGray.withAlphaComponent(0.2)
            cell.selectedBackgroundView = selectedView
        }
    }
    
}

//MARK: - UITableViewDelegate
extension ImagesListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        /// Этот метод ответчает за действия, которые будут выполнены при тапе по ячейке (адрес ячейки содержиться в indexPath и передается в качестве аргумента)
        if let cell = tableView.cellForRow(at: indexPath) as? ImagesListCell {
            cell.isSelected = false
        }
        presentSingleImageView(for: indexPath)
    }
    
    ///НЕЗАБЫТЬ ПОДКЛЮЧИТЬ Presenter
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let image = presenter.photos[indexPath.row]
        let imageInsets = UIEdgeInsets(top: 4, left: 16, bottom: 4, right: 16)
        let imageViewWidth = tableView.bounds.width - imageInsets.left - imageInsets.right
        let imageWidth = image.size.width
        let scale = imageViewWidth / imageWidth
        let cellHeight = image.size.height * scale + imageInsets.top + imageInsets.bottom
        return cellHeight
    }
    
    /// В этом методе вызываем метод fetchPhotosNextPage через Presenter
    //    ✅
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        guard indexPath.row + 1 == presenter.photos.count else { return }
        presenter.fetchPhotosNextPage()
    }
}

//MARK: - UITableViewDataSource
extension ImagesListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //данный метод опред. кол. ячеек в секции таблицы
        return presenter.photos.count
    }
    
    /// Метод возвращает ячейку
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        ///1) Добавляем метод, который из всех ячеек, зарегистрированных ранее, возвращает ячейку по идентификатору, добавленому ранее.
        let cell = tableView.dequeueReusableCell(withIdentifier: "ImagesListCell", for: indexPath)
        /// 2) Для работы с ячейкой как с экземпляром класса ImagesListCell - нужно сделать приведение типов
        guard let imageListCell = cell as? ImagesListCell else {
            return UITableViewCell()
        }
        imageListCell.backgroundColor = .YPBlack
        imageListCell.delegate = self
        /// 3) Метод конфигурации ячейки (искать в классе ImageList)
        configCell(for: imageListCell, with: indexPath)
        /// 4) Возвращаем ячейку
        return imageListCell
    }
    
}
//MARK: - Протягивание данных из класса ImageListCell
extension ImagesListViewController: ImagesListViewControllerProtocol {
    func updateTableViewAnimated(from oldCount: Int, to newCount: Int) {
        if oldCount != newCount {
            tableView.performBatchUpdates {
                let indexPaths = (oldCount..<newCount).map { i in
                    IndexPath(row: i, section: 0)
                }
                tableView.insertRows(at: indexPaths, with: .automatic)
            } completion: { _ in }
        }
    }
    
    func configureCellElements(cell: ImagesListCell, image: UIImage, date: String?, isLiked: Bool, imageURL: URL) {
        cell.configureCellElements(image: image, date: date, isLiked: isLiked, imageURL: imageURL)
        
    }
}

//MARK: - ImagesListCellDelegate
extension ImagesListViewController: ImagesListCellDelegate {
    func stopImageTask(for url: URL) {
        presenter.cancelImageDownloadTask(for: url)
    }
    
    func imageListCellDidTapLike(_ cell: ImagesListCell) {
        guard let indexPath = tableView.indexPath(for: cell) else { return }
        /// show Loader
        UIBlockingProgressHUD.show()
        presenter.likeButtonTapped(for: indexPath) { [ weak self ] isSuccessfully in
            guard let self = self else { return }
            if isSuccessfully {
                self.tableView.reloadRows(at: [indexPath], with: .none)
                //ТУТ МОЖЕТ БЫТЬ ПРОБЛЕМА!
                cell.setIsLiked(self.presenter.photos[indexPath.row].likedByUser)
                UIBlockingProgressHUD.dismiss()
            } else {
                DispatchQueue.main.async {
                    UIBlockingProgressHUD.dismiss()
                    self.showAlertViewController()
                    return
                }
            }
        }
    }
    
    private func showAlertViewController() {
        let alertVC = UIAlertController(
            title: "Что-то пошло не так(",
            message: "Не удалось поставить лайк:(",
            preferredStyle: .alert)
        let action = UIAlertAction(title: "Ok", style: .default)
        alertVC.addAction(action)
        present(alertVC, animated: true)
    }
}
