//
//  AddNewCardVC.swift
//  BList
//
//  Created by iOS Team on 16/05/22.
//

import UIKit
import IBAnimatable
import DropDown
class AddNewCardVC: BaseClassVC {
    // MARK: - OUTLETS
    @IBOutlet weak var cardNumberTF: AnimatedBindingText!{
        didSet {
            cardNumberTF.delegate = self
            cardNumberTF.bind{[unowned self] in self.viewModel.cardNumber.value = $0 }
            
        }
    }
    @IBOutlet weak var cardHolderNameTF: AnimatedBindingText!{
        didSet { cardHolderNameTF.bind{[unowned self] in self.viewModel.cardHolderName.value = $0 } }
    }
    @IBOutlet weak var cityTF: AnimatedBindingText!{
        didSet { cityTF.bind{[unowned self] in self.viewModel.cardCity.value = $0 } }
    }
    @IBOutlet weak var zipCodeTF: AnimatedBindingText!{
        didSet { zipCodeTF.bind{[unowned self] in self.viewModel.zipCode.value = $0 } }
    }
    
    @IBOutlet weak var cardExpDateTF: MonthYearBindingTextField!{
        didSet {cardExpDateTF.bind{[unowned self] in self.viewModel.cardExpDate.value = $0 }}
    }
    @IBOutlet weak var stateTF: UITextField!{
        didSet{
            stateTF.inputView = UIView()
            stateTF.inputAccessoryView = UIView()
        }
    }
    @IBOutlet weak var countryTF: UITextField!{
        didSet{
            countryTF.inputView = UIView()
            countryTF.inputAccessoryView = UIView()
        }
    }
    
    // MARK: - PROPERTIES
    var countries   = [Countries]()
    var states      = [States]()
    var dropDown    = DropDown()
    var cardAddedCallBack:(()->())?
    // MARK: - PROPERTIES
    weak var viewModel: UserViewModel!
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpVM(model: viewModel)
        cardExpDateTF.closureDidDone = {
            self.viewModel.cardExpDate.value = self.cardExpDateTF.text!
        }
        countries = getCountries()
        countryTF.addTarget(self, action: #selector(addDropDownToFields(_:)), for: .editingDidBegin)
        stateTF.addTarget(self, action: #selector(addDropDownToFields(_:)), for: .editingDidBegin)
    }
    @objc func addDropDownToFields(_ sender:UITextField){
        resignText(txtFields: [cardNumberTF, cardHolderNameTF, cityTF, zipCodeTF,cardExpDateTF])
        dropDown.anchorView = sender
        dropDown.direction = .bottom
        dropDown.bottomOffset = CGPoint(x: 0, y:(dropDown.anchorView?.plainView.bounds.height)!)
        if sender.tag == 0{
            dropDown.dataSource = countries.map({$0.countryName ?? ""})
        }
        else{
            if countryTF.text?.isEmpty == true{
                showErrorMessages(message: "Pick Country First")
                dropDown.dataSource = []
            }
            else{
                dropDown.dataSource = states.map({$0.stateName ?? ""})
            }
        }
        dropDown.selectionAction = { [unowned self] (index: Int, item: String) in
            if sender.tag == 0{
                countryTF.text = item
                viewModel.cardCountry = item
                self.states = getStates(country: countryTF.text!)
            }
            else{
                stateTF.text = item
                viewModel.cardState = item
            }
        }
        dropDown.show()
    }
    // MARK: - IBACTIONS
    @IBAction func actionSave(_ sender: AnimatableButton) {
        viewModel.modelType = .AddCard
        if viewModel.isValid{
            viewModel.addCard()
            viewModel.didFinishFetch = { [weak self](type) in
                guard let self = self else{return}
                self.cardAddedCallBack?()
                self.navigationController?.popViewController(animated: true)
            }
            
        }
        else{
            showErrorMessages(message: viewModel.brokenRules.first?.message ?? "")
        }
    }
}
//MARK: - TEXT FIELD DELEGATE METHODS
extension AddNewCardVC: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField == cardNumberTF {
            let text = (textField.text! as NSString).replacingCharacters(in: range, with: string)
            let strCount = text.count
            if (strCount % 5) == 0 && textField.text!.count <= 18 {
                if string == "" {
                    
                } else {
                    textField.text?.insert(" ", at: String.Index.init(utf16Offset: strCount - 1, in: textField.text ?? ""))
                }
            }
            
            guard let textFieldText = cardNumberTF.text,
                  let rangeOfTextToReplace = Range(range, in: textFieldText) else {
                return false
            }
            let substringToReplace = textFieldText[rangeOfTextToReplace]
            let count = textFieldText.count - substringToReplace.count + string.count
            return count <= 19
        }
        return true
    }
}

