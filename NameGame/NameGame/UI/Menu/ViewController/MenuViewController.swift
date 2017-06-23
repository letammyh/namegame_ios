//
//  MenuViewController.swift
//  NameGame
//
//  Created by Tammy Le on 6/15/17.
//  Copyright © 2017 WillowTree Apps. All rights reserved.
//

import UIKit

class MenuViewController: UIViewController {

    @IBOutlet weak var nameGameLabel: UILabel!
    @IBOutlet weak var playButton: UIButton!
    @IBOutlet weak var teamMembersButton: UIButton!
    
    weak var lifecycleObserver: ViewLifecycleObserver? = nil
    
    class func make() -> MenuViewController {
        return UIStoryboard.main.make()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

