//
//  CatalogViewController.swift
//  FakeNFT
//
//  Created by Almira Khafizova on 14.01.24.
//

import UIKit
import Kingfisher

// MARK: - Protocol

protocol CatalogViewControllerProtocol: AnyObject {
    func reloadTableView()
}

final class CatalogViewController: UIViewController, CatalogViewControllerProtocol {
    private var presenter: CatalogPresenterProtocol
    
    private lazy var collectionsRefreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(loadNFTCollections), for: .valueChanged)
        return refreshControl
    }()
    
    private lazy var sortButton: UIBarButtonItem = {
        let button = UIBarButtonItem(
            image: UIImage(named: "sort"),
            style: .plain,
            target: self,
            action: #selector(showSortingMenu))
        return button
    }()
    
    private lazy var tableView: UITableView = {
        var tableView = UITableView()
        tableView.register(CatalogCell.self)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.backgroundColor = .ypWhite
        tableView.showsVerticalScrollIndicator = false
        tableView.separatorStyle = .none
        tableView.dataSource = self
        tableView.delegate = self
        return tableView
    }()
    
    init(presenter: CatalogPresenterProtocol) {
        self.presenter = presenter
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        assertionFailure("init(coder:) has not been implemented")
        return nil
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupNavigationBar()
        setupConstraints()
        presenter.viewController = self
        loadNFTCollections()
        view.backgroundColor = .ypWhite
        self.collectionsRefreshControl.endRefreshing()
    }
    
    private func setupNavigationBar() {
        sortButton.tintColor = .ypBlack
        navigationController?.navigationBar.tintColor = .ypWhite
        navigationItem.rightBarButtonItem = sortButton
    }
    
    private func setupConstraints() {
        
        view.addSubview(tableView)
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16)
        ])
    }
    
    func reloadTableView() {
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
    @objc func showSortingMenu() {
        let alertMenu = UIAlertController(title: AppStrings.CatalogVC.sorting, message: nil, preferredStyle: .actionSheet)
        
        alertMenu.addAction(UIAlertAction(title: AppStrings.CatalogVC.sortByName, style: .default, handler: { [weak self] (_) in
            self?.presenter.sortNFTS(by: .name)
            self?.reloadTableView()
        }))
        alertMenu.addAction(UIAlertAction(title: AppStrings.CatalogVC.sortByNFTCount, style: .default, handler: { [weak self] (_) in
            self?.presenter.sortNFTS(by: .nftCount)
            self?.reloadTableView()
        }))
        alertMenu.addAction(UIAlertAction(title: AppStrings.CatalogVC.close, style: .cancel))
        
        present(alertMenu, animated: true)
    }
    
    @objc func loadNFTCollections() {
        presenter.fetchCollections { [weak self] updatedData in
            self?.reloadTableView()
        }
    }
}

// MARK: - UITableViewDelegate, UITableViewDataSource

extension CatalogViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        presenter.getDataSource().count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: CatalogCell = tableView.dequeueReusableCell()
        let nftModel = presenter.getDataSource()[indexPath.row]
        let url = URL(string: nftModel.cover.urlDecoder)
        
        cell.selectionStyle = .none
        cell.setCellImage(with: url)
        cell.setNameLabel(with: "\(nftModel.name) (\(nftModel.nfts.count))")
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        187
    }
}
