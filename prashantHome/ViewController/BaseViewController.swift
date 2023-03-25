//
//  BaseViewController.swift
//  prashantHome
//
//  Created by Prashant Prajapati on 25/03/23.
//
import UIKit
import KRProgressHUD

protocol BaseViewControllerProtocol {
    func createViewModelBinding()
    func createCallbacks()
}

class BaseViewController: UIViewController {
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    func showSnackbar(_ message : String) {
        
    }
    
    func showHud(message : String = "Please wait...")  {
        KRProgressHUD.set(style: .custom(background: .black, text: .white, icon: nil)).show(withMessage: message)
    }
    
    func hideHud() {
        KRProgressHUD.dismiss()
    }
}
