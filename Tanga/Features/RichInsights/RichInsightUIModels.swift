import Foundation

// Protocol for any page that can be displayed in the Rich Insights view
protocol InsightPage {
    var number: Int { get }
}

// UI model for the idea page - shows concept with title, description and illustration
struct IdeaPageInsightUI: InsightPage {
    var number: Int
    var title: String
    var description: String
    var illustrationUrl: String
    var bookCoverUrl: String
    
    // Create from the domain model
    init(from richInsight: RichInsight, bookCoverUrl: String) {
        self.number = richInsight.number
        self.title = richInsight.title
        self.description = richInsight.description
        self.illustrationUrl = richInsight.illustrationUrl
        self.bookCoverUrl = bookCoverUrl
    }
    
    // For preview/testing
    static var sample: IdeaPageInsightUI {
        IdeaPageInsightUI(
            from: RichInsight(
                id: "",
                number: 1,
                title: "Focus on Your One Thing",
                description: "Concentrate on the single most important task that will have the greatest impact on your success.",
                illustrationUrl: "https://ik.imagekit.io/tangaimages/onething_img2_tiny.png",
                videoUrl: ""
            ),
            bookCoverUrl: "https://i.postimg.cc/tpgRQNV7/The-One-Thing-02-min.jpg"
        )
    }
}

// UI model for the video page - only needs the video URL
struct VideoPageInsightUI: InsightPage {
    var number: Int
    var videoUrl: String
    
    // Create from the domain model
    init(from richInsight: RichInsight) {
        self.number = richInsight.number
        self.videoUrl = richInsight.videoUrl
    }
    
    // For preview/testing
    static var sample: VideoPageInsightUI {
        VideoPageInsightUI(
            from: RichInsight(
                id: "",
                number: 1,
                title: "Focus on Your One Thing",
                description: "Concentrate on the single most important task that will have the greatest impact on your success.",
                illustrationUrl: "https://ik.imagekit.io/tangaimages/onething_img2_tiny.png",
                videoUrl: ""
            )
        )
    }
}

// Extension to create all page models from a single domain model
extension RichInsight {
    func toIdeaPageUI(bookCoverUrl: String) -> IdeaPageInsightUI {
        IdeaPageInsightUI(from: self, bookCoverUrl: bookCoverUrl)
    }
    
    func toVideoPageUI() -> VideoPageInsightUI {
        VideoPageInsightUI(from: self)
    }
}
