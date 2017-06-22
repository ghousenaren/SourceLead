//
//  ForgotViewController.swift
//  SourceLead
//
//  Created by BIS on 6/1/17.
//  Copyright © 2017 BIS. All rights reserved.
//

import UIKit

class ForgotViewController: UIViewController {

    @IBOutlet weak var email: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    

    @IBAction func getPassword(_ sender: Any) {
        guard (email.text?.characters.count)!>2 else {
            showAlertMessage(title : "Information", message: "Email can't be empty")
            return
        }
        if (!(email.text?.isEmail)!) {
            showAlertMessage(title : "Information" , message: "email not valid")
            return
        }
        forGotAPI()
    }
    
    func showAlertMessage(title : String, message : String) -> Void {
        DispatchQueue.main.async{ [weak self] in
            let alert = Global.showAlertWithTitle(title: title, okTitle: "Ok", cancelTitle: "", message: message, isCancel: false, okHandler: {action in
                if String(describing: message).contains("Will Send you Verification code shortly") {
                    self?.performSegue(withIdentifier: "showResetPasswordSegue", sender: nil)
                }
                return
            })
            self?.present(alert, animated: true, completion: nil)
        }
    }
}
extension ForgotViewController {
    func forGotAPI() {
        let parameter : [String : String] = [
            "email" : email.text!,
        ]
        let url = BASE_URL +  "resetPasswordWithUserName"
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
                    if let resultStatus = result["status"] as? String, resultStatus == "valid" {
                         self?.showAlertMessage(title : "Success" , message: "Will Send you Verification code shortly.")
                    }else {
                        self?.showAlertMessage(title : "Problem" , message: "Email is not register with us.")
                    }
                }else {
                    self?.showAlertMessage(title : "Problem" , message: "Issue in API Response.")
                }
        }, failureHandler: { response, error in
            //print("ERROR IS : \(error)")
        })
    }


}
