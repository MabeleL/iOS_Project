//
//  FarmerViewController.swift
//  Briq
//
//  Created by Apple on 07/04/2017.
//  Copyright © 2017 Strathmore. All rights reserved.
//

import UIKit
import Alamofire
import RappleProgressHUD

class FarmerViewController: UIViewController,UITextFieldDelegate,UIPickerViewDelegate,UIPickerViewDataSource {

    @IBOutlet weak var txtName: UITextField!
    
    @IBOutlet weak var txtWeight: UITextField!
    @IBOutlet weak var txtPrice: UITextField!
    @IBOutlet weak var txtLocation: UITextField!
    
    @IBOutlet weak var dropDown: UIPickerView!
    
    var productNames: [String] = ["Saw Dust","Coffee Husks","Macadamia Seeds"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let backItem = UIBarButtonItem(title: "Logout", style: .plain, target: self, action: #selector(FarmerViewController.logout))
        backItem.tintColor = UIColor.red
        self.navigationItem.rightBarButtonItem = backItem
        
    }
    
    func logout(){
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "LogoutViewController")
        self.navigationController?.viewControllers = [vc!]
    }
   
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.txtWeight.endEditing(true)
        self.txtPrice.endEditing(true)
        self.txtLocation.endEditing(true)
    }
    
    @IBAction func btnSubmit(_ sender: UIButton) {
        self.view.endEditing(true)
        
        let defaults = UserDefaults.standard
        let myUsername = defaults.string(forKey: "username")
        
        let userWeight = txtWeight.text;
        let userPrice = txtPrice.text;
        let userLocation = txtLocation.text;
        let myProduct = txtName.text;
        
        if((userWeight?.isEmpty)! || (userPrice?.isEmpty)! || (userLocation?.isEmpty)! || (myProduct?.isEmpty)!){
            LoadingBarViewController.displayMyAlertMessage(targetVC: self,userMessage: "Please fill all fields");
        }
        else if(Reachability.isConnectedToNetwork() == false){
            DispatchQueue.main.async {
                LoadingBarViewController.displayMyAlertMessage(targetVC: self,userMessage: "No internet Connection")
                
            }
        }
        else{
         let myParameters = ["username": "\(myUsername!)", "weight": userWeight!, "price": userPrice!, "location": userLocation!]
            DispatchQueue.main.async {
                RappleActivityIndicatorView.startAnimatingWithLabel("Loading...", attributes: RappleModernAttributes)
            }
            request("\(URL_BASE)/save_product.php", method: .get, parameters: myParameters).responseJSON { response in
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
                        LoadingBarViewController.displayMyAlertMessage(targetVC: self,userMessage: "Data saved!")
                        self.txtWeight.text = ""
                        self.txtPrice.text = ""
                        self.txtLocation.text = ""
                    }
                    
                }
                else{
                    DispatchQueue.main.async {
                        LoadingBarViewController.displayMyAlertMessage(targetVC: self,userMessage: "Sorry data not saved")
                        self.txtWeight.text = ""
                        self.txtPrice.text = ""
                        self.txtLocation.text = ""
                    }
                    
                }
                
                
            }
        }
    
    }
    
    
    
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return productNames.count
        
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        self.view.endEditing(true)
        return productNames[row]
    }
    
    
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        self.txtName.text = self.productNames[row]
        self.dropDown.isHidden = true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        self.txtName.endEditing(true)
        if(textField == self.txtName){
            self.txtName.endEditing(true)
            self.dropDown.isHidden = false
        }
    }
    
    
    
    

}
