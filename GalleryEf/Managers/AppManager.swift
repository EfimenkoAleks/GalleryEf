//
//  AppManager.swift
//  GalleryEf
//
//  Created by user on 29.07.2023.
//

import Foundation

class AppManager {
    
    static let shared: AppManager = AppManager()
    
    let router: Router = Router()
    let strManager: StringManager = StringManager()
}
