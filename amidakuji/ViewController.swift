//
//  ViewController.swift
//  amidakuji
//
//  Created by yrq_mac on 16/5/28.
//  Copyright © 2016年 yrq_mac. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    let Bottom:Int = 8
    var btnArray:[(Int,Int)] = []
    var x:Int = 0
    var y:Int = 0
    var initPointArray:[Int] = []
    var movePointArray = [(1,3),(2,4),(3,3),(3,5),(3,7),(4,6)]
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        isMoveElement(2, y: 3)
//        for i in 1...4{
//            let btn = UIButton(type:.System)
//            btn.frame = CGRectMake(10+(CGFloat(i)-1)*50, 100, 50, 30)
//            btn.tag = i
//            btn.setTitle("\(i)", forState: UIControlState.Normal)
//            view.addSubview(btn)
//        }
//        print(btnArray)
//        
        initArrayFromCount(5)
        for i in 1...initPointArray.count {
            x = i
            y += 1
            while y != Bottom {
                x = isMoveElement(x, y: y)
                y += 1
//                print(x,y)
            }
            print("\(i)'s end x is \(x)")
            y = 0
        }
    }
    
    func isMoveElement(x:Int,y:Int) -> Int{
        
        var _x = x
        
        if x == 1 {
            if arrayContains(0){
//                print("moveRight")
                _x+=1
            }
        }else if x == movePointArray.count {
            if arrayContains(1){
//                print("moveLeft")
                _x-=1
            }
        
        }else{
            if arrayContains(1){
//                print("moveLeft")
                _x-=1
            }else if arrayContains(0){
//                print("moveRight")
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

