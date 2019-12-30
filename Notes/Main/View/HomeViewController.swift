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

final class HomeViewController: BaseViewController {
    
    public lazy var searchBar: UISearchBar = {
        let searchBar = UISearchBar.init()
        searchBar.translatesAutoresizingMaskIntoConstraints = false
        searchBar.delegate = self
        searchBar.backgroundColor = .systemBackground
        searchBar.barTintColor = .systemBackground
        searchBar.placeholder = "Search..."
        searchBar.backgroundImage = UIImage()
        return searchBar
    }()
    
    private lazy var filterButton: UIButton = {
        let view = UIButton.init(type: .system)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.setImage(UIImage.init(named: UIConstants.Image.filter.rawValue), for: .normal)
        return view
    }()
    
    public lazy var tableView: UITableView = {
        let tableView = UITableView.init(frame: CGRect.zero)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.separatorStyle = UITableViewCell.SeparatorStyle.none
        tableView.separatorInset = .zero
        tableView.estimatedRowHeight = 44
        tableView.rowHeight = UITableView.automaticDimension
        tableView.keyboardDismissMode = .onDrag
        tableView.backgroundColor = .systemBackground
        tableView.delegate = self
        tableView.dataSource = self
        return tableView
    }()
    
    private lazy var presenter = HomeViewPresenter(withDelegate: self)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        
        initNavigationBar()
        setSearchBar()
        setTableView()
        presenter.getData()
    }
}

private extension HomeViewController {
    
    func initNavigationBar() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add,
                                                            target: self,
                                                            action: #selector(didTapAddButton))
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.largeTitleDisplayMode = .always
        navigationItem.title = "Notes"
    }
    
    func setSearchBar() {
        guard let safeAreaGuide = safeAreaGuide else {
            return
        }
        view.addSubview(filterButton)
        filterButton.trailingAnchor.constraint(equalTo: view.trailingAnchor,
                                               constant: -UIConstants.sidePadding).isActive = true
        filterButton.widthAnchor.constraint(equalToConstant: UIConstants.iconSize.width).isActive = true
        filterButton.heightAnchor.constraint(equalToConstant: UIConstants.iconSize.height).isActive = true
        filterButton.addTarget(self,
                               action: #selector(didTapFilterButton),
                               for: .touchUpInside)
        
        view.addSubview(searchBar)
        searchBar.leadingAnchor.constraint(equalTo: view.leadingAnchor,
                                           constant: UIConstants.sidePadding/2).isActive = true
        searchBar.trailingAnchor.constraint(equalTo: filterButton.leadingAnchor,
                                            constant: -UIConstants.sidePadding/2).isActive = true
        searchBar.topAnchor.constraint(equalTo: safeAreaGuide.topAnchor).isActive = true
        
        filterButton.centerYAnchor.constraint(equalTo: searchBar.centerYAnchor).isActive = true
    }
    
    func setTableView() {
        guard let safeAreaGuide = safeAreaGuide else {
            return
        }
        view.addSubview(tableView)
        tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        tableView.topAnchor.constraint(equalTo: searchBar.bottomAnchor,
                                       constant: UIConstants.betweenPadding).isActive = true
        tableView.bottomAnchor.constraint(equalTo: safeAreaGuide.bottomAnchor).isActive = true
        tableView.register(HomeViewCell.self,
                           forCellReuseIdentifier: HomeViewCell.self.description())
    }
    
    @objc func didTapFilterButton() {
        let filterVC = FilterViewController.init()
        filterVC.delegate = self
        filterVC.appliedFilter = presenter.appliedFilter
        let nav = UINavigationController(rootViewController: filterVC)
        self.navigationController?.present(nav, animated: true, completion: nil)
    }
    
    @objc func didTapAddButton() {
        let addNotesVC = AddNoteViewController()
        addNotesVC.delegate = self
        navigationController?.pushViewController(addNotesVC, animated: true)
    }
}

extension HomeViewController: HomeViewPresenterDelegate {
    
    func didLoadNotes() {
        tableView.reloadData()
    }
    
    func didDeleteNote(atIndex index: Int) {
        tableView.deleteRows(at: [IndexPath.init(row: index, section: 0)], with: .automatic)
    }
    
}

extension HomeViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return presenter.getNumberOfItems()
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

extension HomeViewController: UIScrollViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        searchBar.setShowsCancelButton(false, animated: true)
    }
    
}

extension HomeViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            if let item = presenter.getItem(forRow: indexPath.row) {
                presenter.deleteNote(note: item, index: indexPath.row)
            }
        }
    }

    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return .delete
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let item = presenter.getItem(forRow: indexPath.row) {
            let addNotesVC = AddNoteViewController.init(modal: item)
            addNotesVC.delegate = self
            navigationController?.pushViewController(addNotesVC, animated: true)
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

extension HomeViewController: FilterViewControllerDelegate {
    
    func filterViewController(_ filterViewController:FilterViewController,
                              didApplyFilterWith filter: Filter?) {
        presenter.filterNotes(withAppliedFilter: filter)
    }

}

extension HomeViewController: AddNoteViewControllerDelegate {
    
    func addNoteViewController(_ addNoteViewController: AddNoteViewController, didAddNote note: Notes) {
        presenter.getData()
    }
    
    func addNoteViewController(_ addNoteViewController: AddNoteViewController, didUpdateNote note: Notes) {
        presenter.getData()
    }

    
}

