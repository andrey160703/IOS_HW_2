//
//  SaveClass.swift
//  IOS_HW_2
//
//  Created by Андрей Гусев on 23/11/2022.
//

import UIKit

class saveClass{
    func saveData(to arr : [ShortNote]) {
        print("--------------------------------------------------------------------------------------")
        let jsonEncoder = JSONEncoder()
        var tmp = [String]()
        for el in arr{
            tmp.append(el.text)
        }
        guard let data = try? JSONSerialization.data(withJSONObject: tmp, options: []) else {
                return
            }
        var str = String(data: data, encoding: String.Encoding.utf8)
        print(str)
        print("--------------------------------------------------------------------------------------")
    }
}
