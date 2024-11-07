//
//  LoginViewController.swift
//  LiveCam
//
//  Created by Developer 1 on 22/10/2024.
//

import UIKit
import KHJCameraLib


class LoginViewController: UIViewController {

    @IBOutlet weak var textFieldUUID: UITextField!
    
    
    @IBOutlet weak var textFieldPassword: UITextField!
    
    let manager = KHJDeviceManager()
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTapGesture()
    
    }

    
    @IBAction func tapOnConnect(_ sender: Any) {
                guard let uid = textFieldUUID.text, !uid.isEmpty,
                        let password = textFieldPassword.text, !password.isEmpty
                else {
                    print("Vui lòng điền tài khoản, mật khẩu")
                    return
                }
        
        let homeVC = HomeViewController()
            homeVC.uid = uid
            homeVC.pass = password
            homeVC.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(homeVC, animated: true)
    }

    
    func setupTapGesture() {
            let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
            view.addGestureRecognizer(tapGesture)
        }
    @objc func dismissKeyboard() {
            view.endEditing(true)
        }
}


