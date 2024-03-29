//
//  BaseViewController.swift
//  NFTConnect-iOS
//
//  Created by Gianni Hong on 2024/1/23.
//

import UIKit
import Toast

class BaseViewController: UIViewController {

    weak var coordinatorDelegate: CommonControllerToCoordinatorDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
    }
    
    func setupView() {
        
    }
    
    func showToastMessage(message: String?) {
        DispatchQueue.main.async {
            self.view.makeToast(message)
        }
    }
    
    func showLoading() {
        DispatchQueue.main.async {
            self.view.makeToastActivity(.center)
        }
    }
    
    func hideLoading() {
        DispatchQueue.main.async {
            self.view.hideToastActivity()
        }
    }
    
    func setupNavBar(title: String?, leftIcon: String?, rightIcon: String?, leftItemAction: Selector? = nil, rightItemAction: Selector? = nil) {
        if let leftIcon = leftIcon {
            let leftItem = UIBarButtonItem(image: UIImage(named: leftIcon)?.withRenderingMode(.alwaysOriginal), style: .plain, target: self, action: leftItemAction)
            self.navigationItem.leftBarButtonItem = leftItem
        }
        
        if let rightIcon = rightIcon {
            let rightItem = UIBarButtonItem(image: UIImage(named: rightIcon)?.withRenderingMode(.alwaysOriginal), style: .plain, target: self, action: rightItemAction)
            self.navigationItem.rightBarButtonItem = rightItem
        }
        
        self.title = title
    }
    
    @objc func goBack() {
        if self.navigationController?.viewControllers.count == 1 {
            self.dismiss(animated: true)
        }else {
            self.navigationController?.popViewController(animated: true)
        }
    }

}
