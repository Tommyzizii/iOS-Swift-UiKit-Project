//
//  SignUpViewController.swift
//  Burn N' Learn
//
//  Created by Thant Zin Min on 7/9/2567 BE.
//

import UIKit
import Firebase
import FirebaseAuth

class SignUpViewController: UIViewController {
    
    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var healthKitAuthButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        healthKitAuthButton.setTitle("Click This Button: Health Kit Authorization", for: .normal)
    }
    
    // Action for the Sign Up button
    @IBAction func signupTapped(_ sender: Any) {
        guard let emailText = email.text, !emailText.isEmpty else {
            showAlert(message: "Please enter your email.")
            return
        }
        guard let passwordText = password.text, !passwordText.isEmpty else {
            showAlert(message: "Please enter your password.")
            return
        }
        signUp(email: emailText, password: passwordText)
    }
    
    // Action for "Already have an account" button
    @IBAction func alreadyHaveAccountLoginTapped(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let loginVC = storyboard.instantiateViewController(withIdentifier: "login")
        loginVC.modalPresentationStyle = .overFullScreen
        present(loginVC, animated: true)
    }
    
    // HealthKit authorization button action
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
    
    // Sign up using Firebase Authentication
    func signUp(email: String, password: String) {
        Auth.auth().createUser(withEmail: email, password: password) { (authResult, error) in
            if let error = error {
                print("Error: \(error.localizedDescription)")
                self.showAlert(message: "Sign-up failed: \(error.localizedDescription)")
                return
            }
            
            // Successful sign-up, transition to the main home screen
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let mainTabVC = storyboard.instantiateViewController(withIdentifier: "tabBarMain")
            mainTabVC.modalPresentationStyle = .overFullScreen
            self.present(mainTabVC, animated: true)
        }
    }
    
    // Helper function to show alert
    func showAlert(message: String) {
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
}
