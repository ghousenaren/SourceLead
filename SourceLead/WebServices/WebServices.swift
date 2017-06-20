//
//  WebServices.swift
//
//  Created by Koti on 6/7/16.
//  Copyright © 2016 V-Soft. All rights reserved.
//

 import Foundation
import MBProgressHUD
import ReachabilitySwift
import SystemConfiguration

//MARK: - Global Functions - MBProgressHUD
func showProgressHUDWithStatus(status: String) {
    
   // DispatchQueue.main.async {
        guard let window = UIApplication.shared.delegate!.window else {
            return
        }
        MBProgressHUD.showAdded(to: window!, animated: true)
        MBProgressHUD.init(for: window!)!.label.text = status
        MBProgressHUD.init(for: window!)!.bezelView.color = UIColor.lightGray
        MBProgressHUD.init(for: window!)!.backgroundColor = UIColor.lightGray.withAlphaComponent(0.2)
        MBProgressHUD.init(for: window!)!.areDefaultMotionEffectsEnabled = false
   // }
}

func hideProgressHUD() {
    guard let window = UIApplication.shared.delegate!.window else {
        return
    }
   // DispatchQueue.main.async {
        MBProgressHUD.hide(for: window!, animated: true)
   // }
}

class WebServices {

    static let sharedInstance = WebServices()
    
    func performApiCallWithURLString(urlString: String, methodName method: String, headers: [String : AnyObject]?, parameters: AnyObject?, httpBody: Data?, withMessage message: String?, alertMessage: String?, fromView: UIView?, successHandler:@escaping (AnyObject?, HTTPURLResponse?) -> Void, failureHandler:@escaping (HTTPURLResponse?, NSError?) -> Void) {
        
        if !isInternetAvailable() {
            DispatchQueue.main.async {
                hideProgressHUD()
            }
             NotificationCenter.default.post(name: NSNotification.Name(rawValue: "NoInternet"), object: alertMessage)
            return
        }
        
        if let message = message, let _ = fromView {
            showProgressHUDWithStatus(status: message)
        }
//        let config = URLSessionConfiguration.default
        let config = URLSessionConfiguration.ephemeral
        if let headers = headers {
            config.httpAdditionalHeaders = headers
        }
        let session = URLSession(configuration: config)
        var url: NSURL?
         url = NSURL(string: urlString)
        let request = NSMutableURLRequest(url: url! as URL, cachePolicy: .reloadIgnoringLocalCacheData, timeoutInterval: 60.0)
        request.httpMethod = method
        if let httpBody = httpBody {
            request.httpBody = httpBody as Data//httpBody.dataUsingEncoding(NSUTF8StringEncoding)
        }
        
        if let parameters = parameters {
            do {
                let json = try JSONSerialization.data(withJSONObject: parameters, options: .prettyPrinted)
                request.httpBody = json
            } catch {
                
            }
        }
        
        session.dataTask(with: request as URLRequest, completionHandler: {
            ( data, response, error) in
            print("Error is : \(error?.localizedDescription)")
            DispatchQueue.main.async {
                if let _ = fromView {
                    hideProgressHUD()
                }
                if let alertBody = error?.localizedDescription{
                    NotificationCenter.default.post(name: NSNotification.Name(rawValue: "NoInternet"), object: alertBody)
                }

                if let httpResponse = response as? HTTPURLResponse {
                    guard error == nil else {
                        failureHandler(httpResponse, error as NSError?)
                        return
                    }
                    do {
                        let json = try JSONSerialization.jsonObject(with: data!, options: .allowFragments)
                        successHandler(json as AnyObject?, httpResponse)
                    } catch let error as NSError  {
                        print("Could not save \(error), \(error.userInfo)")
                        successHandler(nil, httpResponse)
                    }
                }
              }
            }).resume()
    }

    //helper method to check for network reachabilty.
    func isInternetAvailable() -> Bool
    {
        var zeroAddress = sockaddr_in()
        zeroAddress.sin_len = UInt8(MemoryLayout.size(ofValue: zeroAddress))
        zeroAddress.sin_family = sa_family_t(AF_INET)
        
        let defaultRouteReachability = withUnsafePointer(to: &zeroAddress) {
            $0.withMemoryRebound(to: sockaddr.self, capacity: 1) {zeroSockAddress in
                SCNetworkReachabilityCreateWithAddress(nil, zeroSockAddress)
            }
        }
        
        var flags = SCNetworkReachabilityFlags()
        if !SCNetworkReachabilityGetFlags(defaultRouteReachability!, &flags) {
            return false
        }
        let isReachable = (flags.rawValue & UInt32(kSCNetworkFlagsReachable)) != 0
        let needsConnection = (flags.rawValue & UInt32(kSCNetworkFlagsConnectionRequired)) != 0
        return (isReachable && !needsConnection)
    }
    
    func checkForReachability() -> Bool {
        var isReachable: Bool = false
        var value : String?
        let reachability = Reachability()
        value = reachability?.currentReachabilityStatus.description ?? "nil"
        if value == "No Connection" {
            isReachable = false
        } else {
            isReachable = true
        }
        return isReachable
    }

}

