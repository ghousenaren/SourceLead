//
//  ResetPasswordViewController.swift
//  SourceLead
//
//  Created by BIS on 6/9/17.
//  Copyright © 2017 BIS. All rights reserved.
//

import UIKit

class ResetPasswordViewController: UIViewController {

    @IBOutlet weak var validationCode: UITextField!
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var conformPassword: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    func showAlertMessage(title : String, message : String) -> Void {
        DispatchQueue.main.async{ [weak self] in
            let alert = Global.showAlertWithTitle(title: title, okTitle: "Ok", cancelTitle: "", message: message, isCancel: false, okHandler: {action in
                
                return
            })
            self?.present(alert, animated: true, completion: nil)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @IBAction func save(_ sender: Any) {
        
        if isPasswordSame(password: password.text!, confirmPassword: conformPassword.text!) {
            resetPasswordAPI()
            
        
        }
        else{
            self.showAlertMessage(title : "Fail" , message: "Password and Conform Password Should be Same.")
        }
        
        
    }
    func isPasswordSame(password: String , confirmPassword : String) -> Bool {
        if password == confirmPassword{
            return true
        }else{
            
            return false
        }
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    func resetPasswordAPI() {
        let parameter : [String : String] = [
            "password" : password.text!,
            "verificationCode":validationCode.text!
            ]
        let url = BASE_URL +  "verifyResetPassword"
        var data : Data
        do {
            data = try JSONSerialization.data(withJSONObject:parameter, options:[])
            
        }catch {
            print("JSON serialization failed:  \(error)")
            showAlertMessage(title: "Error", message: "Error in sending data")
            return
        }
        let headers : [String : AnyObject] = ["Content-Type" : "application/json" as AnyObject]
        WebServices.sharedInstance.performApiCallWithURLString(urlString: url, methodName: "POST", headers: headers, parameters: nil, httpBody: data, withMessage: "Reseting Password...", alertMessage: "Please check your device settings to ensure you have a working internet connection.", fromView: self.view, successHandler:  {[weak self] json, response in
            if let result = json as? Dictionary<String , AnyObject> {
                print(result)
                if let resultStatus = result["resetResponse"] as? String, resultStatus == "login" {
                    self?.performSegue(withIdentifier: "loginSegue", sender: nil)
                }else {
                    self?.showAlertMessage(title : "Problem" , message: "CheckwithCode")
                }
            }else {
                self?.showAlertMessage(title : "Problem" , message: "Issue in API Response.")
            }
            }, failureHandler: { response, error in
                //print("ERROR IS : \(error)")
        })
    }

}
