//
//  MenuManager.swift
//  whichever
//
//  Created by Joseph Hooper on 11/16/16.
//  Copyright © 2016 josephdhooper. All rights reserved.
//  MenuTransitionManager: http://mathewsanders.com/interactive-transitions-in-swift/
//

import UIKit

class MenuManager: NSObject, UIViewControllerAnimatedTransitioning, UIViewControllerTransitioningDelegate

{
    fileprivate var presenting = false
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        
        let container = transitionContext.containerView
        
        let screens : (from:UIViewController, to:UIViewController) = (transitionContext.viewController(forKey: UITransitionContextViewControllerKey.from)!, transitionContext.viewController(forKey: UITransitionContextViewControllerKey.to)!)
        
        let menuViewController = !self.presenting ? screens.from as! MenuViewController : screens.to as! MenuViewController
        let bottomViewController = !self.presenting ? screens.to as UIViewController : screens.from as UIViewController
        
        let menuView = menuViewController.view
        let bottomView = bottomViewController.view
        
        
        if (self.presenting){
            menuView?.alpha = 0
        }
        
        container.addSubview(bottomView!)
        container.addSubview(menuView!)
        
        let duration = self.transitionDuration(using: transitionContext)
        
        UIView.animate(withDuration: duration, delay: 0.0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.8, options: [], animations: {
            
            menuView?.alpha = self.presenting ? 1 : 0
            
            }, completion: { finished in
                transitionContext.completeTransition(true)
                UIApplication.shared.keyWindow!.addSubview(screens.to.view)
        })
        
    }
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.5
    }
    
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        self.presenting = true
        return self
    }
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        self.presenting = false
        return self
    }
}
