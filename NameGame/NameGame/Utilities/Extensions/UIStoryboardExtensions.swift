//
//  UIStoryboardExtensions.swift
//  NameGame
//
//  Created by Tammy Le on 6/22/17.
//  Copyright © 2017 WillowTree Apps. All rights reserved.
//

import UIKit

extension UIStoryboard {
    
    class var main: UIStoryboard {
        return UIStoryboard(name: "Main", bundle: nil)
    }
    
    func make<ViewControllerType>() -> ViewControllerType {
        let controller = instantiateViewController(
            withIdentifier: String(describing: ViewControllerType.self)
        )
        return controller as! ViewControllerType
    }

}
