//
//  UIImage.swift
//  Reminder
//
//  Created by Mert Ozseven on 17.01.2025.
//

import UIKit

extension UIImage {

    /// UIImage extension to resize image
    /// - Parameters:
    /// - targetSize: CGSize
    func resized(to targetSize: CGSize) -> UIImage? {
        let renderer = UIGraphicsImageRenderer(size: targetSize)
        let newImage = renderer.image { (context) in
            self.draw(in: CGRect(origin: .zero, size: targetSize))
        }

        return newImage
    }

}
