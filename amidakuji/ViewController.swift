//
//  ViewController.swift
//  amidakuji
//
//  Created by yrq_mac on 16/5/28.
//  Copyright © 2016年 yrq_mac. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    let XStep:CGFloat = 40
    let YStep:CGFloat = 50
    let TrackSegemetCount:Int = 8
    var btnArray:[(Int,Int)] = []
    var x:Int = 0
    var y:Int = 0
    var initPointArray:[Int] = []
    var x_arr = Array<Int>()
    var y_arr = Array<Int>()
    var trackDic = Array<(Int,Int)>()
    var tipTrack = Dictionary<Int,Array<(Int,Int)>>()
    var isAnimeOver = true
//    var trackDic = Dictionary<Int,Array<(Int,Int)>>()
//    var trackDic = Dictionary<Int,Array<Int>>()
//    var movePointArray = [(1,3),(2,4),(3,3),(3,5),(3,7),(4,6)]
    var movePointArray = [(1,1),(1,3),(2,2),(2,7),(3,1),(4,5),(5,3),(5,6),(6,2),(6,5)]
    
    var hamburgerOpen = true
    var hamburgerButton :UIButton?
    var top:UIView?
    var middle:UIView?
    var bottom:UIView?
//    var btn:ACButton!
    var btn_x:CGFloat = 0
    var btn_y:CGFloat = 0
    var movePositionX = POPSpringAnimation()
    var movePositionY = POPSpringAnimation()
    
    var horiLineView = UIView()
    var lineView = UIView()
    var btnView = UIView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        pop()
//        hamburger()
    
        horiLineView.frame = self.view.frame
        lineView.frame = self.view.frame
        btnView.frame = self.view.frame
        
        let count:Int = 7
        initArrayFromCount(count)
        
        for i in 1...initPointArray.count {

            let btn = ACButton()
            btn.frame = CGRectMake(10+(CGFloat(i)-1)*40, 100, 30, 30)
            btn.tag = i
            btn.addTarget(self, action: #selector(ViewController.startTrackAnimation(_:)), forControlEvents: UIControlEvents.TouchUpInside)
            btn.layer.cornerRadius = btn.frame.size.height/2
            btn.setTitle("\(i)", forState: UIControlState.Normal)
            btn.setTitleColor(.whiteColor(), forState: .Normal)
            btn.backgroundColor = UIColor.blackColor()
            btnView.addSubview(btn)
//            view.insertSubview(btn, atIndex: 2)
            
            let line = UIView(frame:CGRectMake(10,140,10,350))
            line.backgroundColor = UIColor.greenColor()
            line.center.x = btn.center.x
            line.layer.cornerRadius = 3.0
            lineView.addSubview(line)
//            view.insertSubview(line, atIndex: 1)
//            btn_x = btn.frame.origin.x
            btn_x = btn.center.x
//            btn_y = btn.frame.origin.y
            btn_y = btn.center.y
            x = i
            y += 1
//            btn_y += YStep
            
            while y != TrackSegemetCount {
                
                let _x = trackMove(x, y: y)
                if _x > x {
                    
                    let horiLine = UIView(frame:CGRectMake(CGFloat(btn_x),CGFloat(btn_y)+50.0,35,5))
                    horiLine.backgroundColor = UIColor.redColor()
//                    view.insertSubview(horiLine, atIndex: 0)
                    horiLineView.addSubview(horiLine)
                    btn_x += XStep
//                    btn_x = XStep
                }else if _x < x {
                    let horiLine = UIView(frame:CGRectMake(CGFloat(btn_x),CGFloat(btn_y)+50.0,-35,5))
                    horiLine.backgroundColor = UIColor.redColor()
                    horiLineView.addSubview(horiLine)
                    
                    btn_x -= XStep
//                    btn_x = -XStep
                }else{
//                    btn_x = 0
                }

                x = _x
                y += 1
                btn_y += YStep
                print(btn_x,btn_y)
                trackDic.append((Int(btn_x),Int(btn_y)))
//                trackDic.append((Int(btn_x),50))
//                trackDic[i]?.append((x,y))
            }
//            print(btn_x,btn_y)
//            print("end is \(x)")
//            btn.frame = CGRectMake(btn_x,btn_y, 30, 30)
            print("\(i)'s end x is \(x)")
            y = 0
//            print(trackDic)
            tipTrack[i] = trackDic
            trackDic = []
        }
//        print(tipTrack)
        view.addSubview(horiLineView)
        view.addSubview(lineView)
        view.addSubview(btnView)
    }
    
    func startTrackAnimation(sender:UIButton){
        
        let track:[(Int,Int)] = tipTrack[sender.tag]!
//        print("track is \(track)")

//        sender.frame = CGRectMake(10+(CGFloat(sender.tag)-1)*40, 100, 30, 30)
        movePositionY = POPSpringAnimation(propertyNamed: kPOPLayerTranslationY)
        movePositionY.toValue = 50
        movePositionY.springBounciness = 5
        movePositionY.springSpeed = 5
        sender.layer.pop_addAnimation(self.movePositionY, forKey: "movePositionY")
        movePositionY.completionBlock = { (animation, complete) in
            if complete {
                for (x,y) in track {
//                    print(x,y)
                    self.x_arr.append(x)
                    self.y_arr.append(y)
                }
                self.movePostionXAndY(sender)
            }
        }
    }
    
    var i = 0
    func movePostionXAndY(sender:UIButton){
        if i == x_arr.count {

            let scale = POPSpringAnimation(propertyNamed: kPOPViewScaleXY)
            scale.toValue = NSValue(CGPoint:CGPointMake(0.8, 0.8))
            scale.springBounciness = 20
            scale.springSpeed = 5
            sender.pop_addAnimation(scale, forKey: "scale")
            scale.completionBlock = { (animation, complete) in
                if complete {
                    let scale2 = POPSpringAnimation(propertyNamed: kPOPViewScaleXY)
                    scale2.toValue = NSValue(CGPoint:CGPointMake(1.2, 1.2))
                    scale2.springBounciness = 20
                    scale2.springSpeed = 18
                    sender.pop_addAnimation(scale2, forKey: "scale2")
                }
            }
            
//            print("x is \(x_arr)\ny is \(y_arr)")
            i = 0
            x_arr = []
            y_arr = []
            return
        }
        let _x = x_arr[i]
        let _y = y_arr[i]
        
        if isAnimeOver == true {
            isAnimeOver = false
            if _x != 0  {
//                print("moveX_")
                
                let movePositionX = POPSpringAnimation(propertyNamed: kPOPLayerPositionX)
                movePositionX.toValue = _x
                movePositionX.springBounciness = 5
                movePositionX.springSpeed = 5
                sender.layer.pop_addAnimation(movePositionX, forKey: "movePositionX\(i)")
                movePositionX.completionBlock = { (animation, complete) in
                    if complete {
//                        print("move_Y")
                        let movePositionY = POPSpringAnimation(propertyNamed: kPOPLayerPositionY)
                        movePositionY.toValue = _y
                        movePositionY.springBounciness = 5
                        movePositionY.springSpeed = 5
                        sender.layer.pop_addAnimation(movePositionY, forKey: "movePositionY\(self.i)")
                        movePositionY.completionBlock = { (animation, complete) in
                            if complete {
                                self.isAnimeOver = true
                                self.i += 1
                                self.movePostionXAndY(sender)
                            }
                        }
                    }
                }
            }else{
//                print("moveY")
                let movePositionY = POPSpringAnimation(propertyNamed: kPOPLayerPositionY)
                movePositionY.toValue = _y
                movePositionY.springBounciness = 5
                movePositionY.springSpeed = 5
                sender.layer.pop_addAnimation(movePositionY, forKey: "movePositionY\(i)")
                movePositionY.completionBlock = { (animation, complete) in
                    if complete {
                        self.isAnimeOver = true
                        self.i += 1
                        self.movePostionXAndY(sender)
                    }
                }
            }
            
        }

    }
    
    
    func hamburger(){
        hamburgerButton = ACButton()
        hamburgerButton?.backgroundColor = .blackColor()
        hamburgerButton?.frame = CGRectMake(200,150, 150, 150)
        hamburgerButton?.layer.cornerRadius = 75
        view.addSubview(hamburgerButton!)
        hamburgerButton?.addTarget(self, action: #selector(ViewController.didTaphamburgerButton(_:)), forControlEvents: .TouchUpInside)
        
        let sectionWidth:CGFloat = 80.0
        let sectionHeight:CGFloat = 11.0
        top = UIView(frame:CGRectMake(hamburgerButton!.bounds.size.width/2 - sectionWidth/2,40,sectionWidth,sectionHeight))
        top!.backgroundColor = UIColor.whiteColor()
        top!.userInteractionEnabled = false
        top!.layer.cornerRadius = sectionHeight/2
        hamburgerButton?.addSubview(top!)
        
        middle = UIView(frame:CGRectMake(hamburgerButton!.bounds.size.width/2 - sectionWidth/2,69,sectionWidth,sectionHeight))
        middle!.backgroundColor = UIColor.whiteColor()
        middle!.userInteractionEnabled = false
        middle!.layer.cornerRadius = sectionHeight/2
        hamburgerButton?.addSubview(middle!)
        
        bottom = UIView(frame:CGRectMake(hamburgerButton!.bounds.size.width/2 - sectionWidth/2,99,sectionWidth,sectionHeight))
        bottom!.backgroundColor = UIColor.whiteColor()
        bottom!.userInteractionEnabled = false
        bottom!.layer.cornerRadius = sectionHeight/2
        hamburgerButton?.addSubview(bottom!)
        
    
    }
    func didTaphamburgerButton(sender:UIButton){
    
        //color
        var topColor = self.top?.pop_animationForKey("topColor") as! POPSpringAnimation?
        var bottomColor = self.top?.pop_animationForKey("bottomColor") as! POPSpringAnimation?

        //rotate
        var topRotate = self.top?.layer.pop_animationForKey("topRotate") as! POPSpringAnimation?
        var bottomRotate = self.top?.layer.pop_animationForKey("bottomRotate") as! POPSpringAnimation?
        
        
        //position
        var topPosition = self.top?.layer.pop_animationForKey("topPosition") as! POPSpringAnimation?
        var bottomPosition = self.top?.layer.pop_animationForKey("bottomPositon") as! POPSpringAnimation?

        if hamburgerOpen {
            hamburgerOpen = false
            
            UIView.animateWithDuration(0.2, animations: { ()-> Void in
                self.middle!.alpha = 0
            })
            
            if topColor != nil {
                topColor?.toValue = UIColor.redColor()
            }else{
                topColor = POPSpringAnimation(propertyNamed: kPOPViewBackgroundColor)
                topColor?.toValue = UIColor.redColor()
                topColor?.springBounciness = 0
                topColor?.springSpeed = 18
                top?.pop_addAnimation(topColor, forKey: "topColor")
            }
            
            if bottomColor != nil {
                bottomColor?.toValue = UIColor.redColor()
            }else{
                bottomColor = POPSpringAnimation(propertyNamed: kPOPViewBackgroundColor)
                bottomColor?.toValue = UIColor.redColor()
                bottomColor?.springBounciness = 0
                bottomColor?.springSpeed = 18
                bottom?.pop_addAnimation(bottomColor, forKey: "bottomColor")
            }
            
            if topRotate != nil {
                topRotate?.toValue = -M_PI/4
            }else{
                topRotate = POPSpringAnimation(propertyNamed: kPOPLayerRotation)
                topRotate?.toValue = -M_PI/4
                topRotate?.springBounciness = 11
                topRotate?.springSpeed = 18
                top?.layer.pop_addAnimation(topRotate, forKey: "topRotate")
            }
//
            if bottomRotate != nil {
                bottomRotate?.toValue = M_PI/4
            }else{
                bottomRotate = POPSpringAnimation(propertyNamed: kPOPLayerRotation)
                bottomRotate?.toValue = M_PI/4
                bottomRotate?.springBounciness = 11
                bottomRotate?.springSpeed = 18
                bottom?.layer.pop_addAnimation(bottomRotate, forKey: "bottomRotate")
            }
            
            if topPosition != nil {
                topPosition?.toValue = 29
            }else{
                topPosition = POPSpringAnimation(propertyNamed: kPOPLayerTranslationY)
                topPosition?.toValue = 29
                topPosition?.springBounciness = 11
                topPosition?.springSpeed = 18
                top?.layer.pop_addAnimation(topPosition, forKey: "topPosition")
            }
            
            if bottomPosition != nil {
                bottomPosition?.toValue = -29
            }else{
                bottomPosition = POPSpringAnimation(propertyNamed: kPOPLayerTranslationY)
                bottomPosition?.toValue = -29
                bottomPosition?.springBounciness = 11
                bottomPosition?.springSpeed = 18
                bottom?.layer.pop_addAnimation(bottomPosition, forKey: "bottomPosition")
            }
            
        }else{
            
            hamburgerOpen = true
            
            UIView.animateWithDuration(0.2, animations: { ()-> Void in
                self.middle!.alpha = 1
            })
            
            if topColor != nil {
                topColor?.toValue = UIColor.whiteColor()
            }else{
                topColor = POPSpringAnimation(propertyNamed: kPOPViewBackgroundColor)
                topColor?.toValue = UIColor.whiteColor()
                topColor?.springBounciness = 0
                topColor?.springSpeed = 18
                top?.pop_addAnimation(topColor, forKey: "topColor")
            }
            
            if bottomColor != nil {
                bottomColor?.toValue = UIColor.whiteColor()
            }else{
                bottomColor = POPSpringAnimation(propertyNamed: kPOPViewBackgroundColor)
                bottomColor?.toValue = UIColor.whiteColor()
                bottomColor?.springBounciness = 0
                bottomColor?.springSpeed = 18
                bottom?.pop_addAnimation(bottomColor, forKey: "bottomColor")
            }
            
            if topRotate != nil {
                topRotate?.toValue = 0
            }else{
                topRotate = POPSpringAnimation(propertyNamed: kPOPLayerRotation)
                topRotate?.toValue = 0
                topRotate?.springBounciness = 11
                topRotate?.springSpeed = 18
                top?.layer.pop_addAnimation(topRotate, forKey: "topRotate")
            }
            //
            if bottomRotate != nil {
                bottomRotate?.toValue = 0
            }else{
                bottomRotate = POPSpringAnimation(propertyNamed: kPOPLayerRotation)
                bottomRotate?.toValue = 0
                bottomRotate?.springBounciness = 11
                bottomRotate?.springSpeed = 18
                bottom?.layer.pop_addAnimation(bottomRotate, forKey: "bottomRotate")
            }
            
            if topPosition != nil {
                topPosition?.toValue = 0
            }else{
                topPosition = POPSpringAnimation(propertyNamed: kPOPLayerTranslationY)
                topPosition?.toValue = 0
                topPosition?.springBounciness = 11
                topPosition?.springSpeed = 18
                top?.layer.pop_addAnimation(topPosition, forKey: "topPosition")
            }
            
            if bottomPosition != nil {
                bottomPosition?.toValue = 0
            }else{
                bottomPosition = POPSpringAnimation(propertyNamed: kPOPLayerTranslationY)
                bottomPosition?.toValue = 0
                bottomPosition?.springBounciness = 11
                bottomPosition?.springSpeed = 18
                bottom?.layer.pop_addAnimation(bottomPosition, forKey: "bottomPosition")
            }
        
        }
        
    }
    func pop(){
        let redBall = UIView(frame:CGRectMake(100,100,100,100))
        redBall.backgroundColor = UIColor.redColor()
        redBall.layer.cornerRadius = 50
        view.addSubview(redBall)
        
        let scale = POPSpringAnimation(propertyNamed: kPOPViewScaleXY)
        scale.toValue = NSValue(CGPoint:CGPointMake(2, 2))
        scale.springBounciness = 20
        scale.springSpeed = 1
        redBall.pop_addAnimation(scale, forKey: "scale")
    }
    
    func trackMove(x:Int,y:Int) -> Int{
        
        var _x = x
        
        if x == 1 {
            if arrayContains(0){
                _x+=1
            }
        }else if x == movePointArray.count {
            if arrayContains(1){
                _x-=1
            }
        
        }else{
            if arrayContains(1){
                _x-=1
            }else if arrayContains(0){
                _x+=1
            }
        }
//        print("end, x is \(_x)")
        return _x
        
    }
    
    
    func initArrayFromCount(count:Int){
        for i in 1...count {
            initPointArray.append(i)
        }
    }
    
    func arrayContains(offset:Int) -> Bool{
        return movePointArray.contains({ (element) -> Bool in
            let contain = ((element.0+offset == x)&&(element.1 == y)) ? true : false
            return contain
        })
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

