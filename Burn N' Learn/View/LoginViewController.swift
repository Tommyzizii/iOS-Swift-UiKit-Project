//
//  LoginViewController.swift
//  Burn N' Learn
//
//  Created by Thant Zin Min on 7/9/2567 BE.
//

import UIKit
import FirebaseAuth

class LoginViewController: UIViewController {
    
    @IBOutlet weak var email: UITextField!
    
    @IBOutlet weak var password: UITextField!
    
    @IBOutlet weak var healthKitAuthButton: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        healthKitAuthButton.setTitle("Click This Button: Health Kit Authorization", for: .normal)
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        checkUserInfo()
    }
    

    @IBAction func logInTapped(_ sender: Any) {
        validateFields()
    }
    
    @IBAction func createAccountTapped(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(identifier: "signup")
        vc.modalPresentationStyle = .overFullScreen
        present(vc, animated: true)
    }
    
    @IBAction func healthKitAuthTapped(_ sender: UIButton) {
        PermissionHealthKitSetup.authorizedHealthKitSetup { success, error in
                    if success {
                        print("HealthKit authorization successful")
                        DispatchQueue.main.async {
                            self.healthKitAuthButton.setTitle("HealthKit Authorized", for: .normal)
                        }
                    } else {
                        print("HealthKit authorization failed: \(String(describing: error))")
                        DispatchQueue.main.async {
                            self.healthKitAuthButton.setTitle("Authorization Failed", for: .normal)
                        }
                    }
                }
        }

    func validateFields() {
            guard let emailText = email.text, !emailText.isEmpty else {
                print("No Email Text")
                return
            }
            
            guard let passwordText = password.text, !passwordText.isEmpty else {
                print("No password")
                return
            }
            
            login()
        }
        
        func login() {
            guard let emailText = email.text, let passwordText = password.text else { return }
            
            Auth.auth().signIn(withEmail: emailText, password: passwordText) { [weak self] authResult, err in
                guard let strongSelf = self else { return }
                if let err = err {
                    print(err.localizedDescription)
                    return
                }
                strongSelf.checkUserInfo()
            }
        }
        
        func checkUserInfo() {
            if Auth.auth().currentUser != nil {
                print(Auth.auth().currentUser?.uid ?? "No UID")
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                let vc = storyboard.instantiateViewController(withIdentifier: "tabBarMain")
                vc.modalPresentationStyle = .overFullScreen
                present(vc, animated: true)
            }
        }
}
