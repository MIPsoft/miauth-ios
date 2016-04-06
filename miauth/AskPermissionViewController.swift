//
//  AskPermissionViewController.swift
//  miauth
//
//  Created by developer on 06/04/16.
//  Copyright © 2016 MIPsoft. All rights reserved.
//

import UIKit

class AskPermissionViewController: UIViewController {
    
    @IBOutlet weak var labelHeader:UILabel!
    @IBOutlet weak var buttonOK:UIButton!
    @IBOutlet weak var buttonCancel:UIButton!
    @IBOutlet weak var switchName:UISwitch!
    @IBOutlet weak var switchEmail:UISwitch!
    @IBOutlet weak var switchAddress:UISwitch!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
 
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        setScreen()
    }
    
    func setScreen() {
        labelHeader.text = "Annatko sovellukselle \(extAuthManager!.callingAppName) seuraavat tiedot?"
    }
    
    @IBAction func buttonPressedOK(sender:UIButton!) {
        //Demoon kovakoodattu, oikeasti luetaan extAuthManagerin storesta
        var name:String? = nil
        if switchName.on {
            name = "Ilkka"
        }
        var email:String? = nil
        if switchEmail.on {
            email = "ilkka.pirttimaa@gmail.com"
        }
        
        if extAuthManager!.returnToCallingApp(true,name:name,email:email,address: nil) {
            extAuthManager!.callingAppCallback = "" //Reset
            self.dismissViewControllerAnimated(false, completion: nil)
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


}
