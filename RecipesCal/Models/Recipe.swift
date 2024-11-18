//
//  Recipe.swift
//  RecipesCal
//
//  Created by Nikita Koniukh on 18/11/2024.
//


import Foundation

struct Recipe: Codable {
    let calories: String?
    let carbos: String?
    let description: String?
    let difficulty: Int?
    let fats: String?
    let headline: String?
    let id: String?
    let image: String?
    let name: String?
    let proteins: String?
    let thumb: String?
    let time: String?
    let country: String?
}
