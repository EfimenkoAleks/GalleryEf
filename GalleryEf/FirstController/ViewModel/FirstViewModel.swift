//
//  FirstViewModel.swift
//  GalleryEf
//
//  Created by user on 27.07.2023.
//

import Foundation

class FirstViewModel {

    init() {
     
    }
}

extension FirstViewModel: FirstViewModelProtocol {

    func selectImageFrom(_ source: ImageSource) -> PickerModel {
        switch source {
        case .video:
            return PickerModel(sourceType: .camera, mediaTypes: .video)
        case .photo:
            return PickerModel(sourceType: .camera, mediaTypes: .image)
        case .photoLibrary:
            return PickerModel(sourceType: .library, mediaTypes: .library)
        }
    }
}
