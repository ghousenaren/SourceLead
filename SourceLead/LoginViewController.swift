//
//  LoginViewController.swift
//  SourceLead
//
//  Created by BIS on 6/1/17.
//  Copyright © 2017 BIS. All rights reserved.
//

import UIKit
import Google
import GoogleSignIn
//import WebServices

class LoginViewController: UIViewController,GIDSignInUIDelegate, GIDSignInDelegate{

    

    @IBOutlet weak var userIdTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var txtImgView: UIImageView!
    @IBOutlet weak var passImgView: UIImageView!

    @IBAction func loginAction(_ sender: Any) {
      loginAPI()
        /*guard (userIdTextField.text?.characters.count)!>2 else {
            showAlertMessage(message: "Username can't be empty")
            return
        }
        guard (passwordTextField.text?.characters.count)!>2 else {
            showAlertMessage(message: "Password can't be empty")
            return
        }*/
       //loginAPI()
    }
   
    
    @IBAction func forgotPasswordClick(_ sender: Any) {
        
        
    }
    @IBAction func signUpClick(_ sender: Any) {
        
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        userIdTextField.textFieldLeftImage(imageNamed:"user.png")
        passwordTextField.textFieldLeftImage(imageNamed:"pass.png")
        
        var error : NSError?
        
        //setting the error
        GGLContext.sharedInstance().configureWithError(&error)
        
        //if any error stop execution and print error
        if error != nil{
            print(error ?? "google error")
            return
        }
    }
    
//when the signin complets
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        
        //if any error stop and print the error
        if error != nil{
            print(error ?? "google error")
            return
        }
        
        //if success display the email on label
        print(user.profile.email);
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
    
    @IBAction func backToLoginScreen(segue : UIStoryboardSegue) {
    
    
    }
    
    @IBAction func btnGoogleLoginPressed(sender: AnyObject) {
        GIDSignIn.sharedInstance().uiDelegate = self
        GIDSignIn.sharedInstance().delegate = self
        GIDSignIn.sharedInstance().signIn()
    }
}

extension LoginViewController {
    func loginAPI() {
        let parameter : [String : String] = [
            "username" : userIdTextField.text!,
            "password":passwordTextField.text!
            ]
        let url = BASE_URL +  "restAuthenticate"
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
                if let token = result["loginResponse"] as? String, token == "token" {
                    
                    UserDefaults.standard.setValue(token, forKey: "TOKEN")
                    self?.performSegue(withIdentifier: "logintodashboard", sender: nil)

                    
//                    let homeVC = UIStoryboard(name: "Main", bundle:nil).instantiateViewController(withIdentifier: "DashboardViewController") as! DashboardViewController
//                    
//                    let appDelegate = (UIApplication.shared.delegate as! AppDelegate)
//                    DispatchQueue.main.async{
//                        appDelegate.window?.rootViewController = homeVC
//                    }

                }else {
                    self?.showAlertMessage(title : "Problem" , message: "Email is not register with us.")
                }
            }else {
                self?.showAlertMessage(title : "Problem" , message: "Issue in API Response.")
            }
            }, failureHandler: { response, error in
                //print("ERROR IS : \(error)")
        })
    }}


/*extension LoginViewController {
    func loginAPI()  {
        var config                              :URLSessionConfiguration!
        var urlSession                          :URLSession!
 
        config = URLSessionConfiguration.default
        urlSession = URLSession(configuration: config)
 
        let HTTPHeaderField_ContentType         = "Content-Type"
        let ContentType_ApplicationJson         = "application/json"
        let HTTPMethod_POST                     = "POST"
 
        let callURL = URL.init(string: "https://reqres.in/api/login")
        var request = URLRequest.init(url: callURL!)
        request.timeoutInterval = 60.0 // TimeoutInterval in Second
        request.cachePolicy = URLRequest.CachePolicy.reloadIgnoringLocalCacheData
        request.addValue(ContentType_ApplicationJson, forHTTPHeaderField: HTTPHeaderField_ContentType)
        request.httpMethod = HTTPMethod_POST
        let parameter : [String : String] = [
            "email" : userIdTextField.text!,
            "password" : passwordTextField.text!
        ]
 
        do {
            let data = try JSONSerialization.data(withJSONObject:parameter, options:[])
            let dataString = String(data: data, encoding: String.Encoding.utf8)!
            print(dataString)
            request.httpBody = data
            // do other stuff on success
            
        } catch {
            print("JSON serialization failed:  \(error)")
            showAlertMessage(message: "Error in sending data")
            return
        }
        
        let dataTask = urlSession.dataTask(with: request) { (data,response,error) in
            if error != nil{
                return
            }
            do {
                let resultJson = try JSONSerialization.jsonObject(with: data!, options: []) as? [String : AnyObject] //Array<Dictionary<String, String>>
                print(resultJson!)
                guard let token = resultJson?["token"] else {
                    self.showAlertMessage(message: "Sorry Token not available")
                    return
                }
                UserDefaults.standard.setValue(token, forKey: "TOKEN")
                
                let homeVC = UIStoryboard(name: "Main", bundle:nil).instantiateViewController(withIdentifier: "welcome")
                
                let appDelegate = (UIApplication.shared.delegate)
                DispatchQueue.main.async{
                    appDelegate?.window??.rootViewController = homeVC
                }
                
            } catch {
                print("Error -> \(error)")
            }
        }
        dataTask.resume()
    }
    
    

}*/
//validatinCode
//func tappedSubmitButton() {
//    guard let name = nameField.text, isValid(name) else {
//        show("name failed validation")
//        return
//    }
//    
//    submit(name)
//}
//
//func isValid(name: String) -> Bool {
//    // check the name is between 4 and 16 characters
//    if !(4...16 ~= name.characters.count) {
//        return false
//    }
//    
//    // check that name doesn't contain whitespace or newline characters
//    let range = name.rangeOfCharacterFromSet(.whitespaceAndNewlineCharacterSet())
//    if let range = range, range.startIndex != range.endIndex {
//        return false
//    }
//    
//    return true
//}
