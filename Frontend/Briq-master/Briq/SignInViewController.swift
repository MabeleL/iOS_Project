//
//  SignInViewController.swift
//  Briq
//
//  Created by Apple on 07/04/2017.
//  Copyright © 2017 Strathmore. All rights reserved.
//

import UIKit
import Alamofire
import RappleProgressHUD

class SignInViewController: UIViewController {

    @IBOutlet weak var txtUsername: UITextField!
    @IBOutlet weak var txtPassword: UITextField!
    
   @IBAction func btnLogin(_ sender: UIButton) {
        
        self.view.endEditing(true)
        let userName = txtUsername.text;
        let userPassword = txtPassword.text;
        
        if((userName?.isEmpty)! || (userPassword?.isEmpty)!){
            LoadingBarViewController.displayMyAlertMessage(targetVC: self,userMessage: "Please fill all fields");
        }
        else if(Reachability.isConnectedToNetwork() == false){
            DispatchQueue.main.async {
                LoadingBarViewController.displayMyAlertMessage(targetVC: self,userMessage: "No internet Connection")
                
            }
        }
        else{
            let myParameters = ["username": "\(userName!)", "password": userPassword!]
            DispatchQueue.main.async {
                RappleActivityIndicatorView.startAnimatingWithLabel("Loading...", attributes: RappleModernAttributes)
            }
            request("\(URL_BASE)/login.php", method: .post, parameters: myParameters).responseJSON { response in
                DispatchQueue.main.async {
                    RappleActivityIndicatorView.stopAnimating()
                }
                // make sure we got some JSON since that's what we expect
                guard let json = response.result.value as? [String: AnyObject] else {
                    print("didn't get todo object as JSON from API")
                    print("Error: \(response.result.error!)")
                    return
                }
                 print(json)
               
                guard let server_response =  json["response"]as? String else{
                    return
                }
                
                if(server_response == "1"){
                    UserDefaults.standard.set(true, forKey: "isUserLoggedIn");
                    UserDefaults.standard.set("farmer", forKey: "user_type");
                    UserDefaults.standard.set(userName!, forKey: "username");
                    UserDefaults.standard.synchronize();
                    let vc = self.storyboard?.instantiateViewController(withIdentifier: "FarmerViewController")
                    self.navigationController?.viewControllers = [vc!]

                    
                }else if(server_response == "2"){
                    UserDefaults.standard.set(true, forKey: "isUserLoggedIn");
                    UserDefaults.standard.set("industry", forKey: "user_type");
                     UserDefaults.standard.set(userName!, forKey: "username");
                    UserDefaults.standard.synchronize();
                    let vc = self.storyboard?.instantiateViewController(withIdentifier: "ViewController")
                    self.navigationController?.viewControllers = [vc!]

                    
                }else{
                    DispatchQueue.main.async {
                        LoadingBarViewController.displayMyAlertMessage(targetVC: self,userMessage: "Wrong credentials")
                    }
                    
                }
                
                
            }
        }
        
        
    }
    
    

    @IBAction func btnRegister(_ sender: UIButton) {
        let secondViewController = self.storyboard?.instantiateViewController(withIdentifier: "SignUpViewController") as! SignUpViewController
        self.navigationController?.pushViewController(secondViewController, animated: true)
    
    }
    
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.txtPassword.endEditing(true)
        self.txtUsername.endEditing(true)
    }

    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

 
    
    
}
