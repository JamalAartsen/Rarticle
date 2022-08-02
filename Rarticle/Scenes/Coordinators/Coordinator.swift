//
//  Coordinator.swift
//  Rarticle
//
//  Created by Jamal Aartsen on 02/08/2022.
//

import Foundation
import UIKit

protocol Coordinator {
    var navigationController: UINavigationController? { get set }
    
    func start()
}
