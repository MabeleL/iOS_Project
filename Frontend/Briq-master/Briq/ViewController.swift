//
//  ViewController.swift
//  Briq
//
//  Created by Apple on 07/04/2017.
//  Copyright © 2017 Strathmore. All rights reserved.
//

import UIKit
import Alamofire
import RappleProgressHUD

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var tableView: UITableView!
    var nameArray: [String] = []
    var farmerIDArray: [String] = []
    var phoneArray: [String] = []
    
   
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let backItem = UIBarButtonItem(title: "Logout", style: .plain, target: self, action: #selector(ViewController.logout))
        backItem.tintColor = UIColor.red
        self.navigationItem.rightBarButtonItem = backItem
        
        loadFarmers()
        
    }
    
    func logout(){
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "LogoutViewController")
        self.navigationController?.viewControllers = [vc!]
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        let returnValue = nameArray.count
        
        if(returnValue == 0){
            let emptyLabel = UILabel(frame: CGRect(x: 0, y: 0, width: self.view.bounds.size.width, height: self.view.bounds.size.height))
            emptyLabel.text = "No Farmers Found"
            emptyLabel.textColor = UIColor.black
            emptyLabel.textAlignment = NSTextAlignment.center
            self.tableView.backgroundView = emptyLabel
            self.tableView.separatorStyle = UITableViewCellSeparatorStyle.none
            return 0
        }else{
            return returnValue
            
        }
        
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let Cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! FarmerTableViewCell
        
        Cell.txtFarmerName?.text = "\(nameArray[indexPath.row])"
        Cell.txtNumber?.text = "\(indexPath.row+1)"
        
     
        return Cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
//        let selectedCell:UITableViewCell = tableView.cellForRow(at: indexPath)!
//        selectedCell.contentView.backgroundColor = UIColor(red:0.18, green:0.16, blue:0.16, alpha:1.0)
      
        
                    let secondViewController = self.storyboard?.instantiateViewController(withIdentifier: "FarmerDetailsViewController") as! FarmerDetailsViewController
                    secondViewController.name = nameArray[indexPath.row]
                    secondViewController.phone = phoneArray[indexPath.row]
                    // Take user to SecondViewController
                    self.navigationController?.pushViewController(secondViewController, animated: true)
        
        
    }
    


    func loadFarmers(){
        DispatchQueue.main.async {
            RappleActivityIndicatorView.startAnimatingWithLabel("Loading...", attributes: RappleModernAttributes)
        }
        request("\(URL_BASE)/getfarmers.php", method: .get, parameters: nil).responseJSON { response in
            DispatchQueue.main.async {
                RappleActivityIndicatorView.stopAnimating()
            }
            
            self.clearArrays()
            print("\(response.result.value!)")
            
            
            //month
            guard let farmerData =  response.result.value! as? NSArray else{
                return
            }
            
            if(farmerData.count >= 1){
                
                self.clearArrays()
                self.tableView.backgroundView?.isHidden = true
                for item in farmerData{
                    if let name = (item as AnyObject).value(forKey:"username") as? String {
                        self.nameArray.append(name)
                    }
                    if let phone = (item as AnyObject).value(forKey:"phone") as? String {
                        self.phoneArray.append(phone)
                    }
                 }
                
            }else{
                self.tableView.backgroundView?.isHidden = false
            }

            self.tableView.reloadData()
            
            
        }
        
        
        
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        self.tableView.reloadData()
    }
    
    func clearArrays(){
        nameArray.removeAll()
        farmerIDArray.removeAll()
        phoneArray.removeAll()
    }
    
    

}

