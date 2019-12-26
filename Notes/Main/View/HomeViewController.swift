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
    
    public lazy var tableView: UITableView = {
        let tableView = UITableView.init(frame: CGRect.zero)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.separatorStyle = UITableViewCell.SeparatorStyle.none
        tableView.separatorInset = .zero
        tableView.estimatedRowHeight = 20.0
        tableView.rowHeight = UITableView.automaticDimension
        tableView.keyboardDismissMode = .onDrag
        return tableView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .systemBackground

        initNavigationBar()
        setTableView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        presenter.readNotesFromCoreData()
    }
}

extension HomeViewController {
    
    private func setTableView() {
        view.addSubview(tableView)
        tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        tableView.topAnchor.constraint(equalTo: safeAreaGuide!.topAnchor,
                                       constant: UIConstants.verticalPadding).isActive = true
        tableView.bottomAnchor.constraint(equalTo: safeAreaGuide!.bottomAnchor).isActive = true
        tableView.backgroundColor = .systemBackground
        tableView.dataSource = self
        tableView.delegate = self
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
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        return
    }
}

