//
//  UIImageView+Extensions.swift
//  Rarticle
//
//  Created by Jamal Aartsen on 11/07/2022.
//

import UIKit

extension UIImageView {
    // Can use the library Nuke for this
    func loadFrom(urlAdress: String?, placeholder: String) {
        guard let url = URL(string: urlAdress ?? placeholder) else {
            return
        }
        
        // TODO: label in constants zetten
        DispatchQueue.init(label: "loadImageFromUrl", qos: .userInitiated).async { [weak self] in
            if let imageData = try? Data(contentsOf: url) {
                if let loadedImage = UIImage(data: imageData) {
                    DispatchQueue.main.async { [weak self] in
                        self?.image = loadedImage
                    }
                }
            }
        }
    }
}
