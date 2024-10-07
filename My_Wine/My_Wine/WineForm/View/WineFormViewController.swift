//
//  WineFormViewController.swift
//  My_Wine
//
//  Created by Karen Khachatryan on 06.10.24.
//

import UIKit
import Combine
import PhotosUI
import Cosmos

class WineFormViewController: UIViewController {
    @IBOutlet weak var formView: UIView!
    @IBOutlet weak var ratingView: CosmosView!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var saveButton: BaseButton!
    @IBOutlet weak var photoButton: UIButton!
    @IBOutlet var titleLabels: [UILabel]!
    @IBOutlet var textFields: [BaseTextField]!
    @IBOutlet weak var grapeTextField: BaseTextField!
    @IBOutlet weak var nameTextField: BaseTextField!
    @IBOutlet weak var countryTextField: BaseTextField!
    @IBOutlet weak var yearTextField: BaseTextField!
    @IBOutlet weak var tasteQualitiesTextView: UITextView!
    private var cancellables: Set<AnyCancellable> = []
    private let viewModel = WineFormViewModel.shared
    var completion: (() -> ())?
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        subscribe()
    }

    func setupUI() {
        self.view.backgroundColor = .background.withAlphaComponent(0.1)
        titleLabels.forEach({ $0.font = .interRegular(size: 14) })
        saveButton.titleLabel?.font = .jostRegular(size: 16)
        cancelButton.titleLabel?.font = .jostRegular(size: 16)
        grapeTextField.delegate = self
        nameTextField.delegate = self
        countryTextField.delegate = self
        yearTextField.delegate = self
        tasteQualitiesTextView.delegate = self
        tasteQualitiesTextView.layer.borderWidth = 0.5
        tasteQualitiesTextView.layer.borderColor = #colorLiteral(red: 0.6571641564, green: 0.6571640372, blue: 0.6571640372, alpha: 1).cgColor
        tasteQualitiesTextView.layer.cornerRadius = 3
        photoButton.layer.borderWidth = 0.5
        photoButton.layer.borderColor = #colorLiteral(red: 0.6571641564, green: 0.6571640372, blue: 0.6571640372, alpha: 1).cgColor
        photoButton.layer.cornerRadius = 3
        photoButton.layer.masksToBounds = true
        formView.addShadow()
    }
    
    func subscribe() {
        viewModel.$wineModel
            .receive(on: DispatchQueue.main)
            .sink { [weak self] wineModel in
                guard let self = self else { return }
                if self.viewModel.isEditing {
                }
                self.saveButton.isEnabled = ((wineModel.country ?? "").checkValidationo() && (wineModel.grape ?? "").checkValidationo() && (wineModel.name ?? "").checkValidationo() && (wineModel.qualities ?? "").checkValidationo() && (wineModel.year ?? "").checkValidationo() && wineModel.photo != nil)

            }
            .store(in: &cancellables)
        
        ratingView.didFinishTouchingCosmos = { [weak self] rating in
            if let self = self {
                self.viewModel.wineModel.rating = rating
            }
        }
    }
    
    @IBAction func clickedCancel(_ sender: UIButton) {
        self.dismiss(animated: true)
    }
    
    @IBAction func choosePhoto(_ sender: UIButton) {
        let actionSheet = UIAlertController(title: "Select Image", message: "Choose a source", preferredStyle: .actionSheet)
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            actionSheet.addAction(UIAlertAction(title: "Camera", style: .default, handler: { _ in
                self.requestCameraAccess()
            }))
        }
        actionSheet.addAction(UIAlertAction(title: "Photo Library", style: .default, handler: { _ in
            self.requestPhotoLibraryAccess()
        }))
        actionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        present(actionSheet, animated: true, completion: nil)
    }
    
    @IBAction func clickedSave(_ sender: UIButton) {
        viewModel.save { [weak self] error in
            guard let self = self else { return }
            if let error = error {
                self.showErrorAlert(message: error.localizedDescription)
            } else {
                self.dismiss(animated: true, completion: completion)
            }
        }
    }
    
    deinit {
        viewModel.clear()
    }
}

extension WineFormViewController: UITextFieldDelegate {
    func textFieldDidChangeSelection(_ textField: UITextField) {
        switch textField {
        case grapeTextField:
            viewModel.wineModel.grape = textField.text
        case nameTextField:
            viewModel.wineModel.name = textField.text
        case countryTextField:
            viewModel.wineModel.country = textField.text
        case yearTextField:
            viewModel.wineModel.year = textField.text
        default:
            break
        }
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField != yearTextField { return true }
        let allowedCharacters = CharacterSet.decimalDigits
        let characterSet = CharacterSet(charactersIn: string)
        return allowedCharacters.isSuperset(of: characterSet) || string.isEmpty
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
    }
}

extension WineFormViewController: UITextViewDelegate {
    func textViewDidChangeSelection(_ textView: UITextView) {
        viewModel.wineModel.qualities = textView.text
    }
}

extension WineFormViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    private func requestCameraAccess() {
            let cameraStatus = AVCaptureDevice.authorizationStatus(for: .video)
            switch cameraStatus {
            case .notDetermined:
                AVCaptureDevice.requestAccess(for: .video) { granted in
                    if granted {
                        self.openCamera()
                    }
                }
            case .authorized:
                openCamera()
            case .denied, .restricted:
                showSettingsAlert()
            @unknown default:
                break
            }
        }
        
        private func requestPhotoLibraryAccess() {
            let photoStatus = PHPhotoLibrary.authorizationStatus()
            switch photoStatus {
            case .notDetermined:
                PHPhotoLibrary.requestAuthorization { status in
                    if status == .authorized {
                        self.openPhotoLibrary()
                    }
                }
            case .authorized:
                openPhotoLibrary()
            case .denied, .restricted:
                showSettingsAlert()
            case .limited:
                break
            @unknown default:
                break
            }
        }
        
        private func openCamera() {
            DispatchQueue.main.async {
                if UIImagePickerController.isSourceTypeAvailable(.camera) {
                    let imagePicker = UIImagePickerController()
                    imagePicker.delegate = self
                    imagePicker.sourceType = .camera
                    imagePicker.allowsEditing = true
                    self.present(imagePicker, animated: true, completion: nil)
                }
            }
        }
        
        private func openPhotoLibrary() {
            DispatchQueue.main.async {
                if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
                    let imagePicker = UIImagePickerController()
                    imagePicker.delegate = self
                    imagePicker.sourceType = .photoLibrary
                    imagePicker.allowsEditing = true
                    self.present(imagePicker, animated: true, completion: nil)
                }
            }
        }
        
        private func showSettingsAlert() {
            let alert = UIAlertController(title: "Access Needed", message: "Please allow access in Settings", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
            alert.addAction(UIAlertAction(title: "Settings", style: .default, handler: { _ in
                if let settingsURL = URL(string: UIApplication.openSettingsURLString) {
                    UIApplication.shared.open(settingsURL, options: [:], completionHandler: nil)
                }
            }))
            present(alert, animated: true, completion: nil)
        }
        
        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            if let editedImage = info[.editedImage] as? UIImage {
                photoButton.setImage(editedImage, for: .normal)
            } else if let originalImage = info[.originalImage] as? UIImage {
                photoButton.setImage(originalImage, for: .normal)
            }
            if let imageData = photoButton.imageView?.image?.jpegData(compressionQuality: 1.0) {
                let data = imageData as Data
                viewModel.wineModel.photo = data
            }
            picker.dismiss(animated: true, completion: nil)
        }
        
        func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
            picker.dismiss(animated: true, completion: nil)
        }
}
