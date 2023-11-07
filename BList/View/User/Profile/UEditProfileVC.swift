//
//  UEditProfileVC.swift
//  BList
//
//  Created by iOS TL on 18/05/22.
//

import UIKit

class UEditProfileVC: BaseClassVC {
    // MARK: - OUTLETS
    // TEXT FIELDS
    @IBOutlet weak var firstnameTF      : AnimatedBindingText!{
        didSet {
            firstnameTF.bind{[unowned self] in self.viewModel.fname.value = $0 }
        }
    }
    @IBOutlet weak var lastnameTF       : AnimatedBindingText!{
        didSet {
            lastnameTF.bind{[unowned self] in self.viewModel.lname.value = $0 }
        }
    }
    @IBOutlet weak var emailTF          : AnimatedBindingText!{
        didSet {
            emailTF.bind{[unowned self] in self.viewModel.email.value = $0 }
        }
    }
    @IBOutlet weak var mobilenoTF       : AnimatedBindingText!{
        didSet {
            mobilenoTF.bind{[unowned self] in self.viewModel.phone.value = $0 }
        }
    }
    @IBOutlet weak var dobTF            : AnimatedBindingText!{
        didSet {
            dobTF.bind{[unowned self] in self.viewModel.dob.value = $0 }
        }
    }
    @IBOutlet weak var faceBookTF       : AnimatedBindingText!{
        didSet {
            faceBookTF.bind{[unowned self] in self.viewModel.facebook_url.value = $0 }
        }
    }
    @IBOutlet weak var twitterTF        : AnimatedBindingText!{
        didSet {
            twitterTF.bind{[unowned self] in self.viewModel.twitter_url.value = $0 }
        }
    }
    @IBOutlet weak var instagramTF      : AnimatedBindingText!{
        didSet {
            instagramTF.bind{[unowned self] in self.viewModel.instagram_url.value = $0 }
        }
    }
    @IBOutlet weak var linkedinTF       : AnimatedBindingText!{
        didSet {
            linkedinTF.bind{[unowned self] in self.viewModel.linkedin_url.value = $0 }
        }
    }
    @IBOutlet weak var websiteTF        : AnimatedBindingText!{
        didSet {
            websiteTF.bind{[unowned self] in self.viewModel.website_url.value = $0 }
        }
    }
    
    // VIEWS
    @IBOutlet weak var facebookView     : UIView!
    @IBOutlet weak var twitterView      : UIView!
    @IBOutlet weak var instagramView    : UIView!
    @IBOutlet weak var linkedinView     : UIView!
    @IBOutlet weak var websiteView      : UIView!
    
    // Switches
    @IBOutlet weak var facebookSwitch   : UISwitch!
    @IBOutlet weak var twitterSwitch    : UISwitch!
    @IBOutlet weak var instagramSwitch  : UISwitch!
    @IBOutlet weak var linkedinSwitch   : UISwitch!
    @IBOutlet weak var websiteSwitch    : UISwitch!
    
    @IBOutlet weak var profileImg       : UIImageView!
    @IBOutlet weak var btn_code         : UIButton!
    @IBOutlet weak var aboutTV          : UITextView!
    
    
    // MARK: - PROPERTIES
    weak var viewModel: AuthViewModel!
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpVM(model: viewModel)
        dobTF.addInputViewDatePicker(target: self, selector: #selector(doneButtonPressed))
        setupUI()
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(imgTapAction(_:)))
        profileImg.addGestureRecognizer(tapGesture)
    }
    @objc func imgTapAction(_ sender: UITapGestureRecognizer) {
        let share = CameraHandler.shared
        share.showActionSheet(vc: self)
        share.imagePickedBlock = { [weak self] img in
            guard let self = self else {return}
            self.viewModel.profile_image = img
            self.profileImg.image = img
        }
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        DispatchQueue.main.async {
            self.viewModel.fname.bindAndFire { [weak self] in self?.firstnameTF.text = $0}
            self.viewModel.lname.bindAndFire { [weak self] in self?.lastnameTF.text = $0}
            self.viewModel.email.bindAndFire { [weak self] in self?.emailTF.text = $0}
            self.viewModel.phone.bindAndFire { [weak self] in self?.mobilenoTF.text = $0}
            self.viewModel.dob.bindAndFire { [weak self] in self?.dobTF.text = $0}
            self.viewModel.facebook_url.bindAndFire { [weak self] in self?.faceBookTF.text = $0}
            self.viewModel.twitter_url.bindAndFire { [weak self] in self?.twitterTF.text = $0}
            self.viewModel.instagram_url.bindAndFire { [weak self] in self?.instagramTF.text = $0}
            self.viewModel.linkedin_url.bindAndFire { [weak self] in self?.linkedinTF.text = $0}
            self.viewModel.website_url.bindAndFire { [weak self] in self?.websiteTF.text = $0}
        }
    }
    // MARK: - KEY FUNCTIONS
    @objc func doneButtonPressed() {
        if let datePicker = dobTF.inputView as? UIDatePicker {
            let dateFormatter = DateFormatter()
            dateFormatter.dateStyle = .medium
            self.dobTF.text = dateFormatter.string(from: datePicker.date)
            dateFormatter.dateFormat = "dd/MM/yyyy"
            self.viewModel.dob.value = dateFormatter.string(from: datePicker.date)
        }
        self.dobTF.resignFirstResponder()
     }
    func setupUI(){
        if let user_Details = self.viewModel.user_ProfileDetails?.data{
            self.profileImg.setImage(link: BaseURLs.userImgURL.rawValue + (user_Details.profileImg ?? ""), placeholder: "place_holder")
            if let img = self.profileImg.image{
                self.viewModel.profile_image = img
            }
            self.viewModel.fname.value = user_Details.firstName ?? ""
            self.viewModel.lname.value = user_Details.lastName ?? ""
            self.viewModel.email.value = user_Details.email ?? ""
            self.viewModel.phone.value = user_Details.phone ?? ""
            self.viewModel.phoneCode.value = user_Details.phonecode ?? ""
            self.btn_code.setTitle(user_Details.phonecode ?? "", for: .normal)
            self.dobTF.text = user_Details.dob ?? ""
            self.viewModel.dob.value = user_Details.dob ?? ""
            self.viewModel.bio = user_Details.bio ?? ""
            self.aboutTV.text = user_Details.bio ?? ""
            if let facebookURL = user_Details.facebookURL, !facebookURL.isEmpty{
                self.viewModel.facebook_url.value = facebookURL
                self.facebookSwitch.setOn(true, animated: false)
                self.facebookView.isHidden = true
            }
            if let twitterURL = user_Details.twitterURL, !twitterURL.isEmpty{
                self.viewModel.twitter_url.value = twitterURL
                self.twitterSwitch.setOn(true, animated: false)
                self.twitterView.isHidden = true
            }
            if let instagramURL = user_Details.instagramURL, !instagramURL.isEmpty{
                self.viewModel.instagram_url.value = instagramURL
                self.instagramSwitch.setOn(true, animated: false)
                self.instagramView.isHidden = true
            }
            if let linkedInURL = user_Details.linkedinURL, !linkedInURL.isEmpty{
                self.viewModel.linkedin_url.value = linkedInURL
                self.linkedinSwitch.setOn(true, animated: false)
                self.linkedinView.isHidden = true
            }
            if let websiteURL = user_Details.websiteURL, !websiteURL.isEmpty{
                self.viewModel.website_url.value = websiteURL
                self.websiteSwitch.setOn(true, animated: false)
                self.websiteView.isHidden = true
            }
        }
    }
    // MARK: - ACTIONS
    @IBAction func editbaget(_ sender : UIButton){
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "IdentityVerificationVC") as! IdentityVerificationVC
        self.navigationController?.pushViewController(vc, animated: true)
    }
    @IBAction func codeSelectionAction(_ sender : UIButton){
        let vc = UIStoryboard.loadCountryListTable()
        vc.countryID = {[weak self] (countryName,code,id) in
            guard  let self = self else {
                return
            }
            self.btn_code.setTitle("+\(code)", for: .normal)
            self.viewModel.phoneCode.value = code
        }
        self.present(vc, animated: true, completion: nil)
    }
    @IBAction func switchTapAction(_ sender:UISwitch){
        if sender.tag == 0{
            // Facebook
            facebookView.isHidden = sender.isOn
        }
        else if sender.tag == 1{
            // Twitter
            twitterView.isHidden = sender.isOn
        }
        else if sender.tag == 2{
            // Instagram
            instagramView.isHidden = sender.isOn
        }
        else if sender.tag == 3{
            // LinkedIn
            linkedinView.isHidden = sender.isOn
        }
        else{
            // Website
            websiteView.isHidden = sender.isOn
        }
    }
    @IBAction func submitTapAction(_ sender:UIButton){
        viewModel.bio = aboutTV.text ?? ""
        if viewModel.isValid{
            viewModel.updateProfile()
            viewModel.didFinishFetch = { [weak self](apiType) in
                guard let self = self else{return}
                self.navigationController?.popViewController(animated: true)
            }
        }
        else{
            showErrorMessages(message: viewModel.brokenRules.first?.message ?? "try again")
        }
    }
}
