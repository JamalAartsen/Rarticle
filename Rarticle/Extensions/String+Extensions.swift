//
//  String+Extensions.swift
//  Rarticle
//
//  Created by Jamal Aartsen on 19/07/2022.
//

import Foundation

extension String {
    func replaceEmptyWithPlus() -> Self {
        return self.replacingOccurrences(of: " ", with: "+")
    }
}
