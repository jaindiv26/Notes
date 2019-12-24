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

class HomeViewController: UIViewController {
    
    lazy var presenter = HomeViewPresenter(with: self)
    var safeAreaGuide: UILayoutGuide? = nil
    
    public lazy var tableView: UITableView = {
        let tableView = UITableView.init(frame: CGRect.zero)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.separatorStyle = UITableViewCell.SeparatorStyle.none
        tableView.separatorInset = .zero
        tableView.rowHeight = UITableView.automaticDimension
        tableView.keyboardDismissMode = .onDrag
        return tableView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .systemBackground

        initNavigationBar()
        safeAreaGuide = view.safeAreaLayoutGuide
        
        view.addSubview(tableView)
        tableView.leadingAnchor.constraint(equalTo: safeAreaGuide!.leadingAnchor).isActive = true
        tableView.trailingAnchor.constraint(equalTo: safeAreaGuide!.trailingAnchor).isActive = true
        tableView.topAnchor.constraint(equalTo: safeAreaGuide!.topAnchor,
                                       constant: UIConstants.verticalPadding).isActive = true
        tableView.bottomAnchor.constraint(equalTo: safeAreaGuide!.bottomAnchor).isActive = true
        tableView.backgroundColor = .blue
    }
}

extension HomeViewController {
    
    private func initNavigationBar() {
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(didTapAddButton))
        self.navigationController?.navigationBar.prefersLargeTitles = true
        self.navigationItem.title = "Notes"
    }
    
    @objc func didTapAddButton() {
        print("didTapAddButton")
    }
}

extension HomeViewController: HomeView {
    func any() {
        
    }
}

//extension HomeViewController: UITableViewDelegate, UITableViewDataSource {
//    
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return 0
//    }
//    
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        return nil
//    }
//    
//}

