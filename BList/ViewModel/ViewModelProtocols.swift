
import UIKit
import IBAnimatable
import GrowingTextView

struct BrokenRule {
    var propertyName :String
    var message :String
}
protocol ViewModel {
    //computed closure
    var brokenRules :[BrokenRule] { get set}
    var isValid :Bool { mutating get }
    var showAlertClosure: (() -> ())? { get set }
    var updateLoadingStatus: (() -> ())? { get set }
    var didFinishFetch: ((ApiType) -> ())? { get set }
    var error: String? { get set }
    var isLoading: Bool { get set }
}
// Mark: Creating Generic datatype for accepting dynamic data
class Dynamic<T> {
    typealias Listener = (T) -> ()
    var listener: Listener?
    func bind(_ listener: Listener?) {
        self.listener = listener
    }
    func bindAndFire(_ listener: Listener?) {
        self.listener = listener
        listener?(value)
    }
    var value: T {
        didSet {
            listener?(value)
        }
    }
    init(_ v: T) {
        value = v
    }
}
// MARK:- Creating Binding UI for the UITextField
class AnimatedBindingText: AnimatableTextField {
    
    var textChanged :(String) -> () = { _ in }
    func bind(callback :@escaping (String) -> ()) {
        textChanged = callback
        self.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
    }
  
    @objc func textFieldDidChange(_ textField :UITextField) {
        print(textField.text!)
        textChanged(textField.text!)
    }
}
// MARK:- Creating Binding UI for the UITextField
class MonthYearBindingTextField: MonthYearTextField {
    
    var textChanged :(String) -> () = { _ in }
    func bind(callback :@escaping (String) -> ()) {
        textChanged = callback
        self.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
    }
  
    @objc func textFieldDidChange(_ textField :UITextField) {
        print(textField.text!)
        textChanged(textField.text!)
    }
}
extension ViewModel{
    func printUserDetails(_ userData:User?){
        guard let userData = userData else {
            print("UserData Not Found")
            return
        }
        print("""

-------   User Details  ------
User ID                 ->\(userData.id ?? "")
First Name              ->\(userData.firstName ?? "")
Last Name               ->\(userData.lastName ?? "")
Email ID                ->\(userData.email ?? "")
Phone                   ->\(userData.phone ?? "")
Phone Code              ->\(userData.phonecode ?? "")
Date of birth           ->\(userData.dob ?? "")
Gender                  ->\(userData.gender ?? "")
Bio                     ->\(userData.bio ?? "")
Role                    ->\(userData.role ?? "") // 1 --> User, 2--> Creator
Creator Type            ->\(userData.creatorType ?? "") // 1 --> Individual, 2 --> Venue
Identity Type           ->\(userData.identityType ?? "")
Identity Document       ->\(userData.identityDocument ?? "")
Identity Verified       ->\(userData.identityVerified ?? "")
Facebook URL            ->\(userData.facebookURL ?? "")
Twitter URL             ->\(userData.twitterURL ?? "")
Instagram URL           ->\(userData.instagramURL ?? "")
LinkedIn URL            ->\(userData.linkedinURL ?? "")
Status                  ->\(userData.status ?? "")
-------------       End       ---------------
""")
    }
}

