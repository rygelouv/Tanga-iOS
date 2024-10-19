//
//  Categories.swift
//  Tanga
//
//  Created by Rygel Louv on 11/10/2024.
//

enum PredefinedCategory: CaseIterable, Identifiable {
    case productivitySelfGrowth
    case financialEducation
    case businessCareer
    case selfHelp
    
    var id: CategoryId {
        switch self {
        case .businessCareer:
            return "business_career"
        case .selfHelp:
            return "life_philosophy_psychology"
        case .financialEducation:
            return "financial_education"
        case .productivitySelfGrowth:
            return "productivity_and_personal_development"
        }
    }
    
    var categoryName: String {
        switch self {
        case .businessCareer:
            return String(localized: "Business & Career")
        case .productivitySelfGrowth:
            return String(localized: "Productivity & Self-Growth")
        case .selfHelp:
            return String(localized: "Self-Help")
        case .financialEducation:
            return String(localized: "Financial Education")
        }
    }
    
    var topics: String {
        switch self {
        case .businessCareer:
            return String(localized: "•Business •Entrepreneurship •Leadership •Career •Professional development")
        case .productivitySelfGrowth:
            return String(localized: "Personal development •Productivity •Self-improvement •Self-developmens")
        case .selfHelp:
            return String(localized: "•Psychology •Life Philosophy •Self-help •Lifestyle •Stoicism")
        case .financialEducation:
            return String(localized: "•Financial education •Investing •Finance •Money •Wealth")
        }
    }
    
    var icon: String {
        switch self {
        case .businessCareer:
            return String("business")
        case .productivitySelfGrowth:
            return String("productivity")
        case .selfHelp:
            return String("personal_development")
        case .financialEducation:
            return String("financial_education")
        }
    }
    
    var illustration: String {
        switch self {
        case .businessCareer:
            return String("graphic_business_simple")
        case .productivitySelfGrowth:
            return String("graphic_personal_goals_checklist")
        case .selfHelp:
            return String("graphic_questions_simple")
        case .financialEducation:
            return String("graphic_investing_finance")
        }
    }
    
    static func fromId(_ id: CategoryId) -> PredefinedCategory {
        switch id {
        case "business_career":
            return .businessCareer
        case "productivity_and_personal_development":
            return .productivitySelfGrowth
        case "life_philosophy_psychology":
            return .selfHelp
        case "financial_education":
            return .financialEducation
        default:
            return .businessCareer
        }
    }
}
