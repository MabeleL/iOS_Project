//
//  FarmerDetailsViewController.swift
//  Briq
//
//  Created by Apple on 07/04/2017.
//  Copyright © 2017 Strathmore. All rights reserved.
//

import UIKit
import Alamofire
import RappleProgressHUD
import Social

class FarmerDetailsViewController: UIViewController {
    @IBOutlet weak var txtName: UILabel!
    @IBOutlet weak var txtPhone: UILabel!
    @IBOutlet weak var txtWeight: UILabel!
    @IBOutlet weak var txtPrice: UILabel!
    @IBOutlet weak var txtLocation: UILabel!
    
      var name:String?
      var phone:String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let backItem = UIBarButtonItem(title: "Logout", style: .plain, target: self, action: #selector(FarmerDetailsViewController.logout))
        backItem.tintColor = UIColor.red
        self.navigationItem.rightBarButtonItem = backItem
        
        txtName.text = name
        txtPhone.text = phone
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if(Reachability.isConnectedToNetwork() == false){
            DispatchQueue.main.async {
                LoadingBarViewController.displayMyAlertMessage(targetVC: self,userMessage: "No internet Connection")
                
            }
        }
        else{
        loadFarmerDetails()
        }
    }
    
    func logout(){
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "LogoutViewController")
        self.navigationController?.viewControllers = [vc!]
    }

    
    @IBAction func btnOrder(_ sender: UIButton) {
        
    // let newPhone = phone?.replacingOccurrences(of: "+", with: "%2B")
        
    let message = "Hi \(name).I'd like your products"
        if(Reachability.isConnectedToNetwork() == false){
            DispatchQueue.main.async {
                LoadingBarViewController.displayMyAlertMessage(targetVC: self,userMessage: "No internet Connection")
                
            }
        }
        else{
            let myParameters = ["phoneNumber": "\(phone!)", "text": message]
            DispatchQueue.main.async {
                RappleActivityIndicatorView.startAnimatingWithLabel("Loading...", attributes: RappleModernAttributes)
            }
            request("\(URL_BASE)/sms.php", method: .get, parameters: myParameters).responseJSON { response in
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
                    DispatchQueue.main.async {
                        LoadingBarViewController.displayMyAlertMessage(targetVC: self,userMessage: "Ordered successfully")
                    }
                    
                }else{
                    DispatchQueue.main.async {
                        LoadingBarViewController.displayMyAlertMessage(targetVC: self,userMessage: "Ordering failed")
                    }
                    
                }
                
                
            }
        }

    
    }
    
    
    
    func loadFarmerDetails(){
      
         let myParameters = ["username": "\(name!)"]
        
        DispatchQueue.main.async {
            RappleActivityIndicatorView.startAnimatingWithLabel("Loading...", attributes: RappleModernAttributes)
        }
        request("\(URL_BASE)/get_products.php", method: .get, parameters: myParameters).responseJSON { response in
            DispatchQueue.main.async {
                RappleActivityIndicatorView.stopAnimating()
            }
            
           print("get_products_response \(response.result.value!)")
            guard let json = response.result.value as? [String: AnyObject] else {
                print("didn't get todo object as JSON from API")
                print("Error: \(response.result.error!)")
                return
            }
           
           if let Userweight = json["weight"] as? String {
                self.txtWeight.text = "\(Userweight) Kg"
            }
           
            if let Userlocation = json["location"] as? String {
                self.txtLocation.text = Userlocation
            }
            if let Userprice = json["price"] as? String {
                self.txtPrice.text = "KSH \(Userprice)"
            }
            
        }
        
        
        
    }
    
    
    @IBAction func btnShare(_ sender: UIButton) {
   
       //Alert
        let alert = UIAlertController(title: "Share", message:
            "Share the farmer information!", preferredStyle: .actionSheet)
       //first action
        let actionOne = UIAlertAction(title: "Share on Facebook", style: .default){ (action) in
           
            //chcking if user is connected to facebook
            if SLComposeViewController.isAvailable(forServiceType: SLServiceTypeFacebook){
                
                let post = SLComposeViewController(forServiceType: SLServiceTypeFacebook)
                post?.setInitialText("Farmer of the day")
                post?.add(UIImage(named: "users"))
                self.present(post!, animated: true, completion:nil)
            }else{
               LoadingBarViewController.displayMyAlertMessage(targetVC: self,userMessage: "You are not connected to Facebook")
            }
        }
        
        //second action
        let actionTwo = UIAlertAction(title: "Share on Twitter", style: .default){ (action) in
            
            //chcking if user is connected to facebook
            if SLComposeViewController.isAvailable(forServiceType: SLServiceTypeTwitter){
                
                let post = SLComposeViewController(forServiceType: SLServiceTypeTwitter)
                post?.setInitialText("Farmer of the day")
                post?.add(UIImage(named: "users"))
                self.present(post!, animated: true, completion:nil)
            }else{
                LoadingBarViewController.displayMyAlertMessage(targetVC: self,userMessage: "You are not connected to Twitter")
            }
        }
        
        let actionThree = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        
        //add action to action sheet
        alert.addAction(actionOne)
         alert.addAction(actionTwo)
        alert.addAction(actionThree)
        //present alert
        self.present(alert, animated: true, completion: nil)
        
    }
    
    
    
    

}
