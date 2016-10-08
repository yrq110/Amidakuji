//
//  ReverseViewController.swift
//  amidakuji
//
//  Created by yrq_mac on 16/6/9.
//  Copyright © 2016年 yrq_mac. All rights reserved.
//

import UIKit

class ReverseViewController: UIViewController {

    let pointSize:CGFloat = 14
    let XStep:CGFloat = 40
    let YStep:CGFloat = 25
    var TrackSegemetCount:Int = 16
    var x:Int = 0
    var y:Int = 0
    var initPointArray:[Int] = []
    var x_arr = Array<Int>()
    var y_arr = Array<Int>()
    var scoreArray = Array<Int>()
    var trackDic = Array<(Int,Int)>()
    var tipTrack = Dictionary<Int,Array<(Int,Int)>>()
    var isAnimeOver = true
    var movePointArray = Array<(CGFloat,CGFloat)>()
    //    var movePointArray = [(1,1),(1,3),(2,2),(2,7),(3,1),(4,5),(5,3),(5,6),(6,2),(6,5)]
    var turnPointArray = Array<(Int,Int)>()
    var resultArray = Array<Int>()
    var calculateTrackButton = ACButton()
    var calculateTurnLineButton = ACButton()
    var changeModeButton = UIButton()
//    var hamburgerButton = ACButton()
    
    var btn_x_array = Array<CGFloat>()
    var btn_x:CGFloat = 0
    var btn_y:CGFloat = 515
    var movePositionX = POPSpringAnimation()
    var movePositionY = POPSpringAnimation()
    
    var customTrackCount:Int = 0
    var customBtnView = UIView()
    var customTrackView = UIView()
    var customBackView = UIView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.white
        customBtnView.frame = self.view.frame
        customTrackView.frame = self.view.frame
        customBackView.frame = self.view.frame
        
        let count:Int = 7
        initArrayFromCount(count)
        
        customTrackCount = count
        
        var arr = [1,2,3,4,5,6,7]
//        var arr = [1,5,2,3,4]
        for i in 1...customTrackCount {
            let scope = count+1-i
            let a = Int(Int(arc4random())%scope)
//            print(arr[a])
            resultArray.append(arr[a])
            let btn_tag = arr[a]
            arr.remove(at: a)

//            resultArray.append(arr[i-1])
//            let btn_tag = arr[i-1]
            
            let btn = ACButton()
            btn.x = i
            btn.y = TrackSegemetCount
            btn.setTitle("\(btn_tag)", for: UIControlState())
            btn.frame = CGRect(x: 45+(CGFloat(i)-1)*40, y: 500, width: 30, height: 30)
//            btn.addTarget(self, action: #selector(ViewController.startTrackAnimation(_:)), forControlEvents: UIControlEvents.TouchUpInside)
            btn.layer.cornerRadius = btn.frame.size.height/2
//            btn.tag = btn_tag + 100*8 + 10*i
//            print("center.x is \(btn.center.x),y is \(btn.center.y)")
            btn.addTarget(self, action: #selector(ReverseViewController.startTrackAnimation(_:)), for: UIControlEvents.touchUpInside)
            btn.tag = btn_tag
            btn.setTitleColor(.white, for: UIControlState())
            btn.backgroundColor = UIColor.black
//            btn.enabled = false
            customBtnView.addSubview(btn)
            
            let line = UIView(frame:CGRect(x: 55+(CGFloat(i)-1)*XStep,y: 120,width: 10,height: 390))
            line.backgroundColor = UIColor.green
            line.layer.cornerRadius = 3.0
            line.tag = i*1000
            customTrackView.addSubview(line)
            
            self.addPoint(self.TrackSegemetCount, line: line, view: self.customBtnView,lineNumber: i)
            btn_x_array.append(btn.center.x)
            
        }
        
        print(resultArray)
        
        customBackView.addSubview(customTrackView)
        customBackView.addSubview(customBtnView)

//        view.addSubview(customBackView)
        
        let startBtn = ACButton()
        startBtn.setTitle("Go!", for: UIControlState())
        startBtn.backgroundColor = UIColor.black
        startBtn.frame = CGRect(x: 170,y: 30, width: 50, height: 50)
        startBtn.layer.cornerRadius = 25
        startBtn.addTarget(self, action: #selector(ReverseViewController.startAllAnimation(_:)), for: UIControlEvents.touchUpInside)
//        view.addSubview(startBtn)
        customBackView.addSubview(startBtn)
        
        calculateTrackButton.backgroundColor = UIColor.brown
        calculateTrackButton.setTitle("2-Track", for: UIControlState())
        calculateTrackButton.frame = CGRect(x: 260,y: 40, width: 80, height: 30)
        calculateTrackButton.addTarget(self, action: #selector(ReverseViewController.calculateTrack(_:)), for: .touchUpInside)
        calculateTrackButton.layer.cornerRadius = 10
        customBackView.addSubview(calculateTrackButton)
        
        calculateTurnLineButton.backgroundColor = UIColor.brown
        calculateTurnLineButton.setTitle("1-Answer", for: UIControlState())
        calculateTurnLineButton.frame = CGRect(x: 20,y: 40, width: 100, height: 30)
        calculateTurnLineButton.addTarget(self, action: #selector(ReverseViewController.reverse(_:)), for: .touchUpInside)
        calculateTurnLineButton.layer.cornerRadius = 10
        customBackView.addSubview(calculateTurnLineButton)
        view.addSubview(customBackView)
        
        changeModeButton = UIButton(type:.custom)
        changeModeButton.setTitle("Mode A", for: UIControlState())
        changeModeButton.frame = CGRect(x: 0, y: 0, width: 200, height: 60)
        changeModeButton.center = CGPoint(x: view.center.x, y: view.frame.size.height-40)
        changeModeButton.backgroundColor = UIColor.red
        changeModeButton.addTarget(self, action: #selector(ReverseViewController.goToReverseVC(_:)), for: UIControlEvents.touchUpInside)
        view.addSubview(changeModeButton)
    }
    
    func goToReverseVC(_ sender:UIButton){
        self.dismiss(animated: true, completion: nil)
//        let vc = ViewController()
//        self.presentViewController(vc, animated: true, completion: nil)
    }
    
    func startAllAnimation(_ sender:UIButton){
        for i in customBtnView.subviews {
            if i.tag < customTrackCount+1 {
                let btn:UIButton = i as! UIButton
                
                let thread = Thread(target:self, selector:#selector(ReverseViewController.startTrackAnimation(_:)),object:btn)
                thread.name = "btnThread\(i.tag)"
                thread.start()
            }
        }
    
    }
    
    func startTrackAnimation(_ sender:UIButton){
        
        var x_arr = Array<Int>()
        var y_arr = Array<Int>()
        
        let track:[(Int,Int)] = tipTrack[sender.tag]!
        //        print("track is \(track)")
        let movePositionY = POPSpringAnimation(propertyNamed: kPOPLayerTranslationY)
        movePositionY?.toValue = 0
        movePositionY?.springBounciness = 5
        movePositionY?.springSpeed = 5
        sender.layer.pop_add(movePositionY, forKey: "movePositionY\(sender.tag)")
        movePositionY?.completionBlock = { (animation, complete) in
            if complete {
//                print("first Y is \(sender.tag)")
                for (x,y) in track {
                    x_arr.append(x)
                    y_arr.append(y)
                }
                self.movePostionXAndY(sender, x_arr: x_arr, y_arr: y_arr,i: 0)
            }
        }
    }
    
    func movePostionXAndY(_ sender:UIButton,x_arr:Array<Int>,y_arr:Array<Int>,i:Int){
        
//        print("Into move is \(sender.tag)")
        
        if i == x_arr.count {
            
            let movePositionY = POPSpringAnimation(propertyNamed: kPOPLayerTranslationY)
            movePositionY?.toValue = -50
            movePositionY?.springBounciness = 5
            movePositionY?.springSpeed = 5
            sender.layer.pop_add(movePositionY, forKey: "movePositionY\(sender.tag)")
            movePositionY?.completionBlock = { (animation, complete) in
                if complete {
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
                            
                            let btn = sender as! ACButton
                            print("\(btn.tag),\(btn.x!),\(btn.y!)")
//                            print(NSThread.currentThread())
                            let thread = Thread.current
                            thread.cancel()
                            
                            btn.backgroundColor = btn.tag == btn.x! ? UIColor.green : UIColor.red
                            
                            let score = btn.tag == btn.x! ? 1 : 0
                            self.scoreArray.append(score)
                            
                            if self.scoreArray.count == self.customTrackCount {
                                
                                var a:Int = 0
                                let finalScore = self.scoreArray.map({ (element) -> Int in
                                    a += element
                                    return a
                                }).last!
                                
                                var alertString:String = ""
                                switch finalScore {
                                case self.customTrackCount:
                                    alertString = "全部正确!本次得分:\(a)"
                                case 1...self.customTrackCount-1:
                                    alertString = "再接再厉!本次得分:\(a)"
                                case 0 :
                                    alertString = "没一个对的。。这也是天赋。。"
                                default:
                                    alertString = ""
                                }
                                
                                let alertController = UIAlertController(title: "提示",message: alertString, preferredStyle: UIAlertControllerStyle.alert)
                                let cancelAction = UIAlertAction(title: "取消", style: UIAlertActionStyle.cancel, handler: nil)
                                let okAction = UIAlertAction(title: "好的", style: UIAlertActionStyle.default,handler: { action in
                                                                
                                })
                                alertController.addAction(cancelAction)
                                alertController.addAction(okAction)
                                self.present(alertController, animated: true, completion: nil)
                            }
                        }
                    }
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
    
    func calculateTrack(_ sender:UIButton){
        
        for i in 1...customTrackCount {
//
//            btn_x = btn_x_array[i-1]
            btn_y = 515
//            print(resultArray.indexOf(i)!+1)
            btn_x = btn_x_array[resultArray.index(of: i)!]
//            print( "\(resultArray.indexOf(i)!+1) is \(btn_x)")
//            print(btn_x)
            y = TrackSegemetCount
            x = resultArray.index(of: i)!+1
//            print("init x is \(x) ,y is \(y)")

            y -= 1
            
            while y != 0 {
                
                let _x = trackMove(x, y: y)
                if _x > x {
                    trackDic.append((Int(btn_x),Int(btn_y-YStep)))
                    btn_x += XStep
                    
                }else if _x < x {
                    trackDic.append((Int(btn_x),Int(btn_y-YStep)))
                    btn_x -= XStep
                }
                x = _x
                y -= 1
                btn_y -= YStep
//                print("\(i) btn_x:\(btn_x),btn_y:\(btn_y)")
                trackDic.append((Int(btn_x),Int(btn_y)))
            }
            
            for j in customBtnView.subviews {
                if j.isKind(of: ACButton.self) && j.backgroundColor == UIColor.black && j.tag == i {
                    let btn = j as! ACButton
                    btn.x! = x
                    btn.y! = y
                }
            }

            print("\(i)btn x is \(x), y is \(y)")
            y = TrackSegemetCount
            tipTrack[i] = trackDic
            trackDic = []
        }
        print(tipTrack)
        sender.isEnabled = false
    
    }
    
    
    func reverse(_ sender:UIButton){
        for i in 1...customTrackCount {
            for btnView in customBtnView.subviews {
                if btnView.tag == i {
                    let acBtn = btnView as! ACButton
                    nextStartY = acBtn.y!
                    moveUpStepByStep(acBtn)
                }
            }
        }
        
//        turnPointArray.map { (element) -> (x:Int,y:Int) in
//            let _x_center = 60 + (element.0-1) * Int(XStep)
//            let _y_center = 115 + element.1 * Int(YStep)
//            
//            self.movePointArray.append((_x_center,_y_center))
//            return (_x_center,_y_center)
//            }
        
        print("calculate over")
//        print(movePointArray)
        
    }
    
    var nextStartY:Int = 0
    var isTrackChanged = false
    
    //移动主要节点
    func moveUpStepByStep(_ btn:ACButton){
        
//        var isTrackChanged = false
//        var nextTurnStartY = btn.y!
        var _x = btn.x!
        var _y = btn.y!
        
//        print("btn\(btn.tag):x is \(_x), y is \(_y)")
        
        if _x != btn.tag && _y != 0 {
            _x -= 1
            _y -= 1

            isTrackChanged = true
            nextStartY = _y
            turnPointArray.append((_x,_y))
            
        }else if _y != 0 {
            
            _y -= 1
            
        }else{
            
            if !isTrackChanged  {
                nextStartY -= 1
            }
//            else{
//                nextStartY += 1
//            }
            
            moveOtherBtn(btn.tag,moveToY: nextStartY)
            print(turnPointArray)
            return
            
        }
        
        (btn.x!,btn.y!) = (_x,_y)
        
        moveUpStepByStep(btn)
    }
    
    //移动其他节点
    func moveOtherBtn(_ a:Int,moveToY:Int){
        
        if a == customTrackCount {
            drawTurnLine()
            return
        }
//        print("End_Y is \(moveToY)")
        for btnView in customBtnView.subviews {
            
            for i in a+1...customTrackCount{
                if btnView.tag == i && btnView.isKind(of: ACButton.self) {
                    let acBtn = btnView as! ACButton
                    
                    while acBtn.y! != moveToY {
                        
                        acBtn.y! -= 1
                        
                        if turnPointArray.contains(where: { (element) -> Bool in
                            let contain = ((element.0 == acBtn.x!)&&(element.1 == acBtn.y!)) ? true : false
                            return contain
                        }) {
                            acBtn.x! += 1
                        }else if turnPointArray.contains(where: { (element) -> Bool in
                            let contain = ((element.0 + 1 == acBtn.x!)&&(element.1 == acBtn.y!)) ? true : false
                            return contain
                        }) {
                            acBtn.x! -= 1
                            
                        }
//                        print("otherBtn\(acBtn.tag):x is \(acBtn.x!), y is \(acBtn.y!)")
                    }
                    
                }
            }
            
        }
    
    }
    
    func drawTurnLine(){
        
        for i in customBtnView.subviews {
            if i.backgroundColor == UIColor.red{
                let sender = i as! ACButton
                let a = sender.tag
                let aa = a/100
                let bb = a%100
                sender.isEnabled = false
//                sender.hidden = true
                if turnPointArray.contains(where: { (element) -> Bool in
                    let contain = ((element.0 == aa)&&(element.1 == bb)) ? true : false
                    return contain
                }) {
                    let horiLine = UIView()
                    horiLine.frame.size = CGSize(width: 35, height: 5)
                    horiLine.frame.origin = CGPoint(x: sender.center.x, y: sender.center.y)
                    horiLine.center.y = sender.center.y
                    horiLine.backgroundColor = UIColor.red
                    customTrackView.addSubview(horiLine)
//                    print("line x is \(horiLine.frame.origin.x), y is \(horiLine.frame.origin.y+horiLine.frame.size.height/2)")
//                    print("btn.center x is \(sender.center.x) y is \(sender.center.y)")
                    
                    movePointArray.append((sender.center.x,sender.center.y))
                }
                
            }
        
        }
        print(movePointArray)
//        var isOver = true
//        for i in customBtnView.subviews {
//            if i.backgroundColor == UIColor.redColor() && i.isKindOfClass(ACButton) {
//                let btn = i as! ACButton
//                if btn.x! == btn.tag && btn.y! == 0 {
//                    continue
//                }else{
//                    isOver = false
//                }
//            }
//            
//        }
//        print(isOver)
        
        
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
    
    func tapPoint(_ sender:UIButton){
        let a = sender.tag
        let aa = a/100
        let bb = a%100
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
            if i.tag == new_tag && i.isKind(of: UIButton.self) {
                let btn:UIButton = customBtnView.viewWithTag(new_tag) as! UIButton
                btn.isEnabled = false
            }
        }
    }
    
    func initArrayFromCount(_ count:Int){
        for i in 1...count {
            initPointArray.append(i)
        }
    }

    func trackMove(_ x:Int,y:Int) -> Int{
        
        var _x = x
        
        if x == 1 {
            if arrayContains(0){
                _x+=1
            }
        }else if x == customTrackCount {
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
