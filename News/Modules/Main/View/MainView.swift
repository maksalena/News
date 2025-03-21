//
//  MainView.swift
//  News
//
//  Created by Алёна Максимова on 21.03.2025.
//

import UIKit

class MainView: UIView {
    
    private(set) lazy var searchBar: UISearchBar = {
        let searchBar = UISearchBar()
        searchBar.translatesAutoresizingMaskIntoConstraints = false
        return searchBar
    }()
    
    private(set) lazy var loading: UIActivityIndicatorView = {
        let loading = UIActivityIndicatorView()
        loading.translatesAutoresizingMaskIntoConstraints = false
        loading.style = .large
        loading.hidesWhenStopped = true
        
        return loading
    }()
    
    private(set) lazy var newsTableView: UITableView = {
        let tableView = UITableView()
        tableView.separatorStyle = .singleLine
        tableView.register(
            MainCell.self,
            forCellReuseIdentifier: MainCell.reusableIdentifier
        )
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupView() {
        [searchBar, newsTableView, loading].forEach(self.addSubview)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        self.addConstraints([
            loading.centerXAnchor.constraint(equalTo: centerXAnchor),
            loading.centerYAnchor.constraint(equalTo: centerYAnchor),
            
            searchBar.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
            searchBar.leadingAnchor.constraint(equalTo: leadingAnchor),
            searchBar.trailingAnchor.constraint(equalTo: trailingAnchor),
            searchBar.heightAnchor.constraint(equalToConstant: 44),
            
            newsTableView.topAnchor.constraint(equalTo: searchBar.bottomAnchor),
            newsTableView.leadingAnchor.constraint(equalTo: leadingAnchor),
            newsTableView.trailingAnchor.constraint(equalTo: trailingAnchor),
            newsTableView.bottomAnchor.constraint(equalTo:safeAreaLayoutGuide.bottomAnchor)
        ])
    }
}
