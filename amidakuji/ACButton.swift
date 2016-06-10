//
//  ACButton.swift
//  amidakuji
//
//  Created by yrq_mac on 16/6/1.
//  Copyright © 2016年 yrq_mac. All rights reserved.
//

import UIKit

class ACButton: UIButton {
    
    var x:Int?
    var y:Int?
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        super.touchesBegan(touches, withEvent: event)
        
        var scale = self.pop_animationForKey("scale") as? POPSpringAnimation
        if scale != nil {
            scale?.toValue = NSValue(CGPoint: CGPointMake(0.8, 0.8))
        }else{
            scale = POPSpringAnimation(propertyNamed: kPOPViewScaleXY)
            scale?.toValue = NSValue(CGPoint:CGPointMake(0.8, 0.8))
            scale?.springBounciness = 20
            scale?.springSpeed = 18
            self.pop_addAnimation(scale, forKey: "scale")
        }
        
        var rotate = self.layer.pop_animationForKey("rotate") as? POPSpringAnimation
        if rotate != nil {
            rotate?.toValue = M_PI/6
        }else{
            rotate = POPSpringAnimation(propertyNamed: kPOPLayerRotation)
            rotate?.toValue = M_PI/6
            rotate?.springBounciness = 20
            rotate?.springSpeed = 18
            self.layer.pop_addAnimation(rotate, forKey: "rotate")
        }
    }
    
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        super.touchesEnded(touches, withEvent: event)
        
        var scale = self.pop_animationForKey("scale") as? POPSpringAnimation
        if scale != nil {
            scale?.toValue = NSValue(CGPoint: CGPointMake(1, 1))
        }else{
            scale = POPSpringAnimation(propertyNamed: kPOPViewScaleXY)
            scale?.toValue = NSValue(CGPoint:CGPointMake(1, 1))
            scale?.springBounciness = 20
            scale?.springSpeed = 18
            self.pop_addAnimation(scale, forKey: "scale")
        }
        
        var rotate = self.layer.pop_animationForKey("rotate") as? POPSpringAnimation
        if rotate != nil {
            rotate?.toValue = 0
        }else{
            rotate = POPSpringAnimation(propertyNamed: kPOPLayerRotation)
            rotate?.toValue = 0
            rotate?.springBounciness = 20
            rotate?.springSpeed = 18
            self.layer.pop_addAnimation(rotate, forKey: "rotate")
        }
        
    }

}
