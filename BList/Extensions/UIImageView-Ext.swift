//
//  UIImageView-Ext.swift
//  BList
//
//  Created by iOS Team on 09/05/22.
//

import Foundation
import UIKit
import SDWebImage

extension UIImageView {
    func setImage(link:String, placeholder: String = "place_holder") {
        var getLink = link
        getLink = getLink.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
        guard let url = URL(string:getLink) else { return }
        self.sd_imageIndicator = SDWebImageActivityIndicator.gray
        self.sd_setImage(with:url, placeholderImage: UIImage(named: placeholder))
    }
}
