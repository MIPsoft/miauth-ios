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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        extAuthManager = ExtAuthManager.sharedInstance
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(ViewController.returnToCallingAppEvent(_:)), name:"returnToCallingAppEvent", object: nil)
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector:#selector(setScreen), name:
            UIApplicationWillEnterForegroundNotification, object: nil)
    }
    
    deinit {
        NSNotificationCenter.defaultCenter().removeObserver(self)
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
        print("extAuthManager!.callingAppCallback=\(extAuthManager!.callingAppCallback)")
        if extAuthManager!.callingAppCallback=="" {
            //Launch config
            self.labelHeader.text = ""
            self.buttonOK.hidden = false;
            self.buttonCancel.hidden = true;
        }
        else {
            buttonOK.hidden = false;
            buttonCancel.hidden = false;
            labelHeader.text = "Kirjaudu sovellukseen \(extAuthManager!.callingAppName)"
            //labelHeader!.text = extAuthManager!.callingAppCallback
        }
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
    
    func authOk() {
        NSNotificationCenter.defaultCenter().postNotificationName("returnToCallingAppEvent", object: nil)
    }
    
    func authFallback() {
        labelHeader!.text = "fallback" //extAuthManager!.callingAppCallback
    }
    
    func authFail() {
         labelHeader!.text = "fail" //extAuthManager!.callingAppCallback
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

