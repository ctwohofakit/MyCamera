//
//  ProgressModel.swift
//  MyCamera
//
//  Created by Kit Sitou on 6/18/26.
//


import Foundation
import SwiftData

@Model
class ProgressEntryModel {
    var id: UUID
    var createdAt: Date
    var note: String
    
    var beforeImage: String
    var afterImage: String
    
    init(id: UUID = UUID(), createdAt: Date, note: String, beforeImage: String, afterImage: String) {
        self.id = id
        self.createdAt = createdAt
        self.note = note
        self.beforeImage = beforeImage
        self.afterImage = afterImage
    }
}
