//
//  UIImageView+Extensions.swift
//  Rarticle
//
//  Created by Jamal Aartsen on 11/07/2022.
//

import UIKit
import SkeletonView

extension UIImageView {
    func loadFrom(urlAdress: URL?, placeholder: String) {
        
        self.isSkeletonable = true
        self.showAnimatedGradientSkeleton()
        
        DispatchQueue.init(label: Constants.loadImageFromUrl, qos: .userInitiated).async { [weak self] in
            if let urlAdress = urlAdress, let imageData = try? Data(contentsOf: urlAdress) {
                if let loadedImage = UIImage(data: imageData) {
                    DispatchQueue.main.async { [weak self] in
                        self?.image = loadedImage
                        self?.hideSkeleton()
                    }
                }
            } else {
                DispatchQueue.main.async { [weak self] in
                    self?.image = UIImage(named: placeholder)
                    self?.hideSkeleton()
                }
            }
        }
    }
}
