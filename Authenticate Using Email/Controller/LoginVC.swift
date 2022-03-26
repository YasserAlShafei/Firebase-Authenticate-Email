//
//  ViewController.swift
//  Authenticate Using Email
//
//  Created by Yasser AlShaFei on 3/5/21.
//

import UIKit
import Firebase
import FirebaseAuth




class LoginVC: UIViewController {
    
    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var emailTF: UITextField!
    @IBOutlet weak var passwordTF: UITextField!
    @IBOutlet weak var nameTF: UITextField!
    @IBOutlet weak var buttonSignIn: UIButton!
    @IBOutlet weak var buttonSignUp: UIButton!
    
    var nameU :String = ""
    var emailU :String = ""
    var passwordU :String = ""
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // ..
        passwordTF.isSecureTextEntry = true
        emailTF.autocapitalizationType = .none
        emailTF.leftViewMode = .always
        emailTF.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 5, height: 0))
        passwordTF.leftViewMode = .always
        passwordTF.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 5, height: 0))
        
        nameU = nameTF.text!.description
        emailU = emailTF.text!.description
        passwordU = passwordTF.text!.description
        
        // Check Current User
        if FirebaseAuth.Auth.auth().currentUser != nil {
            //.. do something
        }
        
        //..
        
    }
    
    
    
    
    

    @IBAction func SignInButton(_ sender: Any) {
        //Auth.auth()
        guard let name = nameTF.text, !name.isEmpty,
              let email = emailTF.text, !email.isEmpty,
              let password = passwordTF.text, !password.isEmpty else {
                  createAlert(title: "Error", message: "Missing field data..")
                  return
        }
        
        FirebaseAuth.Auth.auth().signIn(withEmail: email, password: password, completion: {[weak self] result, error in
            guard let strongSelf = self else {
                return
            }
            guard error == nil else {
                // show account creation
                strongSelf.createAlert(title: " SignUp", message: "Please,You should Create Account")
                return
            }
            
            print("You have signed in")
            strongSelf.emailTF.resignFirstResponder()
            strongSelf.passwordTF.resignFirstResponder()
            
            //.. do something
            let storyboardd = UIStoryboard(name: "Data", bundle: nil)
            let vc = storyboardd.instantiateViewController(identifier: "ViewController") as! ViewController
            print("data \(name)")
            vc.data = name
            UserDefaults.standard.setValue(true, forKey: "isLogin")
            UserDefaults.standard.set(name, forKey: "nameUser")
            self?.show(vc, sender: nil)
        })
    }
    
    
    @IBAction func SignUpButton(_ sender: Any) {
        guard let name = nameTF.text, !name.isEmpty,
              let email = emailTF.text, !email.isEmpty,
              let password = passwordTF.text, !password.isEmpty else {
                  createAlert(title: "Error", message: "Missing field data..")
                  return
        }
        
        showCreateAccount(email: email, password: password)
    }
    
    
    func showCreateAccount(email :String ,password :String) {
        let alert = UIAlertController(title: "Create Account",
                                      message: "Would you like to create an account",
                                      preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Continue",
                                      style: .default,
                                      handler: {_ in
                                        FirebaseAuth.Auth.auth().createUser(withEmail: email, password: password,
                                                completion: {[weak self] result, error in
                                            
                                                    guard let strongSelf = self else {
                                                        return
                                                    }
                                                    guard error == nil else {
                                                        // show account creation
                                                        strongSelf.createAlert(title: "Error", message: "You have an account Sign in")
                                                        return
                                                    }
                                                    
                                                    print("You have creation success")
                                                    strongSelf.emailTF.resignFirstResponder()
                                                    strongSelf.passwordTF.resignFirstResponder()
                                                    
                                                    //.. do something
                                                    let storyboardd = UIStoryboard(name: "Data", bundle: nil)
                                                    let vc = storyboardd.instantiateViewController(identifier: "ViewController") as! ViewController
                                                    print("data \(strongSelf.nameTF.text!)")
                                                    vc.data = strongSelf.nameTF.text!
                                                    UserDefaults.standard.setValue(true, forKey: "isLogin")
                                                    UserDefaults.standard.set(strongSelf.nameTF.text, forKey: "nameUser")
                                                    self?.show(vc, sender: nil)
                                                    
                                        })
                                      }))
        alert.addAction(UIAlertAction(title: "Cancel",
                                      style: .cancel,
                                      handler: {_ in
                                        
                                      }))
        present(alert, animated: true)
    }
    
    
    func createAlert(title :String, message :String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        present(alert, animated: true)
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if FirebaseAuth.Auth.auth().currentUser == nil {
            emailTF.becomeFirstResponder()
        }
    }

    
    override func viewWillDisappear(_ animated: Bool) {
        
    }
    
}





