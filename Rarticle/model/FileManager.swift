//
//  FileManager.swift
//  Rarticle
//
//  Created by Jamal Aartsen on 05/07/2022.
//

import Foundation

class FileManager {
    var session = URLSession.shared
    
    // Change to Nuke
    func downloadImage(url: String) async throws -> Data {
        let imageData = try? Data(contentsOf: URL(string: url)!)
        
        return imageData!
    }
}
