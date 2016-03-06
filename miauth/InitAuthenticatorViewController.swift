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

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        GIDSignIn.sharedInstance().uiDelegate = self
        extAuthStatusChanged(nil)
        segmentedPinLength.selectedSegmentIndex = ExtAuthManager.sharedInstance.pinCodeLength-4
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "extAuthStatusChanged:", name:"ExtAuthStatusChange", object: nil)
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        NSNotificationCenter.defaultCenter().removeObserver(self, name: "ExtAuthStatusChange", object: nil)
    }
    
    func extAuthStatusChanged(notification: NSNotification?){
        //Take Action on Notification
        switchICloud.on = ExtAuthClientICloud.sharedInstance.isAvailable
        switchICloud.enabled = !switchICloud.on
        switchGoogle.on = ExtAuthClientGoogle.sharedInstance.isAvailable
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
        }
    }
    
    @IBAction func switchChanged(sender:UISwitch!) {
        if sender==switchGoogle {
            if switchGoogle.on {
                GIDSignIn.sharedInstance().signIn()
            }
            else {
                GIDSignIn.sharedInstance().signOut()
            }
        }
    }
    
    @IBAction func segmentChanged(sender:UISegmentedControl!) {
         ExtAuthManager.sharedInstance.pinCodeLength = segmentedPinLength.selectedSegmentIndex + 4
    }
    
}
