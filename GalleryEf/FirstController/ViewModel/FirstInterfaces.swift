//
//  FirstInterfaces.swift
//  GalleryEf
//
//  Created by user on 27.07.2023.
//

import Foundation

protocol FirstViewModelProtocol: AnyObject {
    func selectImageFrom(_ source: ImageSource) -> PickerModel
}
