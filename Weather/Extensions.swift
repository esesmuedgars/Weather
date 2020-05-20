//
//  Extensions.swift
//  Weather
//
//  Created by e.vanags on 20/05/2020.
//  Copyright © 2020 esesmuedgars. All rights reserved.
//

import UIKit

extension UIStoryboard {
    func instantiateViewController<ViewController: UIViewController>(ofType type: ViewController.Type) -> ViewController {
        instantiateViewController(identifier: String(describing: type))
    }
}
