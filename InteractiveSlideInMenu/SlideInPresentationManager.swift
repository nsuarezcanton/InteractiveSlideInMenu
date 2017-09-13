//
//  SlideInPresentationManager.swift
//  InteractiveSlideInMenu
//
//  Created by Nicolas Suarez-Canton Trueba on 9/12/17.
//  Copyright © 2017 Nicolas Suarez-Canton Trueba. All rights reserved.
//

import UIKit

enum PresentationDirection {
	case left
	case top
	case right
	case bottom
}

class SlideInPresentationManager: NSObject {
	var direction: PresentationDirection
	
	weak var interactionController: UIPercentDrivenInteractiveTransition?
	
	init(direction: PresentationDirection) {
		self.direction = direction
	}
	
}


// MARK: - UIViewControllerTransitioningDelegate conformance

extension SlideInPresentationManager: UIViewControllerTransitioningDelegate {
	
	
	func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
		let presentationController = SlideInPresentationController(presentedViewController: presented, presenting: presenting, direction: direction)
		return presentationController
	}
	
	func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
		return SlideInPresentationAnimator(direction: direction, isPresentation: true)
	}
	
	func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
		return SlideInPresentationAnimator(direction: direction, isPresentation: false)
	}

	func interactionControllerForPresentation(using animator: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
		return interactionController
	}
	
	func interactionControllerForDismissal(using animator: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
		return interactionController
	}
}
