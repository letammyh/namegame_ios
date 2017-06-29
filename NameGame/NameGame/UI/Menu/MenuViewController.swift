//
//  MenuViewController.swift
//  NameGame
//
//  Created by Tammy Le on 6/15/17.
//  Copyright © 2017 WillowTree Apps. All rights reserved.
//

import UIKit
import ReSwift

protocol MenuViewEventHandler {
    func didPressPlayButton()
    func didPressTeamMembersButton()
}

class MenuViewController: UIViewController {

    @IBOutlet weak var nameGameLabel: UILabel!
    @IBOutlet weak var playButton: UIButton!
    @IBOutlet weak var teamMembersButton: UIButton!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    fileprivate var viewModel = MenuViewModel()
    weak var lifecycleObserver: ViewLifecycleObserver? = nil
    private var eventHandler: MenuViewEventHandler!
    
    class func make() -> MenuViewController {
        return UIStoryboard.main.make()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        lifecycleObserver?.viewDidLoad()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        lifecycleObserver?.viewWillAppear(animated)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        lifecycleObserver?.viewDidAppear(animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        lifecycleObserver?.viewWillDisappear(animated)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        lifecycleObserver?.viewDidDisappear(animated)
    }
    
    @IBAction private func playButtonPressed(sender: AnyObject) {
        eventHandler.didPressPlayButton()
    }
    
    @IBAction private func teamMembersButtonPressed(sender: AnyObject) {
        eventHandler.didPressTeamMembersButton()
    }
    
    func inject(_ eventHandler: MenuViewEventHandler) {
        self.eventHandler = eventHandler
    }

}

extension MenuViewController: StoreSubscriber {
    
    func newState(state: MenuViewModel) {
        viewModel = state
        renderLoadingStatus(with: viewModel)
        
    }
    
    func renderLoadingStatus(with viewModel: MenuViewModel) {
        if viewModel.shouldShowActivityIndicator {
            activityIndicator.startAnimating()
        } else {
            activityIndicator.stopAnimating()
        }
    }
    
}


