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
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        
        var scale = self.pop_animation(forKey: "scale") as? POPSpringAnimation
        if scale != nil {
            scale?.toValue = NSValue(cgPoint: CGPoint(x: 0.8, y: 0.8))
        }else{
            scale = POPSpringAnimation(propertyNamed: kPOPViewScaleXY)
            scale?.toValue = NSValue(cgPoint:CGPoint(x: 0.8, y: 0.8))
            scale?.springBounciness = 20
            scale?.springSpeed = 18
            self.pop_add(scale, forKey: "scale")
        }
        
        var rotate = self.layer.pop_animation(forKey: "rotate") as? POPSpringAnimation
        if rotate != nil {
            rotate?.toValue = M_PI/6
        }else{
            rotate = POPSpringAnimation(propertyNamed: kPOPLayerRotation)
            rotate?.toValue = M_PI/6
            rotate?.springBounciness = 20
            rotate?.springSpeed = 18
            self.layer.pop_add(rotate, forKey: "rotate")
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        
        var scale = self.pop_animation(forKey: "scale") as? POPSpringAnimation
        if scale != nil {
            scale?.toValue = NSValue(cgPoint: CGPoint(x: 1, y: 1))
        }else{
            scale = POPSpringAnimation(propertyNamed: kPOPViewScaleXY)
            scale?.toValue = NSValue(cgPoint:CGPoint(x: 1, y: 1))
            scale?.springBounciness = 20
            scale?.springSpeed = 18
            self.pop_add(scale, forKey: "scale")
        }
        
        var rotate = self.layer.pop_animation(forKey: "rotate") as? POPSpringAnimation
        if rotate != nil {
            rotate?.toValue = 0
        }else{
            rotate = POPSpringAnimation(propertyNamed: kPOPLayerRotation)
            rotate?.toValue = 0
            rotate?.springBounciness = 20
            rotate?.springSpeed = 18
            self.layer.pop_add(rotate, forKey: "rotate")
        }
        
    }

}
