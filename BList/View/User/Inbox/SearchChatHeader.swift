//
//  SearchChatHeader.swift
//  BList
//
//  Created by Venkata Ajay Sai (Paras) on 28/02/23.
//

import UIKit

class SearchChatHeader: UITableViewHeaderFooterView {
    @IBOutlet weak var searchTF: AnimatedBindingText!{
        didSet{
            searchTF.bind { [unowned self] in
                self.socketVM.search.value = $0
            }
        }
    }
    weak var socketVM: ConnectSocketViewModel!
}
