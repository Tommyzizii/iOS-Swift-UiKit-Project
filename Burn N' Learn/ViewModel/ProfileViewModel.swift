//
//  ProfileViewModel.swift
//  Burn N' Learn
//
//  Created by Thant Zin Min on 27/9/2567 BE.
//

import Foundation
import UIKit

class ProfileViewModel {
    
    // Profile data
    var name: String = "" {
        didSet { nameChanged?(name) }
    }
    var phone: String = "" {
        didSet { phoneChanged?(phone) }
    }
    var age: String = "" {
        didSet { ageChanged?(age) }
    }
    var sex: String = "" {
        didSet { sexChanged?(sex) }
    }
    var profileImage: UIImage? {
        didSet { profileImageChanged?(profileImage) }
    }
    
    // Closures for data binding
    var nameChanged: ((String) -> Void)?
    var phoneChanged: ((String) -> Void)?
    var ageChanged: ((String) -> Void)?
    var sexChanged: ((String) -> Void)?
    var profileImageChanged: ((UIImage?) -> Void)?
    
    // Closures for validation errors
    var nameError: ((String?) -> Void)?
    var phoneError: ((String?) -> Void)?
    var ageError: ((String?) -> Void)?
    var sexError: ((String?) -> Void)?
    
    // Load the profile data from persistent storage (e.g., UserDefaults)
    func loadProfileData() {
        if let savedName = UserDefaults.standard.string(forKey: "name") {
            name = savedName
        }
        if let savedPhone = UserDefaults.standard.string(forKey: "phone") {
            phone = savedPhone
        }
        if let savedAge = UserDefaults.standard.string(forKey: "age") {
            age = savedAge
        }
        if let savedSex = UserDefaults.standard.string(forKey: "sex") {
            sex = savedSex
        }
        if let imageData = UserDefaults.standard.data(forKey: "profileImage"),
           let savedImage = UIImage(data: imageData) {
            profileImage = savedImage
        }
    }
    
    // Save the updated profile data to persistent storage
    func saveProfileData() {
        UserDefaults.standard.set(name, forKey: "name")
        UserDefaults.standard.set(phone, forKey: "phone")
        UserDefaults.standard.set(age, forKey: "age")
        UserDefaults.standard.set(sex, forKey: "sex")
        
        if let image = profileImage, let imageData = image.jpegData(compressionQuality: 1.0) {
            UserDefaults.standard.set(imageData, forKey: "profileImage")
        }
    }
    
    // Update profile data from the edit screen
    func updateProfile(name: String, phone: String, age: Int, sex: String, profileImage: UIImage?) {
        self.name = name
        self.phone = phone
        self.age = "\(age)"
        self.sex = sex
        self.profileImage = profileImage
        
        saveProfileData()
    }
    
    // MARK: - Validation
    
    func validateName(_ name: String) -> Bool {
        if name.isEmpty {
            nameError?("Name is required")
            return false
        } else if let firstCharacter = name.first, !firstCharacter.isUppercase {
            nameError?("Name must start with an uppercase letter")
            return false
        }
        nameError?(nil)
        return true
    }
    
    func validatePhoneNumber(_ phoneNumber: String) -> Bool {
        let set = CharacterSet(charactersIn: phoneNumber)
        if !CharacterSet.decimalDigits.isSuperset(of: set) {
            phoneError?("Phone Number must contain only digits")
            return false
        }
        
        if phoneNumber.count < 10 || phoneNumber.count > 15 {
            phoneError?("Phone Number must be between 10 and 15 digits")
            return false
        }
        
        phoneError?(nil)
        return true
    }
    
    func validateAge(_ age: String) -> Bool {
        guard let ageValue = Int(age) else {
            ageError?("Age must be a number")
            return false
        }
        
        if ageValue < 0 || ageValue > 100 {
            ageError?("Age must be between 0 and 100")
            return false
        }
        
        ageError?(nil)
        return true
    }
    
    func validateSex(_ sex: String) -> Bool {
        let validSexes = ["Male", "Female", "Other"]
        if !validSexes.contains(sex.capitalized) {
            sexError?("Sex must be Male, Female, or Other")
            return false
        }
        
        sexError?(nil)
        return true
    }
}
