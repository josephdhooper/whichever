//
//  SegueFromRight.swift
//  whichever
//
//  Created by Joseph Hooper on 11/28/16.
//  Copyright © 2016 josephdhooper. All rights reserved.
//

import UIKit

class SegueFromRight: UIStoryboardSegue {
    
    override func perform()
    {
        let src = self.sourceViewController as UIViewController
        let dst = self.destinationViewController as UIViewController
        
        src.view.superview?.insertSubview(dst.view, aboveSubview: src.view)
        dst.view.transform = CGAffineTransformMakeTranslation(src.view.frame.size.width, 0)
        
        UIView.animateWithDuration(0.25, delay: 0.0, options: UIViewAnimationOptions.CurveEaseInOut, animations: {
            dst.view.transform = CGAffineTransformMakeTranslation(0, 0)
            },
                                   
            completion: { finished in src.presentViewController(dst, animated: false, completion: nil)
                
        })
    }
}

