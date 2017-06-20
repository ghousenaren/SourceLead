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


    @IBAction func btnClick(_ sender: Any) {
        isChecked = !isChecked
        if isChecked {
            recBtn.setTitle("testimage2", for: .normal)
            profBtn.setTitle("testimage", for: .normal)
            profBtn.setTitleColor(.blue, for: .normal)
            isChecked = false
        } else {
            profBtn.setTitle("testimage1", for: .normal)
            recBtn.setTitle("testimage2", for: .normal)
            recBtn.setTitleColor(.white, for: .normal)
            isChecked = true

        }

    }
    
    @IBOutlet weak var profBtn: UIButton!
    @IBOutlet weak var recBtn: UIButton!
    @IBOutlet weak var firstName: UITextField!
    @IBOutlet weak var lastName: UITextField!
    
    @IBOutlet weak var email: UITextField!
    
    @IBAction func goSignIn(_ sender: Any) {
     //let myVC = storyboard?.instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController
//        navigationController?.pushViewController(myVC, animated: true)
        self.navigationController?.popViewController(animated: true)
     }
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    @IBAction func signUp(_ sender: Any) {
        
        guard (firstName.text?.characters.count)!>2 else {
            showAlertMessage(message: "FirstName can't be empty")
            return
        }
        guard
         (lastName.text?.characters.count)!>2 else{
            showAlertMessage(message: "LastName can't be empty")
            
            return
        }
        if (email.text?.isEmpty)!
        {
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
