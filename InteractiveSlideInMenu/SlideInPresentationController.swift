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
	
	private lazy var dimmingView: UIView = {
		let view: UIView = UIView()
		view.backgroundColor = UIColor.black
		view.translatesAutoresizingMaskIntoConstraints = false
		
		return view
	}()
	
	// MARK: - Properties
	
	/// default alpha level for dimming view
	private let dimmingAlpha: CGFloat = 0.5
	
	/// initial alpha level for presentation
	private let initialDimmingAlpha: CGFloat = 0.0
	
	/// multiplier of screen width / height to use for view controller
	internal static let viewMultiplier: CGFloat = 0.75
	
	/// presentation direction
	private let presentationDirection: PresentationDirection
	
	/// interaction controller
	var interactionController: UIPercentDrivenInteractiveTransition?
	
	/// pan gesture recogniser for interactively dismissing view
	private lazy var panGestureRecogniser: UIPanGestureRecognizer = {
		let recogniser: UIPanGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(handlePan(gesture:)))
		
		return recogniser
	}()
	
	/// tap gesture recogniser for dimming view
	private lazy var tapGestureRecogniser: UITapGestureRecognizer = {
		let recogniser: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(handleTap(recognizer:)))
		recogniser.numberOfTapsRequired = 1
		recogniser.numberOfTouchesRequired = 1
		
		return recogniser
	}()

	
	// MARK: - Life cycle
	
	init(presentedViewController: UIViewController, presenting presentingViewController: UIViewController?,  direction: PresentationDirection) {
		self.presentationDirection = direction
		
		super.init(presentedViewController: presentedViewController, presenting: presentingViewController)
		
	}
	
	
	// MARK: - UIPresentationController methods
	
	override func presentationTransitionWillBegin() {
		super.presentationTransitionWillBegin()
		
		self.setupViews()
		self.setupConstraints()
		
		guard let transitionCoordinator: UIViewControllerTransitionCoordinator = self.presentingViewController.transitionCoordinator else {
			assertionFailure("No transition coordinator for animated view controller transition")
			// set alpha directly
			self.dimmingView.alpha = self.dimmingAlpha
			return
		}
		
		// set initial alpha to allow dimming view to fade in
		self.dimmingView.alpha = self.initialDimmingAlpha
		transitionCoordinator.animate(alongsideTransition: { [weak self](context: UIViewControllerTransitionCoordinatorContext) -> Void in
			self?.dimmingView.alpha = self?.dimmingAlpha ?? 1.0
			}, completion: { (context: UIViewControllerTransitionCoordinatorContext) -> Void in
				
		})
	}
	
	override func presentationTransitionDidEnd(_ completed: Bool) {
		super.presentationTransitionDidEnd(completed)
		
		if completed {
			// only add these recognisers once the presentation has completed, to avoid conflicts with presentation recognisers
			self.dimmingView.addGestureRecognizer(self.tapGestureRecogniser)
			self.presentedView?.addGestureRecognizer(self.panGestureRecogniser)
		}
		else {
			// if the transition was not completed then the presentation was cancelled, so we remove the dimming view which we are responsible for
			self.dimmingView.removeFromSuperview()
		}
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
	
	override func dismissalTransitionDidEnd(_ completed: Bool) {
		super.dismissalTransitionDidEnd(completed)
		
		if !completed {
			// if the transition did not complete then the dismissal was cancelled, so we restore the alpha to its presented value
			self.dimmingView.alpha = self.dimmingAlpha
		}
	}
	
	
	// MARK: View setup
	
	/**
	Setup subviews
	*/
	private func setupViews() -> Void {
		// we need the container view and presented view in order to set up the views
		guard let containerView: UIView = self.containerView,
			let presentedView: UIView = self.presentedView else {
				assertionFailure("Unable to obtain container or presented view for slide-in presenter")
				return
		}
		
		let dimmingView: UIView = self.dimmingView
		
		[
			dimmingView,
			presentedView
		].forEach({ (subview: UIView) -> Void in
			containerView.addSubview(subview)
		})
		
		// bind gesture recognizers
		
		dimmingView.addGestureRecognizer(self.tapGestureRecogniser)
		containerView.addGestureRecognizer(self.panGestureRecogniser)
	}
	
	/**
	Setup constraints on subviews
	*/
	private func setupConstraints() -> Void {
		// we need the container view and presented view in order to set up the views
		guard let containerView: UIView = self.containerView,
			let presentedView: UIView = self.presentedView else {
				assertionFailure("Unable to obtain container or presented view for slide-in presenter")
				return
		}
		
		let dimmingView: UIView = self.dimmingView
		
		// make the dimming view cover the whole screen
		dimmingView.topAnchor.constraint(equalTo: containerView.topAnchor).isActive = true
		dimmingView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor).isActive = true
		dimmingView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor).isActive = true
		dimmingView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor).isActive = true
		
		presentedView.translatesAutoresizingMaskIntoConstraints = false

		switch self.presentationDirection {
			case PresentationDirection.left:
				presentedView.topAnchor.constraint(equalTo: containerView.topAnchor).isActive = true
				presentedView.leftAnchor.constraint(equalTo: containerView.leftAnchor).isActive = true
				presentedView.widthAnchor.constraint(equalTo: containerView.widthAnchor, multiplier: SlideInPresentationController.viewMultiplier).isActive = true
				presentedView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor).isActive = true
			case PresentationDirection.right:
				presentedView.topAnchor.constraint(equalTo: containerView.topAnchor).isActive = true
				presentedView.rightAnchor.constraint(equalTo: containerView.rightAnchor).isActive = true
				presentedView.widthAnchor.constraint(equalTo: containerView.widthAnchor, multiplier: SlideInPresentationController.viewMultiplier).isActive = true
				presentedView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor).isActive = true
			case PresentationDirection.top:
				presentedView.topAnchor.constraint(equalTo: containerView.topAnchor).isActive = true
				presentedView.leftAnchor.constraint(equalTo: containerView.leftAnchor).isActive = true
				presentedView.rightAnchor.constraint(equalTo: containerView.rightAnchor).isActive = true
				presentedView.heightAnchor.constraint(equalTo: containerView.heightAnchor, multiplier: SlideInPresentationController.viewMultiplier).isActive = true
			case PresentationDirection.bottom:
				presentedView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor).isActive = true
				presentedView.leftAnchor.constraint(equalTo: containerView.leftAnchor).isActive = true
				presentedView.rightAnchor.constraint(equalTo: containerView.rightAnchor).isActive = true
				presentedView.heightAnchor.constraint(equalTo: containerView.heightAnchor, multiplier: SlideInPresentationController.viewMultiplier).isActive = true
		}
	}
	
	override func size(forChildContentContainer container: UIContentContainer, withParentContainerSize parentSize: CGSize) -> CGSize {
		switch presentationDirection {
			case .left, .right:
				return CGSize(width: parentSize.width * SlideInPresentationController.viewMultiplier, height: parentSize.height)
			case .bottom, .top:
				return CGSize(width: parentSize.width, height: parentSize.height * SlideInPresentationController.viewMultiplier)
		}
	}

	override var frameOfPresentedViewInContainerView: CGRect {
		var frame: CGRect = .zero
		guard let containerView: UIView = self.containerView else {
			return frame
		}

		frame.size = size(forChildContentContainer: presentedViewController, withParentContainerSize: containerView.bounds.size)

		switch presentationDirection {
			case .right:
				frame.origin.x = containerView.frame.width * SlideInPresentationController.viewMultiplier
			case .bottom:
				frame.origin.y = containerView.frame.height * SlideInPresentationController.viewMultiplier
			default:
				frame.origin = .zero
		}
		return frame
	}
	
	// MARK: Handlers
	func handleTap(recognizer: UITapGestureRecognizer) {
		presentingViewController.dismiss(animated: true)
	}
	
	func handlePan(gesture: UIPanGestureRecognizer) {
		guard let view: UIView = gesture.view, let presentedViewController: MenuViewController = presentedViewController as? MenuViewController else {
			return
		}
		
		let translate = gesture.translation(in: view)
		let percent = -translate.x / view.bounds.size.width
		
		switch gesture.state {
			case UIGestureRecognizerState.began:
				interactionController = UIPercentDrivenInteractiveTransition()
				presentedViewController.customTransitionDelegate.interactionController = interactionController
				
				presentedViewController.dismiss(animated: true)
			case UIGestureRecognizerState.changed:
				interactionController?.update(percent)
			case UIGestureRecognizerState.cancelled:
				fallthrough
			case UIGestureRecognizerState.ended:
				if (percent > 0.60) {
					interactionController?.finish()
				} else {
					interactionController?.cancel()
				}
				interactionController = nil
			default:
				break
		}
	}
}
