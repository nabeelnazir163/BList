//
//  AddNoteVC.swift
//  BList
//
//  Created by iOS TL on 27/05/22.
//

import UIKit
import IBAnimatable

class AddNoteVC: BaseClassVC {

    @IBOutlet weak var noteTxtField: AnimatableTextField!
    var notes = ""
    var closureDidAddNote: ((String) -> ())?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        noteTxtField.text = notes
    }

    @IBAction func actiondone(_ sender: Any) {
        if noteTxtField.text!.isEmptyOrWhitespace() {
            self.showErrorMessages(message: "Please add notes")
        } else {
            closureDidAddNote?(noteTxtField.text!)
            self.dismiss(animated: true, completion: nil)
        }
    }
}
