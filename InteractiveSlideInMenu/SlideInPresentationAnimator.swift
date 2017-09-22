//
//  SlideInPresentationAnimator.swift
//  InteractiveSlideInMenu
//
//  Created by Nicolas Suarez-Canton Trueba on 9/12/17.
//  Copyright © 2017 Nicolas Suarez-Canton Trueba. All rights reserved.
//

import UIKit

final class SlideInPresentationAnimator: NSObject {
	
	// MARK: - Properties
	
	let direction: PresentationDirection
	
	/// whether presenting or dimissing the view
	let isPresentation: Bool
	
	
	// MARK: - Life cycle
	
	init(direction: PresentationDirection, isPresentation: Bool) {
		self.direction = direction
		self.isPresentation = isPresentation
		super.init()
	}
}

// MARK: - UIViewControllerAnimatedTransitioning conformance

extension SlideInPresentationAnimator: UIViewControllerAnimatedTransitioning {
	
	func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
		return 0.3
	}
	
	func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
		
		let key = isPresentation ? UITransitionContextViewControllerKey.to : UITransitionContextViewControllerKey.from
			
		let controller = transitionContext.viewController(forKey: key)!

		if isPresentation {
			transitionContext.containerView.addSubview(controller.view)
		}

		let presentedFrame = transitionContext.finalFrame(for: controller)
		var dismissedFrame = presentedFrame
		
		switch direction {
			case .left:
				dismissedFrame.origin.x = -presentedFrame.width
			case .right:
				dismissedFrame.origin.x = transitionContext.containerView.frame.size.width
			case .top:
				dismissedFrame.origin.y = -presentedFrame.height
			case .bottom:
				dismissedFrame.origin.y = transitionContext.containerView.frame.size.height
		}

		
		let initialFrame = isPresentation ? dismissedFrame : presentedFrame
		let finalFrame = isPresentation ? presentedFrame : dismissedFrame

		let animationDuration = transitionDuration(using: transitionContext)
		controller.view.frame = initialFrame
		
		UIView.animate(withDuration: animationDuration, animations: { 
			controller.view.frame = finalFrame
		}, completion: { (finished: Bool) in
			transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
		})
	}
}
