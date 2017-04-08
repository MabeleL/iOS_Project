//
//  SignUpViewController.swift
//  Briq
//
//  Created by Apple on 07/04/2017.
//  Copyright © 2017 Strathmore. All rights reserved.
//

import UIKit
import Alamofire
import RappleProgressHUD

class SignUpViewController: UIViewController {

    @IBOutlet weak var segmentedUserType: UISegmentedControl!
    
   
    @IBOutlet weak var txtName: UITextField!
    @IBOutlet weak var txtPhone: UITextField!
    @IBOutlet weak var txtUsername: UITextField!
    @IBOutlet weak var txtPassword: UITextField!
    var User_type = "Farmer"
    
     @IBAction func btnRegister(_ sender: UIButton) {
        self.view.endEditing(true)
        let userName = txtUsername.text;
        let userPassword = txtPassword.text;
        let name = txtName.text;
        let userPhone = txtPhone.text;
        
        if((userName?.isEmpty)! || (userPassword?.isEmpty)! || (name?.isEmpty)! || (userPhone?.isEmpty)!){
            LoadingBarViewController.displayMyAlertMessage(targetVC: self,userMessage: "Please fill all fields");
        }
        else if(Reachability.isConnectedToNetwork() == false){
            DispatchQueue.main.async {
                LoadingBarViewController.displayMyAlertMessage(targetVC: self,userMessage: "No internet Connection")
                
            }
        }
        else{
            print("user_type ni \(User_type)")
            let myParameters = ["username": "\(userName!)", "password": userPassword!, "name": name!, "phone": "+254\(userPhone!)", "type": User_type]
            DispatchQueue.main.async {
                RappleActivityIndicatorView.startAnimatingWithLabel("Loading...", attributes: RappleModernAttributes)
            }
            request("\(URL_BASE)/register.php", method: .get, parameters: myParameters).responseJSON { response in
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
                   self.registerAlert()
                }
                else{
                    DispatchQueue.main.async {
                        LoadingBarViewController.displayMyAlertMessage(targetVC: self,userMessage: "Sorry registration failed.Please try again")
                    }
                    
                }
                
                
            }
        }

    }
    
    
    @IBAction func segmentedUserTypeAction(_ sender: UISegmentedControl) {
        switch segmentedUserType.selectedSegmentIndex
        {
        case 0:
            User_type = "Farmer"
            break
        default:
            User_type = "Industry"
            break;
        }
    
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.txtPassword.endEditing(true)
        self.txtUsername.endEditing(true)
        self.txtPhone.endEditing(true)
        self.txtName.endEditing(true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }

 
    
    func registerAlert(){
        // Create the alert controller
        let alertController = UIAlertController(title: "", message: "Registration Successful", preferredStyle: .alert)
        
        // Create the actions
        let okAction = UIAlertAction(title: "Login", style: UIAlertActionStyle.default) {
            UIAlertAction in
            
            let secondViewController = self.storyboard?.instantiateViewController(withIdentifier: "SignInViewController") as! SignInViewController
            self.navigationController?.pushViewController(secondViewController, animated: true)
        }
        // Add the actions
        alertController.addAction(okAction)
        // Present the controller
        self.present(alertController, animated: true, completion: nil)
        
    }

}
