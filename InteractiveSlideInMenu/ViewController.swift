//
//  ViewController.swift
//  InteractiveSlideInMenu
//
//  Created by Nicolas Suarez-Canton Trueba on 9/11/17.
//  Copyright © 2017 Nicolas Suarez-Canton Trueba. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
	
	// MARK: - Subviews
	
	lazy var menuViewController: MenuViewController = {
		let viewController: MenuViewController = MenuViewController()
		return viewController
	}()
	
	
	// MARK: - Properties	
	
	var interactionController: UIPercentDrivenInteractiveTransition?
	
	
	// MARK: - Life cycle
	
	override func viewDidLoad() {
		super.viewDidLoad()
		// Do any additional setup after loading the view, typically from a nib.
		self.view.backgroundColor = UIColor.red
		self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.action, target: self, action: #selector(ViewController.openMenu))
		
		let leftEdgePan: UIScreenEdgePanGestureRecognizer = UIScreenEdgePanGestureRecognizer(target: self, action: #selector(handleLeftEdgePan))
		leftEdgePan.edges = .left
		self.view.addGestureRecognizer(leftEdgePan)

		
	}

	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
		// Dispose of any resources that can be recreated.
	}
	
	
	// MARK: - View setup
	
	func openMenu() -> Void {
		self.navigationController?.present(self.menuViewController, animated: true)
	}
	
	func handleLeftEdgePan(_ gesture: UIScreenEdgePanGestureRecognizer) -> Void {
		guard let view: UIView = gesture.view else {
			return
		}
		let translate = gesture.translation(in: view)
		let percent = translate.x / view.bounds.size.width
		
		switch gesture.state {
			case UIGestureRecognizerState.began:
				self.interactionController = UIPercentDrivenInteractiveTransition()
				self.menuViewController.customTransitionDelegate.interactionController = self.interactionController
				self.navigationController?.present(self.menuViewController, animated: true)
			case UIGestureRecognizerState.changed:
				interactionController?.update(percent)
			case UIGestureRecognizerState.cancelled:
				fallthrough
			case UIGestureRecognizerState.ended:
				if (percent > 0.5) {
					interactionController?.finish()
				} else {
					interactionController?.cancel()
					self.menuViewController.dismiss(animated: true, completion: nil)
				}
				interactionController = nil
			default:
					break
		}
	}
}
