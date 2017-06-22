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

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @IBAction func getPassword(_ sender: Any) {
        guard (email.text?.characters.count)!>2 else {
            showAlertMessage(message: "Email can't be empty")
            return
        }
        let valid = isValidEmail(testStr: email.text!)
        if (valid){
            
        }
        else{
            showAlertMessage(message: "email not valid")
            return
            
        }

        
        forGotAPI()
    }
    func isValidEmail(testStr:String) -> Bool {
        let emailRegEx = "^(?:(?:(?:(?: )*(?:(?:(?:\\t| )*\\r\\n)?(?:\\t| )+))+(?: )*)|(?: )+)?(?:(?:(?:[-A-Za-z0-9!#$%&’*+/=?^_'{|}~]+(?:\\.[-A-Za-z0-9!#$%&’*+/=?^_'{|}~]+)*)|(?:\"(?:(?:(?:(?: )*(?:(?:[!#-Z^-~]|\\[|\\])|(?:\\\\(?:\\t|[ -~]))))+(?: )*)|(?: )+)\"))(?:@)(?:(?:(?:[A-Za-z0-9](?:[-A-Za-z0-9]{0,61}[A-Za-z0-9])?)(?:\\.[A-Za-z0-9](?:[-A-Za-z0-9]{0,61}[A-Za-z0-9])?)*)|(?:\\[(?:(?:(?:(?:(?:[0-9]|(?:[1-9][0-9])|(?:1[0-9][0-9])|(?:2[0-4][0-9])|(?:25[0-5]))\\.){3}(?:[0-9]|(?:[1-9][0-9])|(?:1[0-9][0-9])|(?:2[0-4][0-9])|(?:25[0-5]))))|(?:(?:(?: )*[!-Z^-~])*(?: )*)|(?:[Vv][0-9A-Fa-f]+\\.[-A-Za-z0-9._~!$&'()*+,;=:]+))\\])))(?:(?:(?:(?: )*(?:(?:(?:\\t| )*\\r\\n)?(?:\\t| )+))+(?: )*)|(?: )+)?$"
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        let result = emailTest.evaluate(with: testStr)
        return result
    }

    
    func showAlertMessage(message : String) -> Void {
        let alert = UIAlertController(title: "SourceLead", message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Ok", style: .default, handler: nil)
        alert.addAction(okAction)
        DispatchQueue.main.async{ [weak self] in
            
            
            if self?.presentedViewController == nil {
                self?.present(alert, animated: true, completion: nil)
            }
            else {
                self?.dismiss(animated: false, completion: nil)
                // self?.present(alert, animated: true, completion: nil)
                self?.present(alert, animated: true, completion: nil)
            }
        }
    }
   
}

extension ForgotViewController {

    func forGotAPI() {
        //let jsonPostString = "email:" + email.text!
        //let jsonData = jsonPostString.data(using: String.Encoding.utf8)
        
        /*let parameter : [String : String] = [
            "email" : email.text!,
        ]
        */
        let parameter : [String : String] = [
            "name": "morpheus",
            "job": "leader"
        ]
        let url = "https://reqres.in/api/users" // BASE_URL +  "resetPasswordWithUserName"

        /*do {
            let data = try JSONSerialization.data(withJSONObject:parameter, options:[])
            let dataString = String(data: data, encoding: String.Encoding.utf8)!
            print(dataString)
            WebServices.sharedInstance.makeAPICall(url: url, httpBody: data) { (resultJson) in
                print(resultJson)
                let dict = WebServices.sharedInstance.convertToDictionary(text : resultJson)
                print(dict)
            }
        } catch {
            print("JSON serialization failed:  \(error)")
            showAlertMessage(message: "Error in sending data")
            return
        }*/
        
        var data : Data
        do {
            data = try JSONSerialization.data(withJSONObject:parameter, options:[])
            
        }catch {
            print("JSON serialization failed:  \(error)")
            showAlertMessage(message: "Error in sending data")
            return
        }
        let headers : [String : AnyObject] = ["Content-Type" : "application/json" as AnyObject]
        WebServices.sharedInstance.performApiCallWithURLString(urlString: url, methodName: "POST", headers: headers, parameters: nil, httpBody: data, withMessage: "Reseting Password...", alertMessage: "Please check your device settings to ensure you have a working internet connection.", fromView: self.view, successHandler:  { json, response in
            //print("JSON IS : \(json)")
            //if response?.statusCode == 200 {
                if let result = json as? Dictionary<String , String> {
                    print(result)
                }
           // }
            
        }, failureHandler: { response, error in
            print("ERROR IS : \(error)")
        })
    }


}
/*
extension ForgotViewController {
    func convertToDictionary(from text: String) throws -> [String: String] {
        guard let data = text.data(using: .utf8) else { return [:] }
        let anyResult: Any = try JSONSerialization.jsonObject(with: data, options: [])
        return anyResult as? [String: String] ?? [:]
    }
    
   func forGotAPI()  {
//      var config                              :URLSessionConfiguration!
//        var urlSession                          :URLSession!
//        
//        config = URLSessionConfiguration.default
//        urlSession = URLSession(configuration: config)
//        
//        let HTTPHeaderField_ContentType         = "Content-Type"
//        //let ContentType_ApplicationJson         = "application/json"
//        let ContentType_ApplicationJson         = "application/json"
//        let HTTPMethod_POST                     = "POST"
//
//        let callURL = URL.init(string: "http://192.168.1.48:8080/sourcelead/resetPasswordWithUserName")
//        var request = URLRequest.init(url: callURL!)
//        request.timeoutInterval = 60.0 // TimeoutInterval in Second
//        request.cachePolicy = URLRequest.CachePolicy.reloadIgnoringLocalCacheData
//        request.addValue(ContentType_ApplicationJson, forHTTPHeaderField: HTTPHeaderField_ContentType)
//        request.httpMethod = HTTPMethod_POST
//     let parameter :[String : String] = ["email" : email.text!]
//    
//        do {
//            let data = try JSONSerialization.data(withJSONObject:parameter, options:[])
//            let dataString = String(data: data, encoding: String.Encoding.utf8)!
//            print(dataString)
//            request.httpBody = data
//            // do other stuff on success
//            
//        } catch {
//            print("JSON serialization failed:  \(error)")
//            showAlertMessage(message: "Error in sending data")
//            return
//        }
//
//        let dataTask = urlSession.dataTask(with: request) { (data,response,error) in
//            if error != nil{
//                return
//            }
//            
//            do {
//                var error: NSError?
//                if let JSONData = data { // Check 1.
//                    if let JSONDictionary = JSONSerialization.JSONObjectWithData(JSONData, options: nil, error: &error) as? NSDictionary { // Check 2. and 3.
//                        print("Dictionary received")
//                    }
//                    else {
//                        
//                        if let jsonString = NSString(data: JSONData, encoding: NSUTF8StringEncoding) {
//                            print("JSON: \n\n \(jsonString)")
//                        }
//                        fatalError("Can't parse JSON \(error)")
//                    }
//                }
//                else {
//                    fatalError("JSONData is nil")
//                }
//                }catch {
//                print("Error -> \(error)")
//                
//            }
//        }
//        dataTask.resume()
//    
//}

    
       //------------------------
    
    let request = NSMutableURLRequest(url: NSURL(string: "http://192.168.1.48:8080/sourcelead/resetPasswordWithUserName")! as URL)
    request.httpMethod = "POST"
    let name:String=email.text!;
    let postString = name
    print(postString)
    //    "email":naresh.bolisetty@businessintelli.com

    
    request.httpBody = postString.data(using: String.Encoding.utf8)
    let task = URLSession.shared.dataTask(with: request as URLRequest){data, response, error in
        guard error == nil && data != nil else{
            print("error")
            return
        }
        if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode != 200{
            print("statusCode should be 200, but is \(httpStatus.statusCode)")
            print("response = \(String(describing: response))")
        }
       let responseString = String(data: data!, encoding: String.Encoding.utf8)
//        
//        if let unwrapped = responseString {
//            print("responseStringNAAAAAAAAAAAAA = \(String(describing: unwrapped))")
//            if unwrapped=="Invalid" {
//                self.showAlertMessage(message: "email Invalid")
//                return
//                
//            }
//            else {
//                
//            }
//        }
        
        
        var dictonary:NSDictionary?
        
        if let data = responseString?.data(using: String.Encoding.utf8) {
            
//            do {
//                dictonary =  try JSONSerialization.jsonObject(with: data, options: []) as? [String:AnyObject]! as! NSDictionary
//                
//                if let myDictionary = dictonary
//                {
//                    print(" First name is: \(myDictionary["status"]!)")
//                }
//            }
        
        
//        
//        if let data = responseString?.replacingOccurrences(of: "\n", with: "\\n").data(using: String.Encoding.utf8) {
//            do {
//                let a = try JSONSerialization.jsonObject(with: data, options: .mutableLeaves) as? [String: Any]
//                print("check \(String(describing: a))")
//            } catch {
//                print("ERROR \(error.localizedDescription)")
//            }
//        }
//        let dic = convertToDictionary(text: responseString!)
//        print(dic)
        
      //  if let data1 = data?.data?(using: String.Encoding.utf8) {
         catch {
            print(error)
        }
        }
    
    task.resume()
    }
    
}
}*/
