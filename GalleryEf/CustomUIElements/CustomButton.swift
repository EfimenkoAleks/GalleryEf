//
//  CustomButton.swift
//  GalleryEf
//
//  Created by user on 28.07.2023.
//

import UIKit

@IBDesignable
final class CustomButton: UIButton {
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        backgroundColor = UIColor.systemBlue
        layer.cornerRadius = frame.height / 2
        layer.masksToBounds = true
    }
    
    @IBInspectable var titleText: String? {
        didSet {
            let multipleAttributes: [NSAttributedString.Key : Any] = [
                NSAttributedString.Key.foregroundColor: UIColor.white,
                NSAttributedString.Key.font: UIFont.systemFont(ofSize: 16.0)]
            
            let myStringAtributed = NSMutableAttributedString(string: titleText ?? "", attributes: multipleAttributes )
            setAttributedTitle(myStringAtributed, for: .normal)
        }
    }
}
