//
//  ViewController.swift
//  NYT-Test
//
//  Created by Ангеліна Семенченко on 03.07.2023.
//

import UIKit
import SnapKit

protocol CategoriesTableViewControllerProtocol: AnyObject {
    func didFetchCategories(_ category: [Category])
    func didFailWithError(_ error: NetworkingError)
    func didSelectCategory(_ category: Category)
}

final class CategoriesTableViewController: UITableViewController, CategoriesTableViewControllerProtocol {
    private var categories: [Category] = []
    private var presenter: CategoriesPresenterProtocol
    
    init(presenter: CategoriesPresenterProtocol) {
        self.presenter = presenter
        super.init(style: .insetGrouped)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureTableView()
        fetchCategories()
        
        title = NSLocalizedString("categories_screen_title", comment: "Categories Screen Title")
    }
    
    private func configureTableView() {
        tableView.register(CategoryCell.self, forCellReuseIdentifier: "CategoryCell")
        tableView.tableFooterView = UIView()
        tableView.rowHeight = 60
    }
    
    private func fetchCategories() {
        presenter.fetchCategories()
    }
    
    // MARK: - CategoriesTableViewControllerProtocol Methods
    
    func didFetchCategories(_ categories: [Category]) {
        self.categories = categories
        tableView.reloadData()
    }
    
    func didFailWithError(_ error: NetworkingError) {
        // TODO: Handle error
    }
    
    func didSelectCategory(_ category: Category) {
        let booksViewController = VCFactory.createBooksController(for: category)
        navigationController?.pushViewController(booksViewController, animated: true)
    }
    
    // MARK: - Table View Data Source
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categories.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath) as? CategoryCell {
            let category = categories[indexPath.row]
            cell.configure(with: category)
            return cell
        }
        return UITableViewCell()
    }
    
    // MARK: - Table View Delegate
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedCategory = categories[indexPath.row]
        didSelectCategory(selectedCategory)
    }
    
    //    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
    //        let headerView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.bounds.width, height: 10))
    //        headerView.backgroundColor = .clear
    //        return headerView
    //    }
}
