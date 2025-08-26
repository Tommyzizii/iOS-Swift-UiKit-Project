//
//  EditProfileController.swift
//  Burn N' Learn
//
//  Created by Thant Zin Min on 27/9/2567 BE.
//

import UIKit

class EditProfileController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    var viewModel: ProfileViewModel! // Injected from ProfileController
    
    // UI Outlets
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var phoneTextField: UITextField!
    @IBOutlet weak var ageTextField: UITextField!
    @IBOutlet weak var sexTextField: UITextField!
    
    @IBOutlet weak var nameError: UILabel!
    @IBOutlet weak var phoneError: UILabel!
    @IBOutlet weak var ageError: UILabel!
    @IBOutlet weak var sexError: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
            
        profileImageView.image = UIImage(named: "profilelogo")
        setupUI()
        bindViewModel()
    }
    
    private func setupUI() {
        // Set up the profile image if available
        profileImageView.image = viewModel.profileImage
        nameTextField.text = viewModel.name
        phoneTextField.text = viewModel.phone
        ageTextField.text = viewModel.age
        sexTextField.text = viewModel.sex

        // Set up tap gesture for image picker
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(imageTapped))
        profileImageView.isUserInteractionEnabled = true
        profileImageView.addGestureRecognizer(tapGesture)
        
        // Hide all error messages initially
        resetErrorMessages()
    }
    
    private func bindViewModel() {
        // Bind error messages from the ViewModel to the error labels
        viewModel.nameError = { [weak self] errorMessage in
            self?.nameError.text = errorMessage
            self?.nameError.isHidden = errorMessage == nil
        }
        
        viewModel.phoneError = { [weak self] errorMessage in
            self?.phoneError.text = errorMessage
            self?.phoneError.isHidden = errorMessage == nil
        }
        
        viewModel.ageError = { [weak self] errorMessage in
            self?.ageError.text = errorMessage
            self?.ageError.isHidden = errorMessage == nil
        }
        
        viewModel.sexError = { [weak self] errorMessage in
            self?.sexError.text = errorMessage
            self?.sexError.isHidden = errorMessage == nil
        }
    }
    
    private func resetErrorMessages() {
        nameError.isHidden = true
        phoneError.isHidden = true
        ageError.isHidden = true
        sexError.isHidden = true
    }
    
    
    @IBAction func editImage(_ sender: UIButton) {
        imageTapped()
    }
    
    @objc func imageTapped() {
        let alert = UIAlertController(title: "Choose Photo", message: "Select a photo from the library or take a new one.", preferredStyle: .actionSheet)
        
        alert.addAction(UIAlertAction(title: "Camera", style: .default, handler: { _ in
            self.presentImagePicker(sourceType: .camera)
        }))
        
        alert.addAction(UIAlertAction(title: "Photo Library", style: .default, handler: { _ in
            self.presentImagePicker(sourceType: .photoLibrary)
        }))
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        present(alert, animated: true, completion: nil)
    }
    
    func presentImagePicker(sourceType: UIImagePickerController.SourceType) {
        guard UIImagePickerController.isSourceTypeAvailable(sourceType) else { return }
        
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = sourceType
        present(imagePicker, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let selectedImage = info[.originalImage] as? UIImage {
            profileImageView.image = selectedImage
        }
        dismiss(animated: true, completion: nil)
    }

    @IBAction func saveButtonTapped(_ sender: UIButton) {
        // Reset error messages first
        resetErrorMessages()
        
        // Validate and update the ViewModel with the new data
        let isNameValid = viewModel.validateName(nameTextField.text ?? "")
        let isPhoneValid = viewModel.validatePhoneNumber(phoneTextField.text ?? "")
        let isAgeValid = viewModel.validateAge(ageTextField.text ?? "")
        let isSexValid = viewModel.validateSex(sexTextField.text ?? "")
        
        if isNameValid && isPhoneValid && isAgeValid && isSexValid {
            viewModel.updateProfile(
                name: nameTextField.text ?? "",
                phone: phoneTextField.text ?? "",
                age: Int(ageTextField.text ?? "0") ?? 0,
                sex: sexTextField.text ?? "",
                profileImage: profileImageView.image
            )
            self.dismiss(animated: true, completion: nil)
        }
    }
}
