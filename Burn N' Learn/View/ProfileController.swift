//
//  ProfileController.swift
//  Burn N' Learn
//
//  Created by Thant Zin Min on 27/9/2567 BE.
//

import UIKit
import FirebaseAuth
import UserNotifications

class ProfileController: UIViewController, UNUserNotificationCenterDelegate {

    // UI Outlets
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var phoneLabel: UILabel!
    @IBOutlet weak var ageLabel: UILabel!
    @IBOutlet weak var sexLabel: UILabel!
    
    // ViewModel instance
    private var viewModel = ProfileViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        bindViewModel()  // Bind ViewModel to UI elements
        viewModel.loadProfileData() // Load initial profile data
        
        // Notification permission
        let notificationCenter = UNUserNotificationCenter.current()
        notificationCenter.delegate = self
        checkForPermission()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.loadProfileData() // Reload data when the view appears
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        makeProfileImageCircular()  // Ensure the profile image is circular after layout
    }

    // Bind ViewModel to UI elements
    private func bindViewModel() {
        viewModel.nameChanged = { [weak self] name in
            self?.nameLabel.text = name
        }
        
        viewModel.phoneChanged = { [weak self] phone in
            self?.phoneLabel.text = phone
        }
        
        viewModel.ageChanged = { [weak self] age in
            self?.ageLabel.text = age
        }
        
        viewModel.sexChanged = { [weak self] sex in
            self?.sexLabel.text = sex
        }
        
        viewModel.profileImageChanged = { [weak self] profileImage in
            self?.profileImageView.image = profileImage
            self?.makeProfileImageCircular()
        }
    }
    
    // UI setup
    private func setupUI() {
        // Make the labels rounded
        [nameLabel, phoneLabel, ageLabel, sexLabel].forEach {
            $0?.layer.cornerRadius = 10
            $0?.layer.masksToBounds = true
        }
    }

    // Make the profile image circular
    func makeProfileImageCircular() {
        profileImageView.layer.cornerRadius = profileImageView.frame.size.width / 3
        profileImageView.clipsToBounds = true
        profileImageView.contentMode = .scaleAspectFill
    }

    // Edit button tapped
    @IBAction func editButtonTapped(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if let editProfileVC = storyboard.instantiateViewController(withIdentifier: "EditProfileController") as? EditProfileController {
            editProfileVC.viewModel = viewModel  // Pass the ViewModel to the EditProfileController
            self.present(editProfileVC, animated: true, completion: nil)
        }
    }

    // Sign out button tapped
    @IBAction func signOutButtonTapped(_ sender: UIButton) {
        let alert = UIAlertController(title: "Sign Out", message: "Are you sure you want to sign out?", preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "Yes", style: .default, handler: { _ in
            do {
                try Auth.auth().signOut()
                self.presentLoginScreen()
            } catch {
                print("Error signing out: \(error.localizedDescription)")
            }
        }))
        
        alert.addAction(UIAlertAction(title: "No", style: .cancel, handler: nil))
        
        present(alert, animated: true, completion: nil)
    }

    private func presentLoginScreen() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if let loginVC = storyboard.instantiateViewController(withIdentifier: "login") as? LoginViewController {
            loginVC.modalPresentationStyle = .fullScreen
            self.present(loginVC, animated: true, completion: nil)
        }
    }

    // Notification permission handling
    func checkForPermission() {
        let notificationCenter = UNUserNotificationCenter.current()
        notificationCenter.getNotificationSettings { settings in
            switch settings.authorizationStatus {
            case .authorized:
                self.scheduleMultipleNotifications()
            case .denied:
                print("Notifications are denied.")
            case .notDetermined:
                notificationCenter.requestAuthorization(options: [.alert, .sound]) { didAllow, error in
                    if didAllow {
                        self.scheduleMultipleNotifications()
                    } else {
                        print("Notifications permission denied.")
                    }
                }
            default:
                return
            }
        }
    }

    // Schedule notifications
    func scheduleMultipleNotifications() {
        UNUserNotificationCenter.current().removeAllPendingNotificationRequests() // Remove previous notifications
        
        let times = [
            (hour: 8, minute: 0),
            (hour: 12, minute: 0),
            (hour: 16, minute: 0),
            (hour: 22, minute: 0)
        ]
        
        for (index, time) in times.enumerated() {
            let identifier = "water-reminder-notification-\(index)"
            let title = "Hydration Time!"
            let body = "Don't forget to drink water! Stay hydrated for a healthier you."
            
            let content = UNMutableNotificationContent()
            content.title = title
            content.body = body
            content.sound = .default
            
            var dateComponents = DateComponents()
            dateComponents.hour = time.hour
            dateComponents.minute = time.minute
            
            let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
            let request = UNNotificationRequest(identifier: identifier, content: content, trigger: trigger)
            
            UNUserNotificationCenter.current().add(request) { error in
                if let error = error {
                    print("Error scheduling notification: \(error.localizedDescription)")
                } else {
                    print("Notification scheduled for \(time.hour):\(time.minute)")
                }
            }
        }
    }

    // Handle foreground notifications
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.banner, .sound])
    }
}
