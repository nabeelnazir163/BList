//
//  UPaymentMethodsVC.swift
//  BList
//
//  Created by iOS Team on 13/05/22.
//

import UIKit

class UPaymentMethodsVC: BaseClassVC {
    enum PaymentTypeScreen{
        case bookExp
        case promoteExp
    }
    // MARK: - OUTLETS
    @IBOutlet weak var tableView: UITableView!{
        didSet{
            tableView.delegate = self
            tableView.dataSource = self
        }
    }
    @IBOutlet weak var NoCardSV: UIStackView!
    // MARK: - PROPERTIES
    var selectedType:PaymentType = .card
    var userVM: UserViewModel!
    weak var creatorVM : CreatorViewModel!
    var selectedCardClosure:((_ cardID: String)->())?
    var paymentTypeScreen: PaymentTypeScreen = .bookExp
    // MARK: - VIEW LIFE CYCLE METHODS
    override func viewDidLoad() {
        super.viewDidLoad()
        if userVM == nil {
            userVM = UserViewModel(type: .BookExperience)
        }
        setUpVM(model: userVM)
        userVM.cardList()
        fetchData()
    }
    func fetchData(){
        userVM.didFinishFetch = {[weak self](apiType) in
            guard let self = self else{return}
            switch apiType{
            case .AddCard,.GetCardsList:
                self.tableView.reloadData()
            case .AddBooking:
                let vc = UIStoryboard.loadBookingSuccessfully()
                vc.modalTransitionStyle = .crossDissolve
                vc.modalPresentationStyle = .custom
                self.present(vc, animated:true)
            default:
                break
            }
            
        }
    }
    
    // MARK: - IBACTIONS
    @IBAction func actionAddNewCard(_ sender: Any) {
        if let vc = self.storyboard?.instantiateViewController(withIdentifier: "AddNewCardVC") as? AddNewCardVC {
            vc.viewModel = userVM
            vc.cardAddedCallBack = {[weak self] in
                guard let self = self else{return}
                self.tableView.reloadData()
            }
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    @IBAction func makePaymentBtnAction(_ sender:UIButton){
        switch paymentTypeScreen {
        case .bookExp:
            userVM.modelType = .AddBooking
            userVM.card_id = userVM.cardsList.filter({$0.selected == true}).first?.id ?? ""
            if userVM.card_id.isEmptyOrWhitespace() {
                self.showErrorMessages(message: "Select a card")
            } else {
                let vc = UIStoryboard.loadCardCVV()
                vc.modalTransitionStyle = .crossDissolve
                vc.modalPresentationStyle = .custom
                vc.callBack = { [weak self](cvv) in
                    guard let self = self else {return}
                    self.userVM.cvv = cvv
                    self.userVM.add_Bookig()
                    
                }
                self.present(vc, animated: true)
            }
        case .promoteExp:
            if let selectedCardID = userVM.cardsList.filter({$0.selected == true}).first?.id{
                creatorVM.cardId = selectedCardID
                creatorVM.modelType = .PromoteExperience
                setUpVM(model: creatorVM)
                let vc = UIStoryboard.loadCardCVV()
                vc.modalTransitionStyle = .crossDissolve
                vc.modalPresentationStyle = .custom
                vc.callBack = { [weak self](cvv) in
                    guard let self = self else {return}
                    self.creatorVM.cvv = cvv
                    self.creatorVM.promoteExp()
                    self.creatorVM.didFinishFetch = { [weak self](_) in
                        guard let self = self else{return}
                        self.popVC(until: CTabBarVC.self)
                    }
                    
                }
                self.present(vc, animated: true)
                
            }
            else{
                showErrorMessages(message: "Please select a card")
            }
        }
    }
}


// MARK: - TABLE VIEW DELEGATE & DATASOURCE METHODS
extension UPaymentMethodsVC: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return userVM.cardsList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PaymentMethodTableCell", for: indexPath) as! PaymentMethodTableCell
        cell.setUpData(card: userVM.cardsList[indexPath.row])
        //        cell.cardImgView.image = UIImage(named: indexPath.row == 0 ? "visa" : (indexPath.row == 1 ? "american-express" : "diners_club"))
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        userVM.cardsList = userVM.cardsList.map({ card in
            var card = card
            card.selected = false
            return card
        })
        userVM.cardsList[indexPath.row].selected = true
        tableView.reloadData()
    }
    
}


class PaymentMethodTableCell: UITableViewCell {
    @IBOutlet weak var cardImgView      : UIImageView!
    @IBOutlet weak var radioImgView     : UIImageView!
    @IBOutlet weak var cardNumber       : UILabel!
    @IBOutlet weak var cardExpDate      : UILabel!
    @IBOutlet weak var cardHolderName   : UILabel!
    
    func setUpData(card: CardDetails){
        cardHolderName.text = card.cardName ?? ""
        cardExpDate.text = card.cardExpireDate ?? ""
        cardNumber.text = card.cardNumber ?? ""
        if card.selected == true{
            radioImgView.image = UIImage(named: "radio_active")
        }
        else{
            radioImgView.image = UIImage(named: "radio_button")
        }
    }
}
