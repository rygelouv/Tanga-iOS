//
//  Category.swift
//  Tanga
//
//  Created by Rygel Louv on 07/10/2024.
//

import Foundation
import FirebaseFirestore

typealias CategoryId = String

struct Category: Identifiable, Codable {
    @DocumentID var id: CategoryId?
    let slug: String?
    let name: String?
}
