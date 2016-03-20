//
//  InitAuthenticatorViewController.swift
//  miauth
//
//  Created by developer on 27/02/16.
//  Copyright © 2016 MIPsoft. All rights reserved.
//

import UIKit
import Google

class InitAuthenticatorViewController: UIViewController,GIDSignInUIDelegate {
    
    @IBOutlet weak var switchICloud:UISwitch!
    @IBOutlet weak var switchGoogle:UISwitch!
    @IBOutlet weak var buttonPinPad:UIButton!
    @IBOutlet weak var switchFingerPrintReader:UISwitch!
    @IBOutlet weak var segmentedPinLength:UISegmentedControl!
    @IBOutlet weak var labelTitle1:UILabel!
    @IBOutlet weak var labelTitle2:UILabel!
    @IBOutlet weak var labelTitle3:UILabel!
    var blurEffectView:UIVisualEffectView!
    var pincode:String?

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        let blurEffect = UIBlurEffect(style: UIBlurEffectStyle.ExtraLight)
        blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = view.bounds
        blurEffectView.alpha = 0.8
        blurEffectView.autoresizingMask = [.FlexibleWidth, .FlexibleHeight] // for supporting device rotation
        view.addSubview(blurEffectView)
        
        let touchIdPresent = ExtAuthManager.sharedInstance.fingerprintReaderIsAvailable()
        labelTitle3.hidden = !touchIdPresent
        switchFingerPrintReader.hidden = !touchIdPresent
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        setScreenStatus()
        GIDSignIn.sharedInstance().uiDelegate = self
        extAuthStatusChanged(nil)
        segmentedPinLength.selectedSegmentIndex = ExtAuthManager.sharedInstance.pinCodeLength-4
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "extAuthStatusChanged:", name:"ExtAuthStatusChange", object: nil)
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        NSNotificationCenter.defaultCenter().removeObserver(self, name: "ExtAuthStatusChange", object: nil)
    }
    
    func setScreenStatus()
    {
        if ( switchICloud.on || switchGoogle.on ) {
            unBlurSecureWithPin() //TODO: Jos on sormenjälki annettu, pitää antaa Seal...
        }

        if pincode?.characters.count>=4  {
            unBlurSealWithFingerprint()
        }
    }
    
    func unBlurConnect() {
        blurEffectView.hidden = false
        blurEffectView.frame.origin.y = labelTitle2.frame.origin.y
    }

    func unBlurSecureWithPin() {
        blurEffectView.hidden = false
        blurEffectView.frame.origin.y = labelTitle3.frame.origin.y
    }
    
    func unBlurSealWithFingerprint() {
        blurEffectView.hidden = true
    }
    
    func extAuthStatusChanged(notification: NSNotification?){
        //Take Action on Notification
        switchICloud.on = ExtAuthClientICloud.sharedInstance.isAvailable
        switchICloud.enabled = !switchICloud.on
        switchGoogle.on = ExtAuthClientGoogle.sharedInstance.isAvailable
        setScreenStatus()
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    @IBAction func buttonPressed(sender:UIButton!) {
        if sender==buttonPinPad {
            ExtAuthManager.sharedInstance.pinCodeQueryType = .SetNew
            //{ (s1: String, s2: String) -> Bool in return s1 > s2 }
            PinPadViewController.sharedInstance.registerCallbackForPinCodeEntered( {  (pin:String) -> () in self.pincodeReceived(pin) } );
        }
    }
    
   func pincodeReceived(pin:String) ->(Void) {
        print("pin=\(pin)")
        pincode = pin
        setScreenStatus()
    }
    
    @IBAction func switchChanged(sender:UISwitch!) {
        if sender==switchGoogle {
            if switchGoogle.on {
                GIDSignIn.sharedInstance().signIn()
            }
            else {
                GIDSignIn.sharedInstance().signOut()
            }
            return
        }
        
        if sender==switchFingerPrintReader {
            if switchFingerPrintReader.on {
                ExtAuthClientICloud.sharedInstance.authenticateAndSavePinUsingTouchID(pincode!)
            }
            else {
                //
            }
            return
        }
        
    }
    
    @IBAction func segmentChanged(sender:UISegmentedControl!) {
         ExtAuthManager.sharedInstance.pinCodeLength = segmentedPinLength.selectedSegmentIndex + 4
    }
    
}
