//
//  Router.swift
//  GalleryEf
//
//  Created by user on 29.07.2023.
//

import UIKit

class Router {
    
    private var window: UIWindow?
    
    init() {}
    
    func startVC(_ window: UIWindow?) {
        self.window = window
        let view = FirstViewController()
        let navigate = UINavigationController(rootViewController: view)
        self.window?.rootViewController = navigate
        self.window?.makeKeyAndVisible()
    }
}
