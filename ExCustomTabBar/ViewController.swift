//
//  ViewController.swift
//  ExCustomTabBar
//
//  Created by 김종권 on 2023/01/04.
//

import UIKit

class ViewController: UIViewController {
    let tabBarView = CustomTabBar(tabItems: [.home, .chat, .my])
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(tabBarView)
        
        tabBarView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            tabBarView.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor),
            tabBarView.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor),
            tabBarView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            tabBarView.heightAnchor.constraint(equalToConstant: 56),
            tabBarView.widthAnchor.constraint(equalTo: view.safeAreaLayoutGuide.widthAnchor),
        ])
        
    }
}
