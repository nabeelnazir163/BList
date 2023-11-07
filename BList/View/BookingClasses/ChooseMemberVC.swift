//
//  ChooseMemberVC.swift
//  BList
//
//  Created by admin on 25/05/22.
//

import UIKit
import IBAnimatable

class ChooseMemberVC: BaseClassVC {
    
    @IBOutlet weak var noOfInfantLbl: UILabel!
    @IBOutlet weak var noOfChildLbl: UILabel!
    @IBOutlet weak var noofAdultLbl: UILabel!
    var closureDidAdd: (() -> ())?
    
    weak var viewModel: UserViewModel!
    override func viewDidLoad() {
        super.viewDidLoad()
        noofAdultLbl.text = "\(viewModel.noOfAdult)"
        noOfChildLbl.text = "\(viewModel.noOfChild)"
        noOfInfantLbl.text = "\(viewModel.noOfInfant)"
    }
    
    
    // MARK: - IBACTIONS
    @IBAction func actionAdultIncDec(_ sender: AnimatableButton) {
        if sender.tag == 0 {
            if viewModel.noOfAdult > 0 {
                viewModel.noOfAdult -= 1
                noofAdultLbl.text = "\(viewModel.noOfAdult)"
            }
        } else {
            if isGuestCountUnderLimit() {
                if eligibleToAdd(person: .adult){
                    viewModel.noOfAdult += 1
                }
                else{
                    showErrorMessages(message: "This experience doesn't allow adults because the age limit is \(viewModel.expDetail?.expDetail?.minAgeLimit ?? "0") - \(viewModel.expDetail?.expDetail?.maxAgeLimit ?? "0") years")
                }
                noofAdultLbl.text = "\(viewModel.noOfAdult)"
            }
        }
        
    }
    
    @IBAction func actionChildIncDec(_ sender: AnimatableButton) {
        if sender.tag == 0 {
            if viewModel.noOfChild > 0 {
                viewModel.noOfChild -= 1
                noOfChildLbl.text = "\(viewModel.noOfChild)"
            } else {
                viewModel.noOfChild = 0
                noOfChildLbl.text = "0"
            }
        } else {
            if isGuestCountUnderLimit() {
                if eligibleToAdd(person: .children){
                    viewModel.noOfChild += 1
                }
                else{
                    showErrorMessages(message: "This experience doesn't allow children because the age limit is \(viewModel.expDetail?.expDetail?.minAgeLimit ?? "0") - \(viewModel.expDetail?.expDetail?.maxAgeLimit ?? "0") years")
                }
                noOfChildLbl.text = "\(viewModel.noOfChild)"
            }
        }
    }
    
    @IBAction func actionInfantIncDec(_ sender: AnimatableButton) {
        if sender.tag == 0 {
            if viewModel.noOfInfant > 0 {
                viewModel.noOfInfant -= 1
                noOfInfantLbl.text = "\(viewModel.noOfInfant)"
            } else {
                viewModel.noOfInfant = 0
                noOfInfantLbl.text = "0"
            }
        } else {
            if isGuestCountUnderLimit() {
                if eligibleToAdd(person: .infant){
                    viewModel.noOfInfant += 1
                }
                else{
                    showErrorMessages(message: "This experience doesn't allow infants because the age limit is \(viewModel.expDetail?.expDetail?.minAgeLimit ?? "0") - \(viewModel.expDetail?.expDetail?.maxAgeLimit ?? "0") years")
                }
                noOfInfantLbl.text = "\(viewModel.noOfInfant)"
            }
        }
    }
    @IBAction func actionDone(_ sender: Any) {
        viewModel.modelType = .ChooseMember
        if viewModel.isValid{
            closureDidAdd?()
            self.dismiss(animated: true, completion: nil)
        }
        else{
            showErrorMessages(message: viewModel.brokenRules.first?.message ?? "try again")
        }
    }
    
    func eligibleToAdd(person: Person) -> Bool{
        let minAge = Int(viewModel.expDetail?.expDetail?.minAgeLimit ?? "0") ?? 0
        let maxAge = Int(viewModel.expDetail?.expDetail?.maxAgeLimit ?? "0") ?? 0
        switch person {
        case .adult:
            return (minAge ... maxAge).contains { age in
                age >= 12
            }
        case .children:
            return (minAge ... maxAge).contains { age in
                age >= 2 && age <= 12
            }
        case .infant:
            return (minAge ... maxAge).contains { age in
                age < 2
            }
        }
    }
    func isGuestCountUnderLimit() -> Bool{
        if (viewModel.guestCount) < Int(viewModel.expDetail?.expDetail?.maxGuestLimit ?? "0") ?? 0{
            return true
        }
        else{
            showErrorMessages(message: "Guest limit reached.")
            return false
        }
    }
}
