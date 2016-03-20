//
//  PinPadViewController.swift
//  miau
//
//  Created by developer on 27/02/16.
//  Copyright © 2016 MIPsoft. All rights reserved.
//

import UIKit
import AudioToolbox

class InsetLabel: UILabel {
    let topInset = CGFloat(30.0), bottomInset = CGFloat(0.0), leftInset = CGFloat(0.0), rightInset = CGFloat(0.0)
    
    override func drawTextInRect(rect: CGRect) {
        let insets: UIEdgeInsets = UIEdgeInsets(top: topInset, left: leftInset, bottom: bottomInset, right: rightInset)
        super.drawTextInRect(UIEdgeInsetsInsetRect(rect, insets))
    }
    
    override func intrinsicContentSize() -> CGSize {
        var intrinsicSuperViewContentSize = super.intrinsicContentSize()
        intrinsicSuperViewContentSize.height += topInset + bottomInset
        intrinsicSuperViewContentSize.width += leftInset + rightInset
        return intrinsicSuperViewContentSize
    }
}

class PinPadViewController: UIViewController {
    static let sharedInstance = PinPadViewController()
    var buttonsArray: Array<UIButton> = []
    let obscureChars:Array<Character> = ["◦","●"]
    let buttonLabel:Array<String> = ["1","2","3","4","5","6","7","8","9","","0","del"]
    let screenSize: CGRect = UIScreen.mainScreen().bounds
    var screenWidth:CGFloat?
    var btnWidth:CGFloat?
    var btnHeight:CGFloat?
    var screenHeight:CGFloat?
    var labelObscured:UILabel?
    var labelTitle:InsetLabel?
    var pinCodeEntered:String = ""
    var pinCodeLength:Int = 4
    var buttonDelete:UIButton?
    var buttonBack:UIButton?
    var setNewRound:Int = 0
    var setNewFirstCode:String = ""
    let topLabelBackgroundColor:UIColor = UIColor.init(colorLiteralRed: 0, green: 0, blue: 0, alpha: 0.2)
    static var callbackFunctionPinCodeEntered: ((pin:String)->())?
    
    func registerCallbackForPinCodeEntered(callback:(pin:String)->())
    {
        PinPadViewController.callbackFunctionPinCodeEntered = callback;
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        screenWidth = screenSize.width
        screenHeight = screenSize.height
        btnWidth = fmin( screenWidth!/3.0, screenHeight!/6.0 )
        btnHeight = btnWidth
        let topHeight = screenHeight! - btnHeight!*4
        
        labelTitle = InsetLabel(frame: CGRectMake(0,0,screenWidth!,topHeight/2))
        labelTitle!.backgroundColor = topLabelBackgroundColor;
        labelTitle!.textAlignment = .Center
        labelTitle!.font =  UIFont.monospacedDigitSystemFontOfSize(screenHeight!/20.0,weight: 0.1)
        self.view.addSubview(labelTitle!)
        labelTitle!.text  = "Anna pääsykoodi"
        
        buttonBack  = UIButton(type: UIButtonType.System) as UIButton
        buttonBack!.frame = CGRectMake(0,20,screenWidth!*0.2, 20)
        buttonBack!.setTitle("Peruuta", forState: .Normal)
        buttonBack!.addTarget(self, action: "buttonBack:", forControlEvents: UIControlEvents.TouchUpInside)
        self.view.addSubview(buttonBack!)
        
        labelObscured = UILabel(frame: CGRectMake(0,topHeight/2,screenWidth!,topHeight/2.5))
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
    
    override func viewWillAppear(animated: Bool) {
        pinCodeLength = ExtAuthManager.sharedInstance.pinCodeLength
        updateObscured()
        setNewRound = 0
        super.viewWillAppear(animated)
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
            holdRelease(button)
            button.layer.cornerRadius = btnWidth!*scale/2
            button.layer.borderWidth = 1
            button.tintColor = UIColor.blackColor()
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
        sender.backgroundColor =  UIColor.init(colorLiteralRed: 0.75, green: 0.75, blue: 0.75, alpha: 1.0)
    }
    
    func holdRelease(sender:UIButton)
    {
       // sender.backgroundColor =  UIColor.whiteColor()
         sender.backgroundColor =  UIColor.init(colorLiteralRed: 0.95, green: 0.95, blue: 0.95, alpha: 1.0)
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
    
    func updateTitle(titleText:String,title2:String,backgroundColor:UIColor)
    {
        labelTitle!.text = titleText
        self.labelTitle!.backgroundColor = backgroundColor
        
        if (backgroundColor != topLabelBackgroundColor) || (title2.characters.count>0)  {
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, Int64(1.0 * Double(NSEC_PER_SEC))), dispatch_get_main_queue(), {
                if  title2.characters.count>0 {
                    self.labelTitle!.text = title2
                }
                self.labelTitle!.backgroundColor = self.topLabelBackgroundColor
            })
        }
    }
    
    func checkPinCode() {
        if ExtAuthManager.sharedInstance.pinCodeQueryType == .SetNew {
            if setNewRound == 0 {
                setNewFirstCode = pinCodeEntered
                updateTitle("Anna koodi uudestaan",title2: "",backgroundColor: UIColor.init(colorLiteralRed: 0, green: 1, blue: 0, alpha: 0.2))
                pinCodeEntered = ""
                setNewRound++
                updateObscured()
                return
            }
            else
            {
                if pinCodeEntered==setNewFirstCode {
                    PinPadViewController.callbackFunctionPinCodeEntered?(pin: pinCodeEntered)
                    self.dismissViewControllerAnimated(true, completion: nil)
                    return
                }
                else {
                    updateTitle("Koodi ei ollut sama",title2:"Anna koodi uudestaan",backgroundColor: UIColor.init(colorLiteralRed: 1, green: 0, blue: 0, alpha: 0.2))
                }
            }
        }
        
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
    
    func buttonBack(sender:UIButton!)
    {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    
}
