//
//  ViewController.swift
//  SessionSharing
//
//  Created by Noel Achkar on 7/24/19.
//  Copyright © 2019 Noel Achkar. All rights reserved.
//

import UIKit
import SVProgressHUD

class MainViewController: UIViewController {

    private var viewModel = MainViewModel()

    @IBOutlet weak var loginBtn: UIButton!
    @IBOutlet weak var passwordTxt: UITextField!
    @IBOutlet weak var bottomView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
//        passwordTxt.text = "mykimykmykitoken"
        
        setupView()
        handleWebSocket()
    }
    
    func setupView() {
        bottomView.layer.shadowColor = (UIColor.black).cgColor
        bottomView.layer.shadowOffset = CGSize(width: 0, height: 4)
        bottomView.layer.shadowOpacity = 0.5
        
        passwordTxt.attributedPlaceholder = NSAttributedString(string: "Password",
                                                               attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray])
        
        let leftView = UIView.init(frame: CGRect(x:0,y:0,width:1,height:passwordTxt.frame.size.height))
        leftView.backgroundColor = .lightGray
        passwordTxt.leftView = leftView
        passwordTxt.leftViewMode = UITextField.ViewMode.always
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        
        view.addGestureRecognizer(tap)
        
        SVProgressHUD.show(withStatus: "Connecting")
    }
    
    @objc func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }
    
    func handleWebSocket() {
        
        viewModel.updateLoadingStatus = {
            let _ = self.viewModel.isLoading ? SVProgressHUD.show() : SVProgressHUD.dismiss()
        }
        
        viewModel.showAlert = {
            if let error = self.viewModel.error {
                SVProgressHUD.showError(withStatus: error)
            }
        }
        
        viewModel.socketDidConnect = {
            if self.viewModel.connected {
                SVProgressHUD.dismiss()
            } else {
                SVProgressHUD.show(withStatus: "Connecting")
            }
        }
        
        viewModel.didFinishLogin = {
            //Handle Login Data
            let storyboard = UIStoryboard.init(name: "Main", bundle: nil)
            let webVC = storyboard.instantiateViewController(withIdentifier: "WebViewController") as! WebViewController
            webVC.viewModel = WebViewModel(webViewData: self.viewModel.loginData)
            self.present(webVC, animated: true, completion: nil)
        }
    }
    
    @IBAction func loginPressed(_ sender: Any) {
        viewModel.emitLogin(password: passwordTxt.text!)
    }
}

