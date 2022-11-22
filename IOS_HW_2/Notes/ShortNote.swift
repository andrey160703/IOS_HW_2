//
//  ShortNote.swift
//  IOS_HW_2
//
//  Created by Андрей Гусев on 22/11/2022.
//

import UIKit

struct ShortNote : Encodable{
    var text: String
}

//extension ShortNote : Encodable {
//    enum CodingKeys : String, CodingKey {
//        case text
//    }
//
//    func encode(to encoder: Encoder) throws {
//        var container = encoder.container(keyedBy: CodingKeys.self)
//
//        try container.encode(text, forKey: .text)
//    }
//}
