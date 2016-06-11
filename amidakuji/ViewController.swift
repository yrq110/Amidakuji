//
//  ViewController.swift
//  amidakuji
//
//  Created by yrq_mac on 16/5/28.
//  Copyright © 2016年 yrq_mac. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    let pointSize:CGFloat = 14
    let XStep:CGFloat = 40
    let YStep:CGFloat = 50
    var TrackSegemetCount:Int = 8
    var x:Int = 0
    var y:Int = 0
    var initLineNumber:Int = 0
    var initPointArray:[Int] = []
    var x_arr = Array<Int>()
    var y_arr = Array<Int>()
    var trackDic = Array<(Int,Int)>()
    var tipTrack = Dictionary<Int,Array<(Int,Int)>>()
    var isAnimeOver = true
//    var trackDic = Dictionary<Int,Array<(Int,Int)>>()
    var movePointArray = [(1,3),(2,4),(3,3),(3,5),(3,7),(4,6)]
//    var movePointArray = [(1,1),(1,3),(2,2),(2,7),(3,1),(4,5),(5,3),(5,6),(6,2),(6,5)]
    var turnPointArray = Array<(Int,Int)>()
    var enableAdjusyBool = true
    var hamburgerOpen = true
    var calculateTrackButton = ACButton()
    var enableAdjustButton = ACButton()
    var hamburgerButton = ACButton()
    var addTrackButton = ACButton()
    var addSegmentButton = ACButton()
    var clearButton = ACButton()
    var changeModeButton = UIButton()
    var top:UIView?
    var middle:UIView?
    var bottom:UIView?
    var btn_x_array = Array<CGFloat>()
    var btn_x:CGFloat = 0
    var btn_y:CGFloat = 115
    var movePositionX = POPSpringAnimation()
    var movePositionY = POPSpringAnimation()
    
    var horiLineView = UIView()
    var lineView = UIView()
    var btnView = UIView()
    var exampleBackView = UIView()
    
    var customTrackCount:Int = 0
    var customBtnView = UIView()
    var customTrackView = UIView()
    var customBackView = UIView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        customBtnView.frame = self.view.frame
        customTrackView.frame = self.view.frame
        customBackView.frame = self.view.frame
        
        horiLineView.frame = self.view.frame
        lineView.frame = self.view.frame
        btnView.frame = self.view.frame
        exampleBackView.frame = self.view.frame
        
        let count:Int = 5
        initLineNumber = 5
        initArrayFromCount(count)
        
        customTrackCount = count
        for i in 1...customTrackCount {
            
            let btn = ACButton()
            btn.tag = i
            btn.frame = CGRectMake(45+(CGFloat(i)-1)*40, 100, 30, 30)
            btn.addTarget(self, action: #selector(ViewController.startTrackAnimation(_:)), forControlEvents: UIControlEvents.TouchUpInside)
            btn.layer.cornerRadius = btn.frame.size.height/2
            btn.setTitle("\(i)", forState: UIControlState.Normal)
            btn.setTitleColor(.whiteColor(), forState: .Normal)
            btn.backgroundColor = UIColor.blackColor()
            customBtnView.addSubview(btn)
            
            
            let line = UIView(frame:CGRectMake(55+(CGFloat(i)-1)*XStep,140,10,350))
            line.backgroundColor = UIColor.greenColor()
            line.layer.cornerRadius = 3.0
            customTrackView.addSubview(line)
            
            self.addPoint(self.TrackSegemetCount, line: line, view: self.customBtnView,lineNumber: i)
            btn_x_array.append(btn.center.x)
            
        }
        print(btn_x_array)
        
        customBackView.addSubview(customTrackView)
        customBackView.addSubview(customBtnView)
        
        addTrackButton.backgroundColor = UIColor.redColor()
        addTrackButton.titleLabel?.font = UIFont.boldSystemFontOfSize(30.0)
        addTrackButton.setTitle("+", forState: UIControlState.Normal)
        addTrackButton.frame = CGRectMake(45+CGFloat(customTrackCount)*40, 140, 30, 30)
        addTrackButton.addTarget(self, action: #selector(ViewController.addTrackLine(_:)), forControlEvents: .TouchUpInside)
        addTrackButton.layer.cornerRadius = 30/2
        customBackView.addSubview(addTrackButton)
        
        addSegmentButton.backgroundColor = UIColor.redColor()
        addSegmentButton.titleLabel?.font = UIFont.boldSystemFontOfSize(30.0)
        addSegmentButton.setTitle("+", forState: UIControlState.Normal)
        addSegmentButton.frame = CGRectMake(45, 115+CGFloat(TrackSegemetCount)*50, 30, 30)
        addSegmentButton.addTarget(self, action: #selector(ViewController.addSegment(_:)), forControlEvents: .TouchUpInside)
        addSegmentButton.layer.cornerRadius = 30/2
        customBackView.addSubview(addSegmentButton)
        
        clearButton.backgroundColor = UIColor.brownColor()
        clearButton.setTitle("Clear", forState: UIControlState.Normal)
        clearButton.frame = CGRectMake(20,600, 50, 30)
        clearButton.center.x = view.center.x
        clearButton.addTarget(self, action: #selector(ViewController.clearGround(_:)), forControlEvents: .TouchUpInside)
        clearButton.layer.cornerRadius = 10
//        customBackView.addSubview(clearButton)
        
        calculateTrackButton.backgroundColor = UIColor.brownColor()
        calculateTrackButton.setTitle("Calculate", forState: UIControlState.Normal)
        calculateTrackButton.frame = CGRectMake(20,50, 80, 30)
        calculateTrackButton.addTarget(self, action: #selector(ViewController.calculateTrack(_:)), forControlEvents: .TouchUpInside)
        calculateTrackButton.layer.cornerRadius = 10
        customBackView.addSubview(calculateTrackButton)
        
        enableAdjustButton.backgroundColor = UIColor.brownColor()
        enableAdjustButton.setTitle("Adjust", forState: UIControlState.Normal)
        enableAdjustButton.frame = CGRectMake(300,50, 60, 30)
        enableAdjustButton.addTarget(self, action: #selector(ViewController.enableAdjust(_:)), forControlEvents: .TouchUpInside)
        enableAdjustButton.layer.cornerRadius = 10
        customBackView.addSubview(enableAdjustButton)
        view.addSubview(customBackView)
//        customBackView.userInteractionEnabled = false
//        customBackView.hidden = true
        

        hamburger(CGRectMake(170,40, 50, 50),view: view)
        hamburgerButton.center.x = self.view.center.x
        
        
        changeModeButton = UIButton(type:.Custom)
        changeModeButton.setTitle("Mode B", forState: UIControlState.Normal)
        changeModeButton.frame = CGRectMake(0, 0, 200, 60)
        changeModeButton.center = CGPointMake(view.center.x, view.frame.size.height-40)
        changeModeButton.backgroundColor = UIColor.redColor()
        changeModeButton.addTarget(self, action: #selector(ViewController.goToReverseVC(_:)), forControlEvents: UIControlEvents.TouchUpInside)
        view.addSubview(changeModeButton)
        
    }
    
    func goToReverseVC(sender:UIButton){
        let reVC = ReverseViewController()
        self.presentViewController(reVC, animated: true, completion: nil)
    }
    
    func clearGround(sender:UIButton){
        TrackSegemetCount = 8
        for i in view.subviews {
            if (i.backgroundColor == UIColor.redColor()) && i.isKindOfClass(UIView) {
                i.removeFromSuperview()
            }
        }
    }
    
    func calculateTrack(sender:UIButton){

        for i in 1...customTrackCount {
            
            btn_x = btn_x_array[i-1]
            btn_y = 115
            x = i
            y += 1
            
            while y != TrackSegemetCount {
                
                let _x = trackMove(x, y: y)
                if _x > x {
                    
                    btn_x += XStep
                    
                }else if _x < x {
                    
                    btn_x -= XStep
                }
                
                x = _x
                y += 1
                btn_y += YStep
                trackDic.append((Int(btn_x),Int(btn_y)))
            }
            y = 0
            tipTrack[i] = trackDic
            trackDic = []
        }
        
        print(tipTrack)
        sender.enabled = false
    }
    
    func tapPoint(sender:UIButton){
        let a = sender.tag
        let aa = a/100
        let bb = a%100
//        print("tapPoint")
        let horiLine = UIView()
        horiLine.frame.size = CGSizeMake(35, 5)
        horiLine.frame.origin = CGPointMake(sender.center.x, sender.center.y)
        horiLine.center.y = sender.center.y
        horiLine.backgroundColor = UIColor.redColor()
        customTrackView.addSubview(horiLine)
        
        turnPointArray.append((aa,bb))
        print(turnPointArray)
        sender.enabled = false
        let new_tag = (aa+1)*100+bb
        for i in customBtnView.subviews {
//            print(i)
            if i.tag == new_tag && i.isKindOfClass(UIButton) {
                let btn:UIButton = customBtnView.viewWithTag(new_tag) as! UIButton
                btn.enabled = false
            }
        }
    }
    
    func addTrackLine(sender:UIButton){
        
        customTrackCount += 1
        
        let x = self.addTrackButton.center.x + XStep
        
        let moveX = POPSpringAnimation(propertyNamed: kPOPLayerPositionX)
        moveX.toValue = x
        moveX.springBounciness = 5
        moveX.springSpeed = 5
        sender.layer.pop_addAnimation(moveX, forKey: "moveX")
        moveX.completionBlock = { (animation, complete) in
            if complete {
                
                let btn = ACButton()
                btn.frame = CGRectMake(45+(CGFloat(self.customTrackCount)-1)*40, 100, 30, 30)
                btn.tag = self.customTrackCount
                self.btn_x_array.append(btn.center.x)
                btn.layer.cornerRadius = btn.frame.size.height/2
                btn.addTarget(self, action: #selector(ViewController.startTrackAnimation(_:)), forControlEvents: UIControlEvents.TouchUpInside)
                btn.setTitle("\(self.customTrackCount)", forState: UIControlState.Normal)
                btn.setTitleColor(.whiteColor(), forState: .Normal)
                btn.backgroundColor = UIColor.blackColor()
                self.customBtnView.addSubview(btn)
                
                let line = UIView(frame:CGRectMake(55+(CGFloat(self.customTrackCount)-1)*self.XStep,140,10,50*CGFloat(self.TrackSegemetCount-1)))
                line.backgroundColor = UIColor.greenColor()
                line.layer.cornerRadius = 3.0
                self.customTrackView.addSubview(line)

                self.enableLastTrackPoint(self.TrackSegemetCount, view: self.customBtnView, lineNumber: self.customTrackCount-1)
                self.addPoint(self.TrackSegemetCount, line: line, view: self.customBtnView,lineNumber: self.customTrackCount)
            }
        }
    }
    
    func addSegment(sender:UIButton){
        
        TrackSegemetCount += 1
        
        let y = self.addSegmentButton.center.y + YStep
        let moveY = POPSpringAnimation(propertyNamed: kPOPLayerPositionY)
        moveY.toValue = y
        moveY.springBounciness = 5
        moveY.springSpeed = 5
        sender.layer.pop_addAnimation(moveY, forKey: "moveY")
        moveY.completionBlock = { (animation, complete) in
            if complete {
                var lineNo = 0
                for i in self.customTrackView.subviews {
                    if i.backgroundColor == UIColor.greenColor(){
//                        print("addSegment")
                        i.frame.size.height += self.YStep
                        lineNo += 1
                        let circle = ACButton()
                        if lineNo == self.customTrackCount {
                            circle.enabled = false
                        }
                        circle.tag = lineNo*100 + self.TrackSegemetCount - 1
                        circle.frame.size = CGSizeMake(self.pointSize, self.pointSize)
                        circle.layer.cornerRadius = self.pointSize/2
                        (circle.center.x,circle.center.y) = (i.center.x,115+CGFloat(self.TrackSegemetCount-1)*self.self.YStep)
                        circle.backgroundColor = UIColor.redColor()
                        circle.addTarget(self, action: #selector(ViewController.tapPoint(_:)), forControlEvents: UIControlEvents.TouchUpInside)
                        self.customBtnView.addSubview(circle)
                    }
                }
            }
        }
        
    }
    
    func enableLastTrackPoint(count:Int,view:UIView,lineNumber:Int){
        for i in 1...count {
            let new_tag = (lineNumber)*100+i
            print(new_tag)
            for j in view.subviews {
                if j.tag == new_tag && j.isKindOfClass(UIButton) {
                    let btn:UIButton = view.viewWithTag(new_tag) as! UIButton
                    btn.enabled = true
                    print("cool")
                }
            }
        }
    }
    
    func addPoint(count:Int,line:UIView,view:UIView,lineNumber:Int){
        
        for i in 1...count-1 {
            let circle = ACButton()
            circle.tag = lineNumber*100 + i
            if lineNumber == customTrackCount {
                circle.enabled = false
            }
//            print(circle.tag)
            circle.frame.size = CGSizeMake(pointSize, pointSize)
            circle.layer.cornerRadius = pointSize/2
            (circle.center.x,circle.center.y) = (line.center.x,115+CGFloat(i)*self.YStep)
            circle.backgroundColor = UIColor.redColor()
            circle.addTarget(self, action: #selector(ViewController.tapPoint(_:)), forControlEvents: UIControlEvents.TouchUpInside)
            view.addSubview(circle)
        }
    
    }
    
    func enableAdjust(sender:UIButton){
        if enableAdjusyBool == false {
            enableAdjusyBool = true
            addTrackButton.hidden = false
            addSegmentButton.hidden = false
        }else{
            enableAdjusyBool = false
            addTrackButton.hidden = true
            addSegmentButton.hidden = true
        }
    }
    
    func startTrackAnimation(sender:UIButton){
        
        var x_arr = Array<Int>()
        var y_arr = Array<Int>()
        
        let track:[(Int,Int)] = tipTrack[sender.tag]!
//        print("track is \(track)")
        let movePositionY = POPSpringAnimation(propertyNamed: kPOPLayerTranslationY)
        movePositionY.toValue = 50
        movePositionY.springBounciness = 5
        movePositionY.springSpeed = 5
        sender.layer.pop_addAnimation(movePositionY, forKey: "movePositionY\(sender.tag)")
        movePositionY.completionBlock = { (animation, complete) in
            if complete {
                print("first Y is \(sender.tag)")
                for (x,y) in track {
                    x_arr.append(x)
                    y_arr.append(y)
                }
                self.movePostionXAndY(sender, x_arr: x_arr, y_arr: y_arr,i: 0)
            }
        }
    }
    
//    var i = 0
    func movePostionXAndY(sender:UIButton,x_arr:Array<Int>,y_arr:Array<Int>,i:Int){
        
        print("Into move is \(sender.tag)")

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
//            i = 0
            return
        }
        let _x = x_arr[i]
        let _y = y_arr[i]
        
        if _x != 0  {
//                print("moveX_")
            
            let movePositionX = POPSpringAnimation(propertyNamed: kPOPLayerPositionX)
            movePositionX.toValue = _x
            movePositionX.springBounciness = 5
            movePositionX.springSpeed = 5
            sender.layer.pop_addAnimation(movePositionX, forKey: "movePositionX\(i)+\(sender.tag)")
            movePositionX.completionBlock = { (animation, complete) in
                if complete {
//                        print("move_Y")
                    let movePositionY = POPSpringAnimation(propertyNamed: kPOPLayerPositionY)
                    movePositionY.toValue = _y
                    movePositionY.springBounciness = 5
                    movePositionY.springSpeed = 5
                    sender.layer.pop_addAnimation(movePositionY, forKey: "movePositionY\(i)+\(sender.tag)")
                    movePositionY.completionBlock = { (animation, complete) in
                        if complete {
                            self.isAnimeOver = true
//                                i += 1
                            self.movePostionXAndY(sender, x_arr: x_arr, y_arr: y_arr,i: i+1)
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
            sender.layer.pop_addAnimation(movePositionY, forKey: "movePositionY\(i)+\(sender.tag)")
            movePositionY.completionBlock = { (animation, complete) in
                if complete {
                    self.isAnimeOver = true
//                        i += 1
                    self.movePostionXAndY(sender, x_arr: x_arr, y_arr: y_arr,i: i+1)
                }
            }
        }
            
        

    }
    
//    func hamburger(){
    func hamburger(frame:CGRect,view:UIView){
        hamburgerButton.backgroundColor = .blackColor()
        hamburgerButton.frame = frame
        
        view.addSubview(hamburgerButton)
        hamburgerButton.addTarget(self, action: #selector(ViewController.didTaphamburgerButton(_:)), forControlEvents: .TouchUpInside)
        
        let width = hamburgerButton.bounds.size.width
        let height = hamburgerButton.bounds.size.height
        hamburgerButton.tag = Int(height)
        hamburgerButton.layer.cornerRadius = height/2
        let sectionWidth:CGFloat = width*0.5
        let sectionHeight:CGFloat = height*0.07
        top = UIView(frame:CGRectMake(width/2 - sectionWidth/2,height*0.27,sectionWidth,sectionHeight))
        top!.backgroundColor = UIColor.whiteColor()
        top!.userInteractionEnabled = false
        top!.layer.cornerRadius = sectionHeight/2
        hamburgerButton.addSubview(top!)
        
        middle = UIView(frame:CGRectMake(width/2 - sectionWidth/2,height*0.46,sectionWidth,sectionHeight))
        middle!.backgroundColor = UIColor.whiteColor()
        middle!.userInteractionEnabled = false
        middle!.layer.cornerRadius = sectionHeight/2
        hamburgerButton.addSubview(middle!)
        
        bottom = UIView(frame:CGRectMake(width/2 - sectionWidth/2,height*0.66,sectionWidth,sectionHeight))
        bottom!.backgroundColor = UIColor.whiteColor()
        bottom!.userInteractionEnabled = false
        bottom!.layer.cornerRadius = sectionHeight/2
        hamburgerButton.addSubview(bottom!)
        
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
            
            
            for i in customBtnView.subviews {
                if i.tag < customTrackCount+1 {
                    let btn:UIButton = i as! UIButton
                    
                    let thread = NSThread(target:self, selector:#selector(ViewController.startTrackAnimation(_:)),object:btn)
                    thread.name = "btnThread\(i.tag)"
                    thread.start()
                    
//                    thread.name=[NSString stringWithFormat:@"myThread%i",i];//设置线程名称
//                    [thread start];
                    
//                    dispatch_async(dispatch_get_global_queue(0, 0), {
//                        self.startTrackAnimation(btn)
//                    
//                    })
//                    dispatch_async(dispatch_get_main_queue(), {
//                        self.startTrackAnimation(btn)
//                    })
//                    
                
                }
            }
            
//            exampleBackView.hidden = true
//            customBackView.hidden = true
            
//            exampleBackView.userInteractionEnabled = false
//            customBackView.userInteractionEnabled = false

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
                topPosition?.toValue = CGFloat(sender.tag)*0.2
            }else{
                topPosition = POPSpringAnimation(propertyNamed: kPOPLayerTranslationY)
                topPosition?.toValue = CGFloat(sender.tag)*0.2
                topPosition?.springBounciness = 11
                topPosition?.springSpeed = 18
                top?.layer.pop_addAnimation(topPosition, forKey: "topPosition")
            }
            
            if bottomPosition != nil {
                bottomPosition?.toValue = -CGFloat(sender.tag)*0.2
            }else{
                bottomPosition = POPSpringAnimation(propertyNamed: kPOPLayerTranslationY)
                bottomPosition?.toValue = -CGFloat(sender.tag)*0.2
                bottomPosition?.springBounciness = 11
                bottomPosition?.springSpeed = 18
                bottom?.layer.pop_addAnimation(bottomPosition, forKey: "bottomPosition")
            }
            
        }else{
            
//            exampleBackView.hidden = false
//            customBackView.hidden = false
//            exampleBackView.userInteractionEnabled = true
//            customBackView.userInteractionEnabled = true

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
    
    func trackMove(x:Int,y:Int) -> Int{
        
        var _x = x
        
        if x == 1 {
            if arrayContains(0){
                _x+=1
            }
        }else if x == turnPointArray.count {
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
        return turnPointArray.contains({ (element) -> Bool in
            let contain = ((element.0+offset == x)&&(element.1 == y)) ? true : false   
            return contain
        })
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

