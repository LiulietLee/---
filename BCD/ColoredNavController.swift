//
//  ColoredNavController.swift
//  BCD
//
//  Created by Liuliet.Lee on 11/7/2017.
//  Copyright © 2017 Liuliet.Lee. All rights reserved.
//

import UIKit

class ColoredNavController: UINavigationController {
    var navbarTintColor: UIColor { return .black }

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationBar.barTintColor = navbarTintColor
        navigationBar.tintColor = .white
        navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor : UIColor.white]
//        navigationBar.layer.shadowColor = UIColor.black.cgColor
//        navigationBar.layer.shadowOffset = CGSize(width: 0.1, height: 0.1)
//        navigationBar.layer.shadowRadius = 1.5
//        navigationBar.layer.shadowOpacity = 1.0
    }
}

extension UIColor {
    static let tianyiBlue = UIColor(hex: 0x56bcef)
    static let bilibiliPink = #colorLiteral(red: 1, green: 0.2319664663, blue: 0.4985880365, alpha: 1)
}
