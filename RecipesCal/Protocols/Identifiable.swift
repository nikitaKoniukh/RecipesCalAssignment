//
//  Identifiable.swift
//  RecipesCal
//
//  Created by Nikita Koniukh on 18/11/2024.
//


import UIKit

protocol Identifiable {
    static var identifier: String { get }
    static var nib: UINib { get }
}

extension Identifiable {
    static var identifier: String {
        return String(describing: Self.self)
    }
    
    static var nib: UINib {
        return UINib(nibName: identifier, bundle: nil)
    }
}
