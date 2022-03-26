//
//  AuthenticateVC.swift
//  Authenticate Using Email
//
//  Created by Yasser Al-ShaFei on 26/03/2022.
//

import UIKit
import Firebase



class AuthenticateVC: UIViewController {

    @IBOutlet weak var lblStatus: UILabel!
    @IBOutlet weak var lblEmail: UILabel!
    @IBOutlet weak var emailTF: UITextField!
    @IBOutlet weak var passwordTF: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard let user = Auth.auth().currentUser else {
            return self.SignIn(Auth.auth())
        }
        print("==> Hi Your email is: \(user.email!)")
        
        user.reload { error in
            switch user.isEmailVerified {
            case true:
                print("==> user email is verified")
            case false:
                user.sendEmailVerification { error in
                    guard let error = error else {
                        return print("==> User Email Verification sent")
                    }
                    self.handleError(error: error)
                }
                print("==> verify it now")
            }
        }
        
    }
    
    
    
    @IBAction func SignIn(_ sender: Any) {
        var email = emailTF.text!
        var password = passwordTF.text!
        
        Auth.auth().signIn(withEmail: email, password: password) { [weak self] user, error in
            guard let strongSelf = self else { return }
            if error != nil {
                strongSelf.lblStatus.text = "Error, check username and password"
                print(error)
                return
            }
            strongSelf.lblStatus.text = "Login sucess for email:"
            strongSelf.lblEmail.text = email
        }
    }
    
    @IBAction func SignUp(_ sender: Any) {
        var email = emailTF.text!
        var password = passwordTF.text!
        
        Auth.auth().createUser(withEmail: email, password: password) { [self] authResult, error in
            if error != nil {
                lblStatus.text = "Error"
                lblEmail.text = ""
                print(error)
                return
            }
            lblStatus.text = "User Created"
            lblEmail.text = email
            
            
            guard let user = Auth.auth().currentUser else {
                return self.SignIn(Auth.auth())
            }
            switch user.isEmailVerified {
            case true:
                print("==> user email is verified")
            case false:
                user.sendEmailVerification { error in
                    guard let error = error else {
                        return print("==> User Email Verification sent")
                    }
                    self.handleError(error: error)
                }
                print("==> verify it now")
            }
        }
    }
    
    func handleError(error: Error) {
        let errorAuthStatus = AuthErrorCode.init(rawValue: error._code)
        switch errorAuthStatus {
        case .weakPassword:
            print("wrong Password")
        case .invalidEmail:
            print("Invalid Email")
        case .operationNotAllowed:
            print("Operation Not Allowed")
        case .userDisabled:
            print("User disabled")
        case .userNotFound:
            print("User Not Found")
            self.SignUp(Auth.auth())
        case .tooManyRequests:
            print("Too Many Requests, oooops")
        default: fatalError("error not supported here")
        }
    }
}
