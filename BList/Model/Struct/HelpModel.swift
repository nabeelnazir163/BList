//
//  HelpModel.swift
//  BList
//
//  Created by iOS Team on 12/05/22.
//

import Foundation

struct HelpModel {
    let question: String
    let answer: String
    var isExpanded: Bool = false
    
    static func data() -> [HelpModel] {
        var arr = [HelpModel]()
        arr.append(HelpModel(question: "1. Getting Start with Bliss",
                             answer: "Praesent gravida, mi non pulvinar ullamcorper, ex purus posuere justo, ut ultrices sapien urna in odio. Mauris porta augue a metus viverra cursus. Duis scelerisque porttitor velit non finibus. Cras bibendum et dolor at iaculis. Morbi in nunc sit amet sapien pharetra vehicula. Cras posuere rhoncus dui ac pharetra. Ut mattis, tellus sed interdum"))
        arr.append(HelpModel(question: "2. Pay With Trips",
                             answer: "Praesent gravida, mi non pulvinar ullamcorper, ex purus posuere justo, ut ultrices sapien urna in odio. Mauris porta augue a metus viverra cursus. Duis scelerisque porttitor velit non finibus. Cras bibendum et dolor at iaculis. Morbi in nunc sit amet sapien pharetra vehicula. Cras posuere rhoncus dui ac pharetra. Ut mattis, tellus sed interdum"))
        arr.append(HelpModel(question: "3. Mi non pulvinar ullamcorper, justo",
                             answer: "Praesent gravida, mi non pulvinar ullamcorper, ex purus posuere justo, ut ultrices sapien urna in odio. Mauris porta augue a metus viverra cursus. Duis scelerisque porttitor velit non finibus. Cras bibendum et dolor at iaculis. Morbi in nunc sit amet sapien pharetra vehicula. Cras posuere rhoncus dui ac pharetra. Ut mattis, tellus sed interdum"))
        arr.append(HelpModel(question: "4. Forbi ultrices lacus in massa efficitur",
                             answer: "Praesent gravida, mi non pulvinar ullamcorper, ex purus posuere justo, ut ultrices sapien urna in odio. Mauris porta augue a metus viverra cursus. Duis scelerisque porttitor velit non finibus. Cras bibendum et dolor at iaculis. Morbi in nunc sit amet sapien pharetra vehicula. Cras posuere rhoncus dui ac pharetra. Ut mattis, tellus sed interdum"))
        arr.append(HelpModel(question: "5. Suspendisse mattis leo quam, sed",
                             answer: "Praesent gravida, mi non pulvinar ullamcorper, ex purus posuere justo, ut ultrices sapien urna in odio. Mauris porta augue a metus viverra cursus. Duis scelerisque porttitor velit non finibus. Cras bibendum et dolor at iaculis. Morbi in nunc sit amet sapien pharetra vehicula. Cras posuere rhoncus dui ac pharetra. Ut mattis, tellus sed interdum"))
        arr.append(HelpModel(question: "6. Nam laoreet lacus eu sem Hendrerit.",
                             answer: "Praesent gravida, mi non pulvinar ullamcorper, ex purus posuere justo, ut ultrices sapien urna in odio. Mauris porta augue a metus viverra cursus. Duis scelerisque porttitor velit non finibus. Cras bibendum et dolor at iaculis. Morbi in nunc sit amet sapien pharetra vehicula. Cras posuere rhoncus dui ac pharetra. Ut mattis, tellus sed interdum"))
        return arr
    }
}
