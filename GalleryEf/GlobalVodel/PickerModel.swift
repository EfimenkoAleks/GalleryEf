//
//  PickerModel.swift
//  GalleryEf
//
//  Created by user on 29.07.2023.
//

import Foundation

struct PickerModel {
    var sourceType: PickerSourceType
    var mediaTypes: PickerMediaType
}

enum PickerMediaType {
    case video, image, library
}

enum PickerSourceType {
    case camera, library
}

enum ImageSource {
    case photoLibrary
    case photo
    case video
}
