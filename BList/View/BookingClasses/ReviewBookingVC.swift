//
//  ReviewBookingVC.swift
//  BList
//
//  Created by iOS TL on 27/05/22.
//

import UIKit
import IBAnimatable

class ReviewBookingVC: BaseClassVC {
    
    // MARK: - PROPERTIES
    @IBOutlet weak var noOfAdultBtn: UIButton!
    @IBOutlet weak var timeBn: UIButton!
    @IBOutlet weak var dateBtn          : UIButton!
    @IBOutlet weak var expImgview       : AnimatableImageView!
    @IBOutlet weak var expNameLbl       : UILabel!
    @IBOutlet weak var ratingBtn        : UIButton!
    @IBOutlet weak var priceLbl         : UILabel!
    @IBOutlet weak var pricePerAdultLbl : UILabel!
    @IBOutlet weak var amountLbl        : UILabel!
    @IBOutlet weak var totalAmountLbl   : UILabel!
    @IBOutlet weak var addressLbl       : UILabel!
    @IBOutlet weak var notes_Lbl        : UILabel!
    @IBOutlet weak var paymentTypeBtn   : UIButton!
    @IBOutlet weak var paymentTypeLbl   : UILabel!
    @IBOutlet weak var locationView     : UIView!
    // MARK: - PROPERTIES
    weak var viewModel: UserViewModel!
    var selectedViewTag = 0
    var selectedPaymentType: PaymentType = .card
    var locations = [String]()
    var selectedLocationIndex = 0
    // MARK: - VIEW CYCLE METHODS
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.modelType = .BookExperience
        setUpVM(model: viewModel)
        showInfoOnUI()
    }
    
    // MARK: - KEY FUNCTIONS
    func showInfoOnUI() {
        if let exp = viewModel.expDetail?.expDetail {
            let image = BaseURLs.experience_Image.rawValue + (exp.images?.components(separatedBy: ",").first ?? "")
            
            expImgview.setImage(link: image, placeholder: "no_image")
            
            expNameLbl.text = exp.expName
            priceLbl.attributedText = createAttributedStr(text1: "$\(exp.amount ?? "0") / ", text2: "person", font1: AppFont.cabinRegular.withSize(16.0), font2: AppFont.cabinRegular.withSize(16.0), textColor1: AppColor.orange, textColor2: AppColor.app989595)
            ratingBtn.setTitle("\(viewModel.expDetail?.averageRating ?? "0.0") (\(viewModel.expDetail?.totalRatingsCount ?? 0))", for: .normal)
            noOfAdultBtn.setTitle("", for: .normal)
            dateBtn.setTitle(DateConvertor.shared.convert(dateInString: viewModel.startDateSlot.value, from: .ddMMMyyyy, to: .yyyyMMdd, dateStyle: .medium).dateInString, for: .normal)
            
            let startTime = DateConvertor.shared.convert(dateInString: viewModel.startTimeSlot.value, from: .HHmm, to: .hmma, timeStyle: .short).dateInString ?? ""
            
            let endTime = DateConvertor.shared.convert(dateInString: viewModel.endTimeSlot.value, from: .HHmm, to: .hmma, timeStyle: .short).dateInString ?? ""
            
            timeBn.setTitle("\(startTime) to \(endTime)", for: .normal)
            
            var adult = "\(viewModel.noOfAdult) adult"
            if viewModel.noOfChild > 0 {
                adult += " \(viewModel.noOfChild) child"
            }
            if viewModel.noOfInfant > 0 {
                adult += " \(viewModel.noOfInfant) infant"
            }
            noOfAdultBtn.setTitle(adult, for: .normal)
            
            var price = Int(exp.amount ?? "0")! * viewModel.noOfAdult
            var pricePerAdult = "$\(exp.amount ?? "0") * \(viewModel.noOfAdult) adult"
            if viewModel.noOfChild > 0 {
                pricePerAdult += "\n$\(exp.amount ?? "0") * \(viewModel.noOfChild) child"
                price += Int(exp.amount ?? "0")! * viewModel.noOfChild
            }
            if viewModel.noOfInfant > 0 {
                pricePerAdult += "\n$\(exp.amount ?? "0") * \(viewModel.noOfInfant) infant"
                price += Int(exp.amount ?? "0")! * viewModel.noOfInfant
            }
            pricePerAdultLbl.text = pricePerAdult
            amountLbl.text = "$\(price)"
            totalAmountLbl.text = "$\(price)"
            if exp.expMode ?? "" == "In Person"{
                locations = (exp.formattedLocations ?? "").components(separatedBy:" | ")
                addressLbl.text = locations.first ?? ""
            }
            else{
                locationView.isHidden = true
            }
            if viewModel.selectedTimeSlot.isEmpty{
                if selectedViewTag == 0{
                    if exp.expDate ?? "no" == "yes"{
                        dateBtn.setTitle(exp.expStartDate ?? "", for: .normal)
                        timeBn.setTitle(exp.expStartTime ?? "", for: .normal)
                    }
                    else{
                        dateBtn.setTitle(exp.currentDate ?? "", for: .normal)
                    }
                }
                else{
                    if exp.expDate ?? "no" == "yes"{
                        dateBtn.setTitle(exp.expEndDate ?? "", for: .normal)
                        timeBn.setTitle(exp.expEndTime ?? "", for: .normal)
                    }
                    else{
                        dateBtn.setTitle(exp.currentDate ?? "", for: .normal)
                    }
                }
            }
            else{
                
                dateBtn.setTitle(viewModel.selectedTimeSlot.first?["date"] as? String ?? "", for: .normal)
                timeBn.setTitle(viewModel.selectedTimeSlot.first?["slots"] as? String ?? "", for: .normal)
            }
        }
    }
    
    // MARK: - ACTIONS
    @IBAction func noteAction(_ sender : UIButton){
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "AddNoteVC") as! AddNoteVC
        vc.modalTransitionStyle = .crossDissolve
        vc.modalPresentationStyle = .custom
        vc.notes = self.viewModel.notes.value
        vc.closureDidAddNote = { [weak self] (note) in
            guard let self = self else {return}
            DispatchQueue.main.async {
                self.viewModel.notes.value = note
                self.notes_Lbl.text = note
            }
        }
        self.present(vc, animated:true, completion: nil)
    }
    
    @IBAction func changeLocationBtn(_ sender:UIButton){
        let vc = UIStoryboard.loadChangeLocationVC()
        vc.locations = locations
        vc.selectedIndex = selectedLocationIndex
        vc.selectedLocationIndex = { [weak self](index) in
            guard let self = self else{return}
            self.selectedLocationIndex = index
            self.addressLbl.text = self.locations[index]
        }
        vc.modalPresentationStyle = .custom
        vc.modalTransitionStyle = .coverVertical
        present(vc, animated: true)
    }
    
    @IBAction func selectDateAndTimeAction(_ sender : UIButton){
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "ChooseDateAndTimePopUp") as! ChooseDateAndTimePopUp
        vc.viewModel = viewModel
        vc.clouser = { [weak self] in
            guard let self = self else{return}
            self.showInfoOnUI()
            
        }
        vc.modalTransitionStyle = .crossDissolve
        vc.modalPresentationStyle = .custom
        self.present(vc, animated:true, completion: nil)
    }
    @IBAction func selectMemberAction(_ sender : UIButton){
        let vc = UIStoryboard.loadChooseMemberVC()
        vc.modalTransitionStyle = .crossDissolve
        vc.modalPresentationStyle = .custom
        vc.viewModel = viewModel
        vc.closureDidAdd = { [weak self] in
            guard let self = self else{return}
            self.showInfoOnUI()
        }
        self.present(vc, animated:true, completion: nil)
        
    }
    @IBAction func payWithAction(_ sender : UIButton){
        let vc =  self.storyboard?.instantiateViewController(withIdentifier: "CChoosePaymentVC") as! CChoosePaymentVC
        vc.selectedPaymentTypeClosure = {[weak self](paymentType) in
            guard let self = self else{return}
            self.selectedPaymentType = paymentType
            self.paymentTypeBtn.setImage(UIImage(named: paymentType.rawValue), for: .normal)
            self.paymentTypeLbl.text = paymentType.rawValue
        }
        vc.selectedPaymentType = self.selectedPaymentType
        vc.modalTransitionStyle = .crossDissolve
        vc.modalPresentationStyle = .custom
        self.present(vc, animated:true, completion: nil)
    }
    @IBAction func doneAction(_ sender : UIButton){
        //        UPaymentMethodsVC
        switch selectedPaymentType {
        case .card:
            if let vc = UIStoryboard.storyboardType(type: .user).instantiateViewController(withIdentifier: "UPaymentMethodsVC") as? UPaymentMethodsVC {
                vc.userVM = viewModel
                vc.paymentTypeScreen = .bookExp
                vc.selectedCardClosure = {[weak self](card_id) in
                    guard let self = self else{return}
                    self.viewModel.card_id = card_id
                }
                self.navigationController?.pushViewController(vc, animated: true)
            }
        case .paypal, .crypto:
            showErrorMessages(message: "This payment method is currently unavailable")
        }
    }
}

