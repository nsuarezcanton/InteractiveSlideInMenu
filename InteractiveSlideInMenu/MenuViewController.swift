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
    }
	
	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
		// Dispose of any resources that can be recreated.
	}
}
