//
//  HudView.swift
//  WeeklyBudgeting
//
//  Created by silveroak on 7/13/15.
//  Copyright (c) 2015 silveroak. All rights reserved.
//

import UIKit

class HudView: UIView {
    var text = ""
    class func hudInView(view:UIView, animated:Bool) ->HudView {
        let hudView = HudView(frame:view.bounds)
        hudView.opaque = false
        view.addSubview(hudView)
        hudView.showAnimated(animated)
        return hudView
    }
    
    func removeHudView(view:HudView, animated:Bool)  {
        view.removeFromSuperview()
        println("Removed from SuperView")
        view.showAnimated(animated)
    }
    
    override func drawRect(rect: CGRect) {
        let boxWidth: CGFloat = 96
        let boxHeight: CGFloat = 96
        let boxRect = CGRect(
            x: round((bounds.size.width - boxWidth) / 2),
            y: round((bounds.size.height - boxHeight) / 2),
            width: boxWidth,
            height: boxHeight)
        let roundedRect = UIBezierPath(roundedRect: boxRect, cornerRadius: 10)
        UIColor(white: 0.3, alpha: 0.8).setFill()
        roundedRect.fill()
        if let image = UIImage(named:"Checkmark") {
            let imagePoint = CGPoint (
                x:center.x-round(image.size.width/2),
                y:center.y-round(image.size.height/2) - boxHeight/8)
            image.drawAtPoint(imagePoint)
        }
        let attribs = [ NSFontAttributeName: UIFont.systemFontOfSize(16.0), NSForegroundColorAttributeName: UIColor.whiteColor() ]
        let textSize = text.sizeWithAttributes(attribs)
        let textPoint = CGPoint(
            x: center.x - round(textSize.width / 2),
            y: center.y - round(textSize.height / 2) + boxHeight / 4)
        text.drawAtPoint(textPoint, withAttributes: attribs)
    }
    
    func showAnimated(animated: Bool) {
        if animated {
                alpha = 0
                transform = CGAffineTransformMakeScale(1.3, 1.3)
                UIView.animateWithDuration(0.3, animations: {
                self.alpha = 1
                self.transform = CGAffineTransformIdentity
                })
        }
    }
    
    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */

}
