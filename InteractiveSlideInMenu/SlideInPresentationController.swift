//
//  SlideInPresentationController.swift
//  InteractiveSlideInMenu
//
//  Created by Nicolas Suarez-Canton Trueba on 9/12/17.
//  Copyright © 2017 Nicolas Suarez-Canton Trueba. All rights reserved.
//

import UIKit

class SlideInPresentationController: UIPresentationController {

	// MARK: - Subviews
	
	fileprivate var dimmingView: UIView = {
		let view: UIView = UIView()
		view.translatesAutoresizingMaskIntoConstraints = false
		view.backgroundColor = UIColor(white: 0.0, alpha: 0.5)
		view.alpha = 0.0
		return view
	}()
	
	// MARK: - Properties
	
	private var direction: PresentationDirection
	
	
	// MARK: - Life cycle
	
	init(presentedViewController: UIViewController, presenting presentingViewController: UIViewController?,  direction: PresentationDirection) {
		self.direction = direction
		
		super.init(presentedViewController: presentedViewController, presenting: presentingViewController)
		
		self.setupDimmingView()
	}
	
	
	// MARK: - UIPresentationController methods
	
	override func presentationTransitionWillBegin() {
		guard let containerView: UIView = self.containerView else {
			return
		}
		let dimmingView: UIView = self.dimmingView
		
		containerView.insertSubview(dimmingView, at: 0)
			
		dimmingView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor).isActive = true
		dimmingView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor).isActive = true
		dimmingView.topAnchor.constraint(equalTo: containerView.topAnchor).isActive = true
		dimmingView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor).isActive = true

		guard let coordinator = presentedViewController.transitionCoordinator else {
			dimmingView.alpha = 1.0
			return
		}
			
		coordinator.animate(alongsideTransition: { _ in
			self.dimmingView.alpha = 1.0
		})
	}

	override func dismissalTransitionWillBegin() {
		let dimmingView: UIView = self.dimmingView
		guard let coordinator = presentedViewController.transitionCoordinator else {
			dimmingView.alpha = 0.0
			return
		}

		coordinator.animate(alongsideTransition: { _ in
			dimmingView.alpha = 0.0
		})
	}
	
	override func containerViewWillLayoutSubviews() {
		guard let presentedView =  self.presentedView else {
			return
		}
		
		presentedView.frame = frameOfPresentedViewInContainerView
	}
	
	override func size(forChildContentContainer container: UIContentContainer, withParentContainerSize parentSize: CGSize) -> CGSize {
		switch direction {
			case .left, .right:
				return CGSize(width: parentSize.width * (2.0/3.0), height: parentSize.height)
			case .bottom, .top:
				return CGSize(width: parentSize.width, height: parentSize.height * (2.0/3.0))
		}
	}
	
	override var frameOfPresentedViewInContainerView: CGRect {
		var frame: CGRect = .zero
		guard let containerView: UIView = self.containerView else {
			return frame
		}
		
		frame.size = size(forChildContentContainer: presentedViewController, withParentContainerSize: containerView.bounds.size)

		switch direction {
			case .right:
				frame.origin.x = containerView.frame.width * (1.0/3.0)
			case .bottom:
				frame.origin.y = containerView.frame.height * (1.0/3.0)
			default:
				frame.origin = .zero
		}
		return frame
	}
}


private extension SlideInPresentationController {
	func setupDimmingView() {
		let recognizer = UITapGestureRecognizer(target: self, action: #selector(handleTap(recognizer:)))
		dimmingView.addGestureRecognizer(recognizer)
	}
	
	dynamic func handleTap(recognizer: UITapGestureRecognizer) {
		presentingViewController.dismiss(animated: true)
	}
}
