//
//  MenuViewController.swift
//  InteractiveSlideInMenu
//
//  Created by Nicolas Suarez-Canton Trueba on 9/11/17.
//  Copyright © 2017 Nicolas Suarez-Canton Trueba. All rights reserved.
//

import UIKit

class MenuViewController: UIViewController {
	
	// MARK: - Properties
	
	lazy var customTransitionDelegate = SlideInPresentationManager(direction: PresentationDirection.left)
	
	var interactionController: UIPercentDrivenInteractiveTransition?
	
	
	// MARK: - Life cycle
	
	override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
		super.init(nibName: nil, bundle: nil)
		self.modalPresentationStyle = .custom
		self.transitioningDelegate = customTransitionDelegate
	}
	
	required init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
		self.modalPresentationStyle = .custom
		self.transitioningDelegate = customTransitionDelegate
	}
	
    override func viewDidLoad() {
        super.viewDidLoad()
		self.view.backgroundColor = UIColor.green
		
		let panRight = UIPanGestureRecognizer(target: self, action: #selector(self.handlePanRight))
		self.view.addGestureRecognizer(panRight)
    }
	
	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
		// Dispose of any resources that can be recreated.
	}

	
	// MARK: View setup
	
	func handlePanRight(_ gesture: UIPanGestureRecognizer) {
		guard let view: UIView = gesture.view else {
			return
		}
		
		let translate = gesture.translation(in: view)
		let percent = -translate.x / view.bounds.size.width
		
		switch gesture.state {
			case UIGestureRecognizerState.began:
				interactionController = UIPercentDrivenInteractiveTransition()
				customTransitionDelegate.interactionController = interactionController
				
				dismiss(animated: true)
			case UIGestureRecognizerState.changed:
				interactionController?.update(percent)
			case UIGestureRecognizerState.cancelled:
				fallthrough
			case UIGestureRecognizerState.ended:
				if (percent > 0.60) {
					interactionController?.finish()
				} else {
					interactionController?.update(0.0)
					interactionController?.cancel()
				}
				
				interactionController = nil
			default:
				break
		}
	}
}
