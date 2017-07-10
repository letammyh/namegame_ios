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
    func didPressMattModeButton()
    func didPressTeamMembersButton()
}

class MenuViewController: UIViewController {
    
    @IBOutlet weak var playButton: UIButton!
    @IBOutlet weak var mattModeButton: UIButton!
    @IBOutlet weak var teamMembersButton: UIButton!
    
    @IBOutlet var mainView: UIView!
    @IBOutlet weak var overlayImageView: UIImageView!
    @IBOutlet weak var stackView: UIStackView!
    @IBOutlet var viewCollection: [UIView]! {
        didSet {
            viewCollection.forEach {
                $0.isHidden = true
            }
        }
    }
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    fileprivate var mask: CALayer!
    fileprivate var animation: CABasicAnimation!
    
    fileprivate var viewModel = MenuViewModel()
    weak var lifecycleObserver: ViewLifecycleObserver? = nil
    private var eventHandler: MenuViewEventHandler!
    
    class func make() -> MenuViewController {
        return UIStoryboard.main.make()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        lifecycleObserver?.viewDidLoad()
        
        animateLaunch()

        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(3), execute: {
            self.animateStackView()
        })
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = false
        self.navigationController?.navigationBar.topItem?.title = ""
        
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
    
    @IBAction func mattModeButtonPressed(_ sender: Any) {
        eventHandler.didPressMattModeButton()
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

extension MenuViewController: CAAnimationDelegate {
    
    func animateLaunch() {
        mask = CALayer()
        
        // Not sure if mask.frame & mask.contents working/is necessary
        mask.frame = mainView.bounds
        mask.contents = #imageLiteral(resourceName: "WTPlaceholder").cgImage
        
        mask.bounds = CGRect(x: 0, y: 0, width: 150, height: 150)
        mask.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        mask.position = CGPoint(x: mainView.frame.width/2.0 + 37, y: mainView.frame.height/2.0 + 75)
        mainView.layer.mask = mask
        
        animateDecreaseSize()
    }
    
    private func animateDecreaseSize() {
        let decreaseSize = CABasicAnimation(keyPath: "bounds")
        decreaseSize.delegate = self
        decreaseSize.duration = 1.0
        decreaseSize.fromValue = NSValue(cgRect: mask!.bounds)
        decreaseSize.toValue = NSValue(cgRect: CGRect(x: 0, y: 0, width: 80, height: 80))
        
        decreaseSize.fillMode = kCAFillModeForwards
        decreaseSize.isRemovedOnCompletion = false
        
        mask.add(decreaseSize, forKey: "bounds")
    }
    
    func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
        animateIncreaseSize()
    }
    
    private func animateIncreaseSize() {
        animation = CABasicAnimation(keyPath: "bounds")
        animation.duration = 2
        animation.fromValue = NSValue(cgRect: mask!.bounds)
        animation.toValue = NSValue(cgRect: CGRect(x: 0, y: 0, width: 4000, height: 4000))
        
        animation.fillMode = kCAFillModeForwards
        animation.isRemovedOnCompletion = false
        
        mask.add(animation, forKey: "bounds")
        
        UIView.animate(withDuration: 2) {
            self.overlayImageView.alpha = 0
        }
    }
    
    func animateStackView() {
        UIView.animate(withDuration: 0.7) {
            self.viewCollection.forEach {
                $0.isHidden = !$0.isHidden
            }
        }
        
        animateButtons()
    }
    
    private func animateButtons() {
        playButton.transform = CGAffineTransform(scaleX: 0.1, y: 0.1)
        mattModeButton.transform = CGAffineTransform(scaleX: 0.1, y: 0.1)
        teamMembersButton.transform = CGAffineTransform(scaleX: 0.1, y: 0.1)
        
        UIView.animate(withDuration: 1.75, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 6.0, options: .allowUserInteraction,
                       animations: { [weak self] in
                        self?.playButton.transform = .identity
            },
                       completion: nil)
        
        UIView.animate(withDuration: 1.75, delay: 0.3, usingSpringWithDamping: 0.5, initialSpringVelocity: 6.0, options: .allowUserInteraction,
                       animations: { [weak self] in
                        self?.mattModeButton.transform = .identity
            },
                       completion: nil)
        
        UIView.animate(withDuration: 1.75, delay: 0.6, usingSpringWithDamping: 0.5, initialSpringVelocity: 6.0, options: .allowUserInteraction,
                       animations: { [weak self] in
                        self?.teamMembersButton.transform = .identity
            },
                       completion: nil)
        
    }
    
}


