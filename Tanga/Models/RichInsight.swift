import Foundation

struct RichInsight: Identifiable, Codable {
    var id: String = UUID().uuidString
    var number: Int
    var title: String
    var description: String
    var illustrationUrl: String
    var videoUrl: String
    
    // Optional fields for additional data
    var keyTakeaways: [String]?
}

// UI model for displaying Rich Insights
struct RichInsightUI: Identifiable {
    var id: String
    var number: Int
    var title: String
    var description: String
    var illustrationUrl: String
    var videoUrl: String
    var keyTakeaways: [String]
    
    init(from model: RichInsight) {
        self.id = model.id
        self.number = model.number
        self.title = model.title
        self.description = model.description
        self.illustrationUrl = model.illustrationUrl
        self.videoUrl = model.videoUrl
        self.keyTakeaways = model.keyTakeaways ?? []
    }
}
