//
//  SplashScreenViewController.swift
//  Briq
//
//  Created by Apple on 07/04/2017.
//  Copyright © 2017 Strathmore. All rights reserved.
//

import UIKit

class SplashScreenViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let isUserLoggedIn = UserDefaults.standard.bool(forKey: "isUserLoggedIn");
        
        if(isUserLoggedIn == true){
            
            let user_type = UserDefaults.standard.string(forKey: "user_type");
            print("user_type_found \(user_type!)")
            if(user_type! == "farmer"){
               
                perform(#selector(SplashScreenViewController.showFarmer), with: nil, afterDelay: 1)
                
            }else{
                
                perform(#selector(SplashScreenViewController.showIndustry), with: nil, afterDelay: 1)
                
            }
           
          
        
        }
        else{
            perform(#selector(SplashScreenViewController.showLoginBar), with: nil, afterDelay: 1)
        }
               
    }
    
   
    func showIndustry(){
        performSegue(withIdentifier: "showIndustry", sender: self)
    }
    
    func showFarmer(){
        performSegue(withIdentifier: "showFarmer", sender: self)
    }
    
    func showLoginBar(){
        performSegue(withIdentifier: "showSignIn", sender: self)
    }
    


}
