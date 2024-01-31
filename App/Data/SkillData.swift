//
//  SkillData.swift
//
//
//  Created by Larissa Fazolin on 26/01/24.
//

import SwiftUI

enum SkillType {
    case offensive
    case defensive
}

class SkillData: ObservableObject, Equatable, Hashable {
    static func == (lhs: SkillData, rhs: SkillData) -> Bool {
        return lhs.skillName == rhs.skillName
            && lhs.description == rhs.description
            && lhs.type == rhs.type
            && lhs.strength == rhs.strength
            && lhs.cooldown == rhs.cooldown
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(skillName)
        hasher.combine(description)
        hasher.combine(type)
        hasher.combine(strength)
        hasher.combine(cooldown)
    }
    
    func decreaseCooldown() {
        if remainingCooldown > 0 {
            remainingCooldown -= 1
        }
    }
    
    func resetCooldown() {
        remainingCooldown = cooldown + 1
    }

    @Published var skillName: String
    @Published var description: String
    @Published var type: SkillType
    @Published var strength: Double
    @Published var cooldown: Double
    @Published var isActivated: Bool = false
    @Published var remainingCooldown: Double

    init(skillName: String, description: String, type: SkillType, strength: Double, cooldown: Double, remainingCooldown: Double) {
        self.skillName = skillName
        self.description = description
        self.type = type
        self.strength = strength
        self.cooldown = cooldown
        self.remainingCooldown = remainingCooldown
    }
}

class SkillDataViewModel: ObservableObject {
    @Published var skillOne: SkillData
    @Published var skillTwo: SkillData
    @Published var skillThree: SkillData
    @Published var skillFour: SkillData

    @Published var confirmedSkills: [SkillData: Bool] = [:]
    
    func decreaseCooldowns() {
        for (skill, confirmed) in confirmedSkills {
            if confirmed {
                skill.remainingCooldown -= 1

                // Check if the remaining cooldown is 0, then remove from confirmed skills
                if skill.remainingCooldown == 0 {
                    confirmedSkills[skill] = false
                    skill.resetCooldown()
                }
            }
        }
    }

    init() {
        self.skillOne = SkillData(skillName: "Just Smile", description: "Quality Time", type: .offensive, strength: 15.0, cooldown: 1, remainingCooldown: 2)
        self.skillTwo = SkillData(skillName: "Ask a Question", description: "Quality Time", type: .offensive, strength: 30.0, cooldown: 2, remainingCooldown: 3)
        self.skillThree = SkillData(skillName: "Stay Silent", description: "Social Energy", type: .defensive, strength: 15.0, cooldown: 3, remainingCooldown: 4)
        self.skillFour = SkillData(skillName: "Nod Head", description: "Protect yourself for 1 turn", type: .defensive, strength: 0, cooldown: 2, remainingCooldown: 3)
    }
}