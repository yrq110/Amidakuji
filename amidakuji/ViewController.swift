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
            btn.frame = CGRect(x: 45+(CGFloat(i)-1)*40, y: 100, width: 30, height: 30)
            btn.addTarget(self, action: #selector(ViewController.startTrackAnimation(_:)), for: UIControlEvents.touchUpInside)
            btn.layer.cornerRadius = btn.frame.size.height/2
            btn.setTitle("\(i)", for: UIControlState())
            btn.setTitleColor(.white, for: UIControlState())
            btn.backgroundColor = UIColor.black
            customBtnView.addSubview(btn)
            
            
            let line = UIView(frame:CGRect(x: 55+(CGFloat(i)-1)*XStep,y: 140,width: 10,height: 350))
            line.backgroundColor = UIColor.green
            line.layer.cornerRadius = 3.0
            customTrackView.addSubview(line)
            
            self.addPoint(self.TrackSegemetCount, line: line, view: self.customBtnView,lineNumber: i)
            btn_x_array.append(btn.center.x)
            
        }
        print(btn_x_array)
        
        customBackView.addSubview(customTrackView)
        customBackView.addSubview(customBtnView)
        
        addTrackButton.backgroundColor = UIColor.red
        addTrackButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 30.0)
        addTrackButton.setTitle("+", for: UIControlState())
        addTrackButton.frame = CGRect(x: 45+CGFloat(customTrackCount)*40, y: 140, width: 30, height: 30)
        addTrackButton.addTarget(self, action: #selector(ViewController.addTrackLine(_:)), for: .touchUpInside)
        addTrackButton.layer.cornerRadius = 30/2
        customBackView.addSubview(addTrackButton)
        
        addSegmentButton.backgroundColor = UIColor.red
        addSegmentButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 30.0)
        addSegmentButton.setTitle("+", for: UIControlState())
        addSegmentButton.frame = CGRect(x: 45, y: 115+CGFloat(TrackSegemetCount)*50, width: 30, height: 30)
        addSegmentButton.addTarget(self, action: #selector(ViewController.addSegment(_:)), for: .touchUpInside)
        addSegmentButton.layer.cornerRadius = 30/2
        customBackView.addSubview(addSegmentButton)
        
        clearButton.backgroundColor = UIColor.brown
        clearButton.setTitle("Clear", for: UIControlState())
        clearButton.frame = CGRect(x: 20,y: 600, width: 50, height: 30)
        clearButton.center.x = view.center.x
        clearButton.addTarget(self, action: #selector(ViewController.clearGround(_:)), for: .touchUpInside)
        clearButton.layer.cornerRadius = 10
//        customBackView.addSubview(clearButton)
        
        calculateTrackButton.backgroundColor = UIColor.brown
        calculateTrackButton.setTitle("Calculate", for: UIControlState())
        calculateTrackButton.frame = CGRect(x: 20,y: 50, width: 80, height: 30)
        calculateTrackButton.addTarget(self, action: #selector(ViewController.calculateTrack(_:)), for: .touchUpInside)
        calculateTrackButton.layer.cornerRadius = 10
        customBackView.addSubview(calculateTrackButton)
        
        enableAdjustButton.backgroundColor = UIColor.brown
        enableAdjustButton.setTitle("Adjust", for: UIControlState())
        enableAdjustButton.frame = CGRect(x: 300,y: 50, width: 60, height: 30)
        enableAdjustButton.addTarget(self, action: #selector(ViewController.enableAdjust(_:)), for: .touchUpInside)
        enableAdjustButton.layer.cornerRadius = 10
        customBackView.addSubview(enableAdjustButton)
        view.addSubview(customBackView)
//        customBackView.userInteractionEnabled = false
//        customBackView.hidden = true
        

        hamburger(CGRect(x: 170,y: 40, width: 50, height: 50),view: view)
        hamburgerButton.center.x = self.view.center.x
        
        
        changeModeButton = UIButton(type:.custom)
        changeModeButton.setTitle("Mode B", for: UIControlState())
        changeModeButton.frame = CGRect(x: 0, y: 0, width: 200, height: 60)
        changeModeButton.center = CGPoint(x: view.center.x, y: view.frame.size.height-40)
        changeModeButton.backgroundColor = UIColor.red
        changeModeButton.addTarget(self, action: #selector(ViewController.goToReverseVC(_:)), for: UIControlEvents.touchUpInside)
        view.addSubview(changeModeButton)
        
    }
    
    func goToReverseVC(_ sender:UIButton){
        let reVC = ReverseViewController()
        self.present(reVC, animated: true, completion: nil)
    }
    
    func clearGround(_ sender:UIButton){
        TrackSegemetCount = 8
        for i in view.subviews {
            if (i.backgroundColor == UIColor.red) && i.isKind(of: UIView.self) {
                i.removeFromSuperview()
            }
        }
    }
    
    func calculateTrack(_ sender:UIButton){

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
        sender.isEnabled = false
    }
    
    func tapPoint(_ sender:UIButton){
        let a = sender.tag
        let aa = a/100
        let bb = a%100
//        print("tapPoint")
        let horiLine = UIView()
        horiLine.frame.size = CGSize(width: 35, height: 5)
        horiLine.frame.origin = CGPoint(x: sender.center.x, y: sender.center.y)
        horiLine.center.y = sender.center.y
        horiLine.backgroundColor = UIColor.red
        customTrackView.addSubview(horiLine)
        
        turnPointArray.append((aa,bb))
        print(turnPointArray)
        sender.isEnabled = false
        let new_tag = (aa+1)*100+bb
        for i in customBtnView.subviews {
//            print(i)
            if i.tag == new_tag && i.isKind(of: UIButton.self) {
                let btn:UIButton = customBtnView.viewWithTag(new_tag) as! UIButton
                btn.isEnabled = false
            }
        }
    }
    
    func addTrackLine(_ sender:UIButton){
        
        customTrackCount += 1
        
        let x = self.addTrackButton.center.x + XStep
        
        let moveX = POPSpringAnimation(propertyNamed: kPOPLayerPositionX)
        moveX?.toValue = x
        moveX?.springBounciness = 5
        moveX?.springSpeed = 5
        sender.layer.pop_add(moveX, forKey: "moveX")
        moveX?.completionBlock = { (animation, complete) in
            if complete {
                
                let btn = ACButton()
                btn.frame = CGRect(x: 45+(CGFloat(self.customTrackCount)-1)*40, y: 100, width: 30, height: 30)
                btn.tag = self.customTrackCount
                self.btn_x_array.append(btn.center.x)
                btn.layer.cornerRadius = btn.frame.size.height/2
                btn.addTarget(self, action: #selector(ViewController.startTrackAnimation(_:)), for: UIControlEvents.touchUpInside)
                btn.setTitle("\(self.customTrackCount)", for: UIControlState())
                btn.setTitleColor(.white, for: UIControlState())
                btn.backgroundColor = UIColor.black
                self.customBtnView.addSubview(btn)
                
                let line = UIView(frame:CGRect(x: 55+(CGFloat(self.customTrackCount)-1)*self.XStep,y: 140,width: 10,height: 50*CGFloat(self.TrackSegemetCount-1)))
                line.backgroundColor = UIColor.green
                line.layer.cornerRadius = 3.0
                self.customTrackView.addSubview(line)

                self.enableLastTrackPoint(self.TrackSegemetCount, view: self.customBtnView, lineNumber: self.customTrackCount-1)
                self.addPoint(self.TrackSegemetCount, line: line, view: self.customBtnView,lineNumber: self.customTrackCount)
            }
        }
    }
    
    func addSegment(_ sender:UIButton){
        
        TrackSegemetCount += 1
        
        let y = self.addSegmentButton.center.y + YStep
        let moveY = POPSpringAnimation(propertyNamed: kPOPLayerPositionY)
        moveY?.toValue = y
        moveY?.springBounciness = 5
        moveY?.springSpeed = 5
        sender.layer.pop_add(moveY, forKey: "moveY")
        moveY?.completionBlock = { (animation, complete) in
            if complete {
                var lineNo = 0
                for i in self.customTrackView.subviews {
                    if i.backgroundColor == UIColor.green{
//                        print("addSegment")
                        i.frame.size.height += self.YStep
                        lineNo += 1
                        let circle = ACButton()
                        if lineNo == self.customTrackCount {
                            circle.isEnabled = false
                        }
                        circle.tag = lineNo*100 + self.TrackSegemetCount - 1
                        circle.frame.size = CGSize(width: self.pointSize, height: self.pointSize)
                        circle.layer.cornerRadius = self.pointSize/2
                        (circle.center.x,circle.center.y) = (i.center.x,115+CGFloat(self.TrackSegemetCount-1)*self.self.YStep)
                        circle.backgroundColor = UIColor.red
                        circle.addTarget(self, action: #selector(ViewController.tapPoint(_:)), for: UIControlEvents.touchUpInside)
                        self.customBtnView.addSubview(circle)
                    }
                }
            }
        }
        
    }
    
    func enableLastTrackPoint(_ count:Int,view:UIView,lineNumber:Int){
        for i in 1...count {
            let new_tag = (lineNumber)*100+i
            print(new_tag)
            for j in view.subviews {
                if j.tag == new_tag && j.isKind(of: UIButton.self) {
                    let btn:UIButton = view.viewWithTag(new_tag) as! UIButton
                    btn.isEnabled = true
                    print("cool")
                }
            }
        }
    }
    
    func addPoint(_ count:Int,line:UIView,view:UIView,lineNumber:Int){
        
        for i in 1...count-1 {
            let circle = ACButton()
            circle.tag = lineNumber*100 + i
            if lineNumber == customTrackCount {
                circle.isEnabled = false
            }
//            print(circle.tag)
            circle.frame.size = CGSize(width: pointSize, height: pointSize)
            circle.layer.cornerRadius = pointSize/2
            (circle.center.x,circle.center.y) = (line.center.x,115+CGFloat(i)*self.YStep)
            circle.backgroundColor = UIColor.red
            circle.addTarget(self, action: #selector(ViewController.tapPoint(_:)), for: UIControlEvents.touchUpInside)
            view.addSubview(circle)
        }
    
    }
    
    func enableAdjust(_ sender:UIButton){
        if enableAdjusyBool == false {
            enableAdjusyBool = true
            addTrackButton.isHidden = false
            addSegmentButton.isHidden = false
        }else{
            enableAdjusyBool = false
            addTrackButton.isHidden = true
            addSegmentButton.isHidden = true
        }
    }
    
    func startTrackAnimation(_ sender:UIButton){
        
        var x_arr = Array<Int>()
        var y_arr = Array<Int>()
        
        let track:[(Int,Int)] = tipTrack[sender.tag]!
//        print("track is \(track)")
        let movePositionY = POPSpringAnimation(propertyNamed: kPOPLayerTranslationY)
        movePositionY?.toValue = 50
        movePositionY?.springBounciness = 5
        movePositionY?.springSpeed = 5
        sender.layer.pop_add(movePositionY, forKey: "movePositionY\(sender.tag)")
        movePositionY?.completionBlock = { (animation, complete) in
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
    func movePostionXAndY(_ sender:UIButton,x_arr:Array<Int>,y_arr:Array<Int>,i:Int){
        
        print("Into move is \(sender.tag)")

        if i == x_arr.count {

            let scale = POPSpringAnimation(propertyNamed: kPOPViewScaleXY)
            scale?.toValue = NSValue(cgPoint:CGPoint(x: 0.8, y: 0.8))
            scale?.springBounciness = 20
            scale?.springSpeed = 5
            sender.pop_add(scale, forKey: "scale")
            scale?.completionBlock = { (animation, complete) in
                if complete {
                    let scale2 = POPSpringAnimation(propertyNamed: kPOPViewScaleXY)
                    scale2?.toValue = NSValue(cgPoint:CGPoint(x: 1.2, y: 1.2))
                    scale2?.springBounciness = 20
                    scale2?.springSpeed = 18
                    sender.pop_add(scale2, forKey: "scale2")
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
            movePositionX?.toValue = _x
            movePositionX?.springBounciness = 5
            movePositionX?.springSpeed = 5
            sender.layer.pop_add(movePositionX, forKey: "movePositionX\(i)+\(sender.tag)")
            movePositionX?.completionBlock = { (animation, complete) in
                if complete {
//                        print("move_Y")
                    let movePositionY = POPSpringAnimation(propertyNamed: kPOPLayerPositionY)
                    movePositionY?.toValue = _y
                    movePositionY?.springBounciness = 5
                    movePositionY?.springSpeed = 5
                    sender.layer.pop_add(movePositionY, forKey: "movePositionY\(i)+\(sender.tag)")
                    movePositionY?.completionBlock = { (animation, complete) in
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
            movePositionY?.toValue = _y
            movePositionY?.springBounciness = 5
            movePositionY?.springSpeed = 5
            sender.layer.pop_add(movePositionY, forKey: "movePositionY\(i)+\(sender.tag)")
            movePositionY?.completionBlock = { (animation, complete) in
                if complete {
                    self.isAnimeOver = true
//                        i += 1
                    self.movePostionXAndY(sender, x_arr: x_arr, y_arr: y_arr,i: i+1)
                }
            }
        }
            
        

    }
    
//    func hamburger(){
    func hamburger(_ frame:CGRect,view:UIView){
        hamburgerButton.backgroundColor = UIColor.black
        hamburgerButton.frame = frame
        
        view.addSubview(hamburgerButton)
        hamburgerButton.addTarget(self, action: #selector(ViewController.didTaphamburgerButton(_:)), for: .touchUpInside)
        
        let width = hamburgerButton.bounds.size.width
        let height = hamburgerButton.bounds.size.height
        hamburgerButton.tag = Int(height)
        hamburgerButton.layer.cornerRadius = height/2
        let sectionWidth:CGFloat = width*0.5
        let sectionHeight:CGFloat = height*0.07
        top = UIView(frame:CGRect(x: width/2 - sectionWidth/2,y: height*0.27,width: sectionWidth,height: sectionHeight))
        top!.backgroundColor = UIColor.white
        top!.isUserInteractionEnabled = false
        top!.layer.cornerRadius = sectionHeight/2
        hamburgerButton.addSubview(top!)
        
        middle = UIView(frame:CGRect(x: width/2 - sectionWidth/2,y: height*0.46,width: sectionWidth,height: sectionHeight))
        middle!.backgroundColor = UIColor.white
        middle!.isUserInteractionEnabled = false
        middle!.layer.cornerRadius = sectionHeight/2
        hamburgerButton.addSubview(middle!)
        
        bottom = UIView(frame:CGRect(x: width/2 - sectionWidth/2,y: height*0.66,width: sectionWidth,height: sectionHeight))
        bottom!.backgroundColor = UIColor.white
        bottom!.isUserInteractionEnabled = false
        bottom!.layer.cornerRadius = sectionHeight/2
        hamburgerButton.addSubview(bottom!)
        
    }
    
    func didTaphamburgerButton(_ sender:UIButton){
    
        //color
        var topColor = self.top?.pop_animation(forKey: "topColor") as! POPSpringAnimation?
        var bottomColor = self.top?.pop_animation(forKey: "bottomColor") as! POPSpringAnimation?

        //rotate
        var topRotate = self.top?.layer.pop_animation(forKey: "topRotate") as! POPSpringAnimation?
        var bottomRotate = self.top?.layer.pop_animation(forKey: "bottomRotate") as! POPSpringAnimation?
        
        
        //position
        var topPosition = self.top?.layer.pop_animation(forKey: "topPosition") as! POPSpringAnimation?
        var bottomPosition = self.top?.layer.pop_animation(forKey: "bottomPositon") as! POPSpringAnimation?

        if hamburgerOpen {
            
            
            for i in customBtnView.subviews {
                if i.tag < customTrackCount+1 {
                    let btn:UIButton = i as! UIButton
                    
                    let thread = Thread(target:self, selector:#selector(ViewController.startTrackAnimation(_:)),object:btn)
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
            
            UIView.animate(withDuration: 0.2, animations: { ()-> Void in
                self.middle!.alpha = 0
            })
            
            if topColor != nil {
                topColor?.toValue = UIColor.red
            }else{
                topColor = POPSpringAnimation(propertyNamed: kPOPViewBackgroundColor)
                topColor?.toValue = UIColor.red
                topColor?.springBounciness = 0
                topColor?.springSpeed = 18
                top?.pop_add(topColor, forKey: "topColor")
            }
            
            if bottomColor != nil {
                bottomColor?.toValue = UIColor.red
            }else{
                bottomColor = POPSpringAnimation(propertyNamed: kPOPViewBackgroundColor)
                bottomColor?.toValue = UIColor.red
                bottomColor?.springBounciness = 0
                bottomColor?.springSpeed = 18
                bottom?.pop_add(bottomColor, forKey: "bottomColor")
            }
            
            if topRotate != nil {
                topRotate?.toValue = -M_PI/4
            }else{
                topRotate = POPSpringAnimation(propertyNamed: kPOPLayerRotation)
                topRotate?.toValue = -M_PI/4
                topRotate?.springBounciness = 11
                topRotate?.springSpeed = 18
                top?.layer.pop_add(topRotate, forKey: "topRotate")
            }
//
            if bottomRotate != nil {
                bottomRotate?.toValue = M_PI/4
            }else{
                bottomRotate = POPSpringAnimation(propertyNamed: kPOPLayerRotation)
                bottomRotate?.toValue = M_PI/4
                bottomRotate?.springBounciness = 11
                bottomRotate?.springSpeed = 18
                bottom?.layer.pop_add(bottomRotate, forKey: "bottomRotate")
            }
            
            if topPosition != nil {
                topPosition?.toValue = CGFloat(sender.tag)*0.2
            }else{
                topPosition = POPSpringAnimation(propertyNamed: kPOPLayerTranslationY)
                topPosition?.toValue = CGFloat(sender.tag)*0.2
                topPosition?.springBounciness = 11
                topPosition?.springSpeed = 18
                top?.layer.pop_add(topPosition, forKey: "topPosition")
            }
            
            if bottomPosition != nil {
                bottomPosition?.toValue = -CGFloat(sender.tag)*0.2
            }else{
                bottomPosition = POPSpringAnimation(propertyNamed: kPOPLayerTranslationY)
                bottomPosition?.toValue = -CGFloat(sender.tag)*0.2
                bottomPosition?.springBounciness = 11
                bottomPosition?.springSpeed = 18
                bottom?.layer.pop_add(bottomPosition, forKey: "bottomPosition")
            }
            
        }else{
            
//            exampleBackView.hidden = false
//            customBackView.hidden = false
//            exampleBackView.userInteractionEnabled = true
//            customBackView.userInteractionEnabled = true

            hamburgerOpen = true
            
            UIView.animate(withDuration: 0.2, animations: { ()-> Void in
                self.middle!.alpha = 1
            })
            
            if topColor != nil {
                topColor?.toValue = UIColor.white
            }else{
                topColor = POPSpringAnimation(propertyNamed: kPOPViewBackgroundColor)
                topColor?.toValue = UIColor.white
                topColor?.springBounciness = 0
                topColor?.springSpeed = 18
                top?.pop_add(topColor, forKey: "topColor")
            }
            
            if bottomColor != nil {
                bottomColor?.toValue = UIColor.white
            }else{
                bottomColor = POPSpringAnimation(propertyNamed: kPOPViewBackgroundColor)
                bottomColor?.toValue = UIColor.white
                bottomColor?.springBounciness = 0
                bottomColor?.springSpeed = 18
                bottom?.pop_add(bottomColor, forKey: "bottomColor")
            }
            
            if topRotate != nil {
                topRotate?.toValue = 0
            }else{
                topRotate = POPSpringAnimation(propertyNamed: kPOPLayerRotation)
                topRotate?.toValue = 0
                topRotate?.springBounciness = 11
                topRotate?.springSpeed = 18
                top?.layer.pop_add(topRotate, forKey: "topRotate")
            }
            //
            if bottomRotate != nil {
                bottomRotate?.toValue = 0
            }else{
                bottomRotate = POPSpringAnimation(propertyNamed: kPOPLayerRotation)
                bottomRotate?.toValue = 0
                bottomRotate?.springBounciness = 11
                bottomRotate?.springSpeed = 18
                bottom?.layer.pop_add(bottomRotate, forKey: "bottomRotate")
            }
            
            if topPosition != nil {
                topPosition?.toValue = 0
            }else{
                topPosition = POPSpringAnimation(propertyNamed: kPOPLayerTranslationY)
                topPosition?.toValue = 0
                topPosition?.springBounciness = 11
                topPosition?.springSpeed = 18
                top?.layer.pop_add(topPosition, forKey: "topPosition")
            }
            
            if bottomPosition != nil {
                bottomPosition?.toValue = 0
            }else{
                bottomPosition = POPSpringAnimation(propertyNamed: kPOPLayerTranslationY)
                bottomPosition?.toValue = 0
                bottomPosition?.springBounciness = 11
                bottomPosition?.springSpeed = 18
                bottom?.layer.pop_add(bottomPosition, forKey: "bottomPosition")
            }
        
        }
        
    }
    
    func trackMove(_ x:Int,y:Int) -> Int{
        
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
    
    
    func initArrayFromCount(_ count:Int){
        for i in 1...count {
            initPointArray.append(i)
        }
    }
    
    func arrayContains(_ offset:Int) -> Bool{
        return turnPointArray.contains(where: { (element) -> Bool in
            let contain = ((element.0+offset == x)&&(element.1 == y)) ? true : false   
            return contain
        })
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

