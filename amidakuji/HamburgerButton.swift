//
//  HamburgerButton.swift
//  amidakuji
//
//  Created by yrq_mac on 16/6/5.
//  Copyright © 2016年 yrq_mac. All rights reserved.
//

import UIKit

class HamburgerButton: ACButton {
    
    var top:UIView!
    var middle:UIView!
    var bottom:UIView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        let width = self.bounds.size.width
        let height = self.bounds.size.height
        self.tag = Int(height)
        self.layer.cornerRadius = height/2
        let sectionWidth:CGFloat = width*0.5
        let sectionHeight:CGFloat = height*0.07
        top = UIView(frame:CGRect(x: width/2 - sectionWidth/2,y: height*0.27,width: sectionWidth,height: sectionHeight))
        top.backgroundColor = UIColor.white
        top.isUserInteractionEnabled = false
        top.layer.cornerRadius = sectionHeight/2
        self.addSubview(top)
        
        middle = UIView(frame:CGRect(x: width/2 - sectionWidth/2,y: height*0.46,width: sectionWidth,height: sectionHeight))
        middle.backgroundColor = UIColor.white
        middle.isUserInteractionEnabled = false
        middle.layer.cornerRadius = sectionHeight/2
        self.addSubview(middle)
        
        bottom = UIView(frame:CGRect(x: width/2 - sectionWidth/2,y: height*0.66,width: sectionWidth,height: sectionHeight))
        bottom.backgroundColor = UIColor.white
        bottom.isUserInteractionEnabled = false
        bottom.layer.cornerRadius = sectionHeight/2
        self.addSubview(bottom)
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        
        
        
        
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
