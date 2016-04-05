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

    @IBOutlet weak var labelHeader:UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        extAuthManager = ExtAuthManager.init()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        if extAuthManager!.callingAppCallback=="" {
            //Launch config
            labelHeader.text = ""
        }
        else {
            labelHeader.text = "Kirjaudu sovellukseen \(extAuthManager!.callingAppName)"
        }
    }

    @IBAction func buttonPressedOK(sender:UIButton!) {
    }
    
    @IBAction func buttonPressedCancel(sender:UIButton!) {
    }

}

