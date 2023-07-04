//
//  BooksViewController.swift
//  NYT-Test
//
//  Created by Ангеліна Семенченко on 04.07.2023.
//

import UIKit
import SnapKit

protocol BooksCollectionViewControllerProtocol: AnyObject {
    func didFetchBooks(_ books: [Book])
    func didFailWithError(_ error: NetworkingError)
    func setRouter(_ router: CategoriesRouterProtocol)
    
    var navigationController: UINavigationController? { get }
}

final class BooksCollectionViewController: UIViewController, BooksCollectionViewControllerProtocol {
    private var collectionView: UICollectionView?
    private var books: [Book] = []
    private var category: Category
    private var presenter: BooksPresenterProtocol?
    private var router: CategoriesRouterProtocol?
    
    // MARK: - Initialization
    
    init(category: Category, presenter: BooksPresenterProtocol) {
        self.category = category
        self.presenter = presenter
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        presenter?.fetchBooks(for: category)
        setupCollectionView()
        
        // my localization is not working for arguments
        title = String(format: NSLocalizedString("category_name", comment: "Category Name"), category.name)
        
        // without localization
        // title = "\(category.name)"
        
        navigationController?.navigationBar.prefersLargeTitles = false
    }
    
    // MARK: - Setup View
    
    private func setupCollectionView() {
        let layout = UICollectionViewFlowLayout()
        let itemWidth = (view.bounds.width - 15) / 2
        let itemHeight: CGFloat = 350
        
        layout.scrollDirection = .vertical
        layout.minimumInteritemSpacing = 2 // Отступ между элементами в строке
        layout.itemSize = CGSize(width: itemWidth, height: itemHeight)
        layout.sectionInset = UIEdgeInsets(top: 0, left: 5, bottom: 0, right: 5) // Пример отступов
        
        let collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: layout)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(BookCell.self, forCellWithReuseIdentifier: "BookCell")
        
        view.addSubview(collectionView)
        collectionView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        self.collectionView = collectionView
    }
    
    // MARK: - BooksCollectionViewControllerProtocol
    
    func didFetchBooks(_ books: [Book]) {
        self.books = books
        collectionView?.reloadData()
        print("Did fetch books. Count: \(books.count)")
    }
    
    func showError(message: String) {
        let title = NSLocalizedString("alert_error", comment: "Error")
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        present(alert, animated: true)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            alert.dismiss(animated: true, completion: { [weak self] in
                self?.navigationController?.popViewController(animated: true)
            })
        }
    }
    
    func didFailWithError(_ error: NetworkingError) {
        if case .responseSerializationFailed = error {
            let message = NSLocalizedString("response_serialization_error", comment: "Response Serialization Error")
            showError(message: message)
        } else {
            let message = NSLocalizedString("unknown_error", comment: "Unknown error occured")
            showError(message: message)
        }
    }
    
    func setRouter(_ router: CategoriesRouterProtocol) {
        self.router = router
    }
}

// MARK: - UICollectionViewDataSource

extension BooksCollectionViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return books.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "BookCell", for: indexPath) as? BookCell else {
            fatalError("Expected to dequeue a BookCell")
        }
        
        let book = books[indexPath.item]
        cell.configure(with: book)
        return cell
    }
}
