//
//  SignUpViewController.swift
//  SourceLead
//
//  Created by BIS on 6/1/17.
//  Copyright © 2017 BIS. All rights reserved.
//

import UIKit

class SignUpViewController: UIViewController {
    var isChecked = true
    var signupType = "professional"
    
    @IBOutlet weak var professionalButton: UIButton!
    @IBOutlet weak var recruiterButton: UIButton!
    @IBOutlet weak var firstName: UITextField!
    @IBOutlet weak var lastName: UITextField!
    @IBOutlet weak var email: UITextField!
    
    @IBOutlet weak var countryDrop: DropMenuButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        firstName.textFieldLeftImage(imageNamed:"user.png")
        lastName.textFieldLeftImage(imageNamed:"user.png")
        email.textFieldLeftImage(imageNamed:"mail")
        
        // Do any additional setup after loading the view.
        countryDrop.initMenu(["Australia", "India", "US","ScotLand"], actions: [({ () -> (Void) in
            print("Estou fazendo a ação A")
        }), ({ () -> (Void) in
            print("Estou fazendo a ação B")
        }), ({ () -> (Void) in
            print("Estou fazendo a ação C")
        })])

    }

    @IBAction func signUp(_ sender: Any) {
        
        guard (firstName.text?.characters.count)!>2 else {
            showAlertMessage(message: "FirstName can't be empty")
            return
        }
        guard (lastName.text?.characters.count)!>2 else{
            showAlertMessage(message: "LastName can't be empty")
            
            return
        }
        if (email.text?.isEmpty)!{
            showAlertMessage(message: "Email can't be empty")
        }
        else{
            if (!isValidEmail(testStr: email.text!)){
                showAlertMessage(message: "Inviled Email")
                return
                
             }
          }
    }
    
    func showAlertMessage(message : String) -> Void {
        DispatchQueue.main.async{
            let alert = UIAlertController(title: "SourceLead", message: message, preferredStyle: .alert)
            let okAction = UIAlertAction(title: "Ok", style: .default, handler: nil)
            alert.addAction(okAction)
            self.present(alert, animated: true, completion: nil)

        }
    }

    @IBAction func signUpSwitchButtonAction(_ sender: UIButton) {
        self.professionalButton.setImage(UIImage(named:"deselected_professional"), for: UIControlState.normal)
        self.recruiterButton.setImage(UIImage(named:"deselected_recruiter"), for: UIControlState.normal)
        
        switch sender.tag {
        case 0:
            self.professionalButton.setImage(UIImage(named:"selected_professional"), for: UIControlState.normal)
            signupType = "professional"
        default:
            self.recruiterButton.setImage(UIImage(named:"selected_recruiter"), for: UIControlState.normal)
            signupType = "recruiter"
        }
        
    }

    func isValidEmail(testStr:String) -> Bool {
        // print("validate calendar: \(testStr)")
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: testStr)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    


}
