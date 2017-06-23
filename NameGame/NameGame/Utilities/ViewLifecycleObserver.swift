//
//  ViewLifecycleObserver.swift
//  NameGame
//
//  Created by Tammy Le on 6/22/17.
//  Copyright © 2017 WillowTree Apps. All rights reserved.
//

import Foundation

protocol ViewLifecycleObserver: class {
    func viewDidLoad()
    func viewWillAppear(_ animated: Bool)
    func viewDidAppear(_ animated: Bool)
    func viewWillDisappear(_ animated: Bool)
    func viewDidDisappear(_ animated: Bool)
}

extension ViewLifecycleObserver {
    func viewDidLoad() {}
    func viewWillAppear(_ animated: Bool) {}
    func viewDidAppear(_ animated: Bool) {}
    func viewWillDisappear(_ animated: Bool) {}
    func viewDidDisappear(_ animated: Bool) {}

}
