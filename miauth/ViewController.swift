//
//  ViewController.swift
//  miauth
//
//  Created by developer on 27/02/16.
//  Copyright © 2016 MIPsoft. All rights reserved.
//


import UIKit
    var extAuthManager: ExtAuthManager?

class ViewController: UIViewController {
    static let sharedInstance = ViewController()
    @IBOutlet weak var labelHeader:UILabel!
    @IBOutlet weak var buttonOK:UIButton!
    @IBOutlet weak var buttonCancel:UIButton!
    @IBOutlet weak var buttonSettings:UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        extAuthManager = ExtAuthManager.sharedInstance
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(ViewController.returnToCallingAppEvent(_:)), name:"returnToCallingAppEvent", object: nil)
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector:#selector(willEnterForground), name:
            UIApplicationWillEnterForegroundNotification, object: nil)
    }
    
    deinit {
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
    func willEnterForground() {
        let dispatchTime: dispatch_time_t = dispatch_time(DISPATCH_TIME_NOW, Int64(0.1*Double(NSEC_PER_SEC)))
        dispatch_after(dispatchTime, dispatch_get_main_queue(), {  self.setScreen() })
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        setScreen()
    }
    
    func setScreen() {
        if extAuthManager!.callingAppCallback=="" {
            //Launch config
            labelHeader.text = "Tämä on miAuth-sovellus näppärään kännysovelluskirjautumiseen. Käy asetuksissa ja perusta itsellesi tili!"
            buttonOK.hidden = true;
            buttonCancel.hidden = true;
            buttonSettings.hidden = false;
        }
        else {
            buttonOK.hidden = true;
            buttonCancel.hidden = true;
            buttonSettings.hidden = false;
            let title:String = "Kirjaudu sovellukseen \(extAuthManager!.callingAppName)"
            labelHeader.text = title
            //performSegueWithIdentifier("GotoAskPermission", sender: nil)
            extAuthManager!.fingerprintReaderReadNow( nil, ok:{ self.authOk() }, fallback: { self.authFallback() }, notok: { self.authFail() }, title:title )
        }
    }
    
    func authOk() {
        performSegueWithIdentifier("GotoAskPermission", sender: nil)
    }
    
    func authFallback() {
      extAuthManager!.returnToCallingApp(false)
    }
    
    func authFail() {
        extAuthManager!.returnToCallingApp(false)
    }

    @IBAction func buttonPressedOK(sender:UIButton!) {
        if extAuthManager!.returnToCallingApp(true) {
        }
        else {
            //ERROR HANDLING
        }
        //extAuthManager!.fingerprintReaderReadNow({ self.authOk() }, fallback: { self.authFallback() }, notok: { self.authFail() } )
    }
    
    @IBAction func buttonPressedCancel(sender:UIButton!) {
        if extAuthManager!.returnToCallingApp(false) {
        }
        else {
            //ERROR HANDLING
        }

    }
    
    
     func returnToCallingAppEvent(notification: NSNotification?)
     {
        extAuthManager!.callingAppCallback = "com.mipsoft.miauth-ios-sampleApp"
        if extAuthManager!.returnToCallingApp(true) {
        }
        else {
            //ERROR HANDLING
        }
    }

}

