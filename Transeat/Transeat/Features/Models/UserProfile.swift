import Foundation
import SwiftData

@Model
final class UserProfile {
    var name: String
    var age: Int
    var expectedDueDate: String
    
    var usgProofData: Data?
    var medicationProofData: Data?

    var createdAt: Date

    init(
        name: String,
        age: Int,
        expectedDueDate: String,
        usgProofData: Data? = nil,
        medicationProofData: Data? = nil,
        createdAt: Date = .now
    ) {
        self.name = name
        self.age = age
        self.expectedDueDate = expectedDueDate
        self.usgProofData = usgProofData
        self.medicationProofData = medicationProofData
        self.createdAt = createdAt
    }
}
