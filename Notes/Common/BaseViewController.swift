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
    
    private static let toastVisibleTime: TimeInterval = 2.0
       
    private lazy var toastView: ToastView = .init(frame: .zero)
    private var toastViewBottomConstraint: NSLayoutConstraint?
    
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
    
    public func showErrorMessage(_ errorMessage: String?) {
        toastView.backgroundColor = .red
        if let errorMessage = errorMessage, !errorMessage.isEmpty {
            toastView.setMessage(errorMessage)
        }
        else {
            toastView.setMessage("👨‍🔧\nSomething went wrong!")
        }
        showToastView()
    }

}

private extension BaseViewController {
    
    func createViews() {
        toastView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(toastView)
        toastView.leadingAnchor.constraint(equalTo: view.leadingAnchor,
                                            constant: UIConstants.sidePadding).isActive = true
        toastView.trailingAnchor.constraint(equalTo: view.trailingAnchor,
                                             constant: -UIConstants.sidePadding).isActive = true
        toastViewBottomConstraint = toastView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor,
                                                                      constant: 200)
        toastViewBottomConstraint?.isActive = true
        
        
    }
    
    private func showToastView() {
        if toastView.isVisible {
            return
        }
        toastView.isVisible = true
        view.bringSubviewToFront(toastView)
        self.view.layoutIfNeeded()
        toastViewBottomConstraint?.constant = -UIConstants.verticalPadding
        UIView.animate(withDuration: 0.35,
                       delay: 0,
                       usingSpringWithDamping: 0.88,
                       initialSpringVelocity: 0.4,
                       options: .curveEaseInOut,
                       animations: {
                        self.view.layoutIfNeeded()
        }) { (_) in
            DispatchQueue.main.asyncAfter(deadline: .now() + BaseViewController.toastVisibleTime) {
                self.hideToastView()
            }
        }
    }
    
    private func hideToastView() {
        self.view.layoutIfNeeded()
        toastViewBottomConstraint?.constant = 200
        UIView.animate(withDuration: 0.35,
                      delay: 0,
                      usingSpringWithDamping: 0.88,
                      initialSpringVelocity: 0.4,
                      options: .curveEaseInOut,
                      animations: {
                       self.view.layoutIfNeeded()
        }) { (_) in
            self.toastView.isVisible = false
        }
    }
    
}

