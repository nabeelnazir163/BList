//
//  Dictionary+Extension.swift
//  BList
//
//  Created by iOS TL on 29/07/22.
//

import Foundation
func convertdata(_ data : [String],key:String) -> [String:String]{
    var dic = [String:String]()
    for dat in data.enumerated(){
        dic.updateValue(dat.element, forKey: "\(key)[\(dat.offset)]")
    }
    return dic
}
extension Dictionary {
    mutating func merge(dict: [Key: Value]){
        for (k, v) in dict {
            updateValue(v, forKey: k)
        }
    }
}
