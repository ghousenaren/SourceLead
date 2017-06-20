//
//  Welcome.swift
//  SourceLead
//
//  Created by BIS on 5/31/17.
//  Copyright © 2017 BIS. All rights reserved.
//

import UIKit

class Welcome: UIViewController {

    @IBOutlet weak var imgGif: UIImageView!
    @IBAction func welcomeSignIn(_ sender: Any) {
    self.performSegue(withIdentifier: "login", sender: self)
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        imgGif.loadGif(name: "firew11")

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

