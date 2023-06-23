//
//  CoctailModel.swift
//  HSTestTask
//
//  Created by Темирлан Кудайберген on 22.06.2023.
//

import Foundation

public struct CoctailModel: Codable {
    var drinks: [Drink]
}

public struct Drink: Codable {
    let name: String?
    let category: String?
    let instructions: String?
    let thumb: String
    var thumbImageData: Data?
    
    enum CodingKeys: String, CodingKey {
        case name = "strDrink"
        case category = "strCategory"
        case instructions = "strInstructions"
        case thumb = "strDrinkThumb"
        case thumbImageData = "drinkThumbImageData"
    }
}
