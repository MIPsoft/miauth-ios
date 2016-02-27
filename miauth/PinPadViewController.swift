//
//  PinPadViewController.swift
//  miau
//
//  Created by developer on 27/02/16.
//  Copyright © 2016 MIPsoft. All rights reserved.
//

import UIKit
import AudioToolbox

class PinPadViewController: UIViewController {
    var buttonsArray: Array<UIButton> = []
    let obscureChars:Array<Character> = ["◦","●"]
    let buttonLabel:Array<String> = ["1","2","3","4","5","6","7","8","9","","0","del"]
    let screenSize: CGRect = UIScreen.mainScreen().bounds
    var screenWidth:CGFloat?
    var btnWidth:CGFloat?
    var btnHeight:CGFloat?
    var screenHeight:CGFloat?
    var labelObscured:UILabel?
    var pinCodeEntered:String = ""
    var pinCodeLength:Int = 4
    var buttonDelete:UIButton?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        screenWidth = screenSize.width
        screenHeight = screenSize.height
        btnWidth = fmin( screenWidth!/3.0, screenHeight!/6.0 )
        btnHeight = btnWidth
        let topHeight = screenHeight! - btnHeight!*4
        
        labelObscured = UILabel(frame: CGRectMake(0,0,screenWidth!,topHeight))
        labelObscured!.textAlignment = .Center
        labelObscured!.font =  UIFont.monospacedDigitSystemFontOfSize(screenHeight!/10.0,weight: 0.1)
        self.view.addSubview(labelObscured!)
        
        // Do any additional setup after loading the view, typically from a nib.
        for r in 0...3 {
            for c in 0...2 {
                createButton(c,row:r)
            }
        }
        
        updateObscured()
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    func updateObscured()
    {
        var obscuredText:String = ""
        let codesEntered = pinCodeEntered.characters.count
        for i in 1...pinCodeLength {
            if i<=codesEntered {
                obscuredText.append(obscureChars[1])
            }
            else {
                obscuredText.append(obscureChars[0])
            }
            if i<pinCodeLength {
                obscuredText += " "
            }
        }
        buttonDelete!.hidden  = codesEntered==0
        labelObscured!.text = obscuredText
    }
    
    func createButton(col:Int,row:Int)
    {
        if ( row==3 && col < 1 ) {
            return
        }
        let scale:CGFloat = 0.8
        let button   = UIButton(type: UIButtonType.System) as UIButton
        let x:CGFloat = CGFloat(col) * btnWidth! + (screenWidth!-3*btnWidth!)/2.0
        let y:CGFloat = screenHeight! - (4-CGFloat(row))*btnHeight!
        let idx = col + row*3
        button.frame = CGRectMake(x,y, btnWidth!*scale, btnHeight!*scale)
        button.addTarget(self, action: "buttonAction:", forControlEvents: UIControlEvents.TouchUpInside)
        button.tag = idx
        if (  row==3 && col == 2 ) { //Del button
            button.setTitle("", forState: UIControlState.Normal)
            button.titleLabel!.font =  UIFont.monospacedDigitSystemFontOfSize(screenHeight!/30,weight: 0.1)
            buttonDelete = button
            buttonDelete!.setTitle("poista", forState: UIControlState.Normal)
        }
        else { //number
            var divider:CGFloat = 8.0
            if idx==11 {
                divider = divider * 1.5
            }
            button.layer.cornerRadius = btnWidth!*scale/2
            button.layer.borderWidth = 1
            button.titleLabel!.font =  UIFont.monospacedDigitSystemFontOfSize(screenHeight!/divider,weight: 0.1)
            button.setTitle(buttonLabel[idx], forState: UIControlState.Normal)
            button.layer.borderColor = UIColor.blackColor().CGColor
            button.addTarget(self, action: Selector("holdRelease:"), forControlEvents: UIControlEvents.TouchUpInside);
            button.addTarget(self, action: Selector("holdDown:"), forControlEvents: UIControlEvents.TouchDown)
        }
        
        
        self.view.addSubview(button)
    }
    
    func holdDown(sender:UIButton)
    {
        sender.backgroundColor =  UIColor.lightGrayColor()
    }
    
    func holdRelease(sender:UIButton)
    {
        sender.backgroundColor =  UIColor.clearColor()
    }
    
    func buttonAction(sender:UIButton!)
    {
        let key = sender.titleLabel!.text!.characters.last
        let idx = sender.tag
        if idx == 11 { //Poista
            pinCodeEntered = pinCodeEntered.substringToIndex(pinCodeEntered.endIndex.predecessor())
            sender.hidden = true
        }
        else {
            pinCodeEntered.append(key!)
        }
        updateObscured()
        if pinCodeEntered.characters.count == pinCodeLength {
            checkPinCode()
        }
    }
    
    func checkPinCode() {
        pinCodeEntered = ""
        updateObscured()
        AudioServicesPlayAlertSound(SystemSoundID(kSystemSoundID_Vibrate))
        
        let anim = CAKeyframeAnimation( keyPath:"transform" )
        anim.values = [
            NSValue( CATransform3D:CATransform3DMakeTranslation(-15, 0, 0 ) ),
            NSValue( CATransform3D:CATransform3DMakeTranslation( 15, 0, 0 ) )
        ]
        anim.autoreverses = true
        anim.repeatCount = 2
        anim.duration = 7/100
        labelObscured!.layer.addAnimation( anim, forKey:nil )
    }
}
