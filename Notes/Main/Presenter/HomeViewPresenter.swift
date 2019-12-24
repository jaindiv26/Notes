//
//  HomeViewPresenter.swift
//  Notes
//
//  Created by Divyansh Jain on 24/12/19.
//  Copyright © 2019 Divyansh Jain. All rights reserved.
//

import Foundation

protocol HomeView: class {
    func any()
}

class HomeViewPresenter {
    
    weak var view: HomeView?
    
    init(with view: HomeView) {
        self.view = view
    }
    
}
