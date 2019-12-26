//
//  BaseViewController.swift
//  Notes
//
//  Created by Divyansh Jain on 24/12/19.
//  Copyright © 2019 Divyansh Jain. All rights reserved.
//

import Foundation
import UIKit

public class BaseViewController: UIViewController {
    
    var safeAreaGuide: UILayoutGuide? = nil
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        safeAreaGuide = view.safeAreaLayoutGuide
        createViews()
    }
    
    func showAlert(from vc: UIViewController, title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: nil))
        vc.present(alert, animated: true, completion: nil)
    }

}

private extension BaseViewController {
    
    func createViews() {
    
    }
    
}
