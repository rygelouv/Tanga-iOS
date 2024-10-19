//
//  Section.swift
//  Tanga
//
//  Created by Rygel Louv on 07/10/2024.
//

import Foundation

struct Section: Identifiable {
    var id: String { category.id ?? UUID().uuidString }
    let category: Category
    let summaries: [Summary]
}
