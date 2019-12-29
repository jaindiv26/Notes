//
//  ViewController.swift
//  Notes
//
//  Created by Divyansh Jain on 24/12/19.
//  Copyright © 2019 Divyansh Jain. All rights reserved.
//

import Foundation
import UIKit
import CoreData

class HomeViewController: BaseViewController {
    
    lazy var presenter = HomeViewPresenter(with: self)
    
    public lazy var searchBar: UISearchBar = {
        let searchBar = UISearchBar.init()
        searchBar.translatesAutoresizingMaskIntoConstraints = false
        searchBar.delegate = self
        searchBar.backgroundColor = .systemBackground
        return searchBar
    }()
    
    public lazy var tableView: UITableView = {
        let tableView = UITableView.init(frame: CGRect.zero)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.separatorStyle = UITableViewCell.SeparatorStyle.none
        tableView.separatorInset = .zero
        tableView.estimatedRowHeight = 20.0
        tableView.rowHeight = UITableView.automaticDimension
        tableView.keyboardDismissMode = .onDrag
        tableView.backgroundColor = .systemBackground
        tableView.delegate = self
        tableView.dataSource = self
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .systemBackground
        
        initNavigationBar()
        setSearchBar()
        setTableView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        presenter.readNotesFromCoreData()
    }
}

extension HomeViewController {
    
    private func setSearchBar() {
        view.addSubview(searchBar)
        searchBar.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        searchBar.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        searchBar.topAnchor.constraint(equalTo: safeAreaGuide!.topAnchor).isActive = true
        searchBar.heightAnchor.constraint(equalToConstant: 37).isActive = true
    }
    
    private func setTableView() {
        view.addSubview(tableView)
        tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        tableView.topAnchor.constraint(equalTo: searchBar.bottomAnchor,
                                       constant: UIConstants.verticalPadding).isActive = true
        tableView.bottomAnchor.constraint(equalTo: safeAreaGuide!.bottomAnchor).isActive = true
        tableView.register(HomeViewCell.self,
                           forCellReuseIdentifier: HomeViewCell.self.description())
    }
    
    private func initNavigationBar() {
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(didTapAddButton))
        self.navigationController?.navigationBar.prefersLargeTitles = true
        self.navigationItem.largeTitleDisplayMode = .always
        self.navigationItem.title = "Notes"
    }
    
    @objc func didTapAddButton() {
        navigationController?.pushViewController(AddNoteViewController(), animated: true)
    }
}

extension HomeViewController: HomeView {
    func reloadData() {
        tableView.reloadData()
    }
}

extension HomeViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return presenter.getCount()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let item = presenter.getItem(forRow: indexPath.row),
            let cell = tableView.dequeueReusableCell(withIdentifier: HomeViewCell.self.description(),
                                                     for: indexPath) as? HomeViewCell {
            cell.setData(modal: item)
            return cell
        }
        return UITableViewCell()
    }
}

extension HomeViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if (editingStyle == .delete) {
            if let item = presenter.getItem(forRow: indexPath.row) {
                presenter.deleteNote(note: item, index: indexPath.row)
                tableView.deleteRows(at: [indexPath], with: .fade)
            }
        }
    }

    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return .delete
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let item = presenter.getItem(forRow: indexPath.row) {
            navigationController?.pushViewController(AddNoteViewController.init(modal: item), animated: true)
        }
    }
}

extension HomeViewController: UISearchBarDelegate {
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchBar.showsCancelButton = true
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.showsCancelButton = false
        searchBar.text = nil
        searchBar.resignFirstResponder()
        presenter.doSearch(forQuery: nil)
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        presenter.doSearch(forQuery: searchBar.text)
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        presenter.doSearch(forQuery: searchBar.text)
    }
    
}

