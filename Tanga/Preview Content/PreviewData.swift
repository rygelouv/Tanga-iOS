//
//  PreviewData.swift
//  Tanga
//
//  Created by Rygel Louv on 09/10/2024.
//

import Foundation

// Define real-life categories
let categories = [
    Category(id: "business-career", slug: "business-career", name: "Business & Career"),
    Category(id: "productivity", slug: "productivity", name: "Productivity"),
    Category(id: "financial-education", slug: "financial-education", name: "Financial Education"),
    Category(id: "life-philosophy", slug: "life-philosophy", name: "Life Philosophy")
]

// Create dummy books (summaries) for each category
func createBooksForCategory(categoryId: String) -> [Summary] {
    switch categoryId {
    case "business-career":
        return [
            Summary(id: "1", title: "Start with Why", author: "Simon Sinek", synopsis: "A book about the importance of knowing your why.", coverImageUrl: "https://example.com/start-with-why.jpg", playingLength: "8h 35m", purchaseBookUrl: "https://example.com/start-with-why", categories: [categoryId]),
            Summary(id: "2", title: "Good to Great", author: "Jim Collins", synopsis: "A book about how companies transition from good to great.", coverImageUrl: "https://example.com/good-to-great.jpg", playingLength: "9h 58m", purchaseBookUrl: "https://example.com/good-to-great", categories: [categoryId]),
            Summary(id: "3", title: "Lean In", author: "Sheryl Sandberg", synopsis: "A book about women, work, and the will to lead.", coverImageUrl: "https://example.com/lean-in.jpg", playingLength: "7h 24m", purchaseBookUrl: "https://example.com/lean-in", categories: [categoryId]),
            Summary(id: "4", title: "The 4-Hour Workweek", author: "Tim Ferriss", synopsis: "A guide to escaping the 9-to-5 grind.", coverImageUrl: "https://example.com/4-hour-workweek.jpg", playingLength: "13h 12m", purchaseBookUrl: "https://example.com/4-hour-workweek", categories: [categoryId]),
            Summary(id: "5", title: "The Lean Startup", author: "Eric Ries", synopsis: "A book on how today's entrepreneurs use continuous innovation to create successful businesses.", coverImageUrl: "https://example.com/lean-startup.jpg", playingLength: "10h 34m", purchaseBookUrl: "https://example.com/lean-startup", categories: [categoryId])
        ]
    case "productivity":
        return [
            Summary(id: "6", title: "Getting Things Done", author: "David Allen", synopsis: "A guide to the art of stress-free productivity.", coverImageUrl: "https://example.com/getting-things-done.jpg", playingLength: "11h 25m", purchaseBookUrl: "https://example.com/getting-things-done", categories: [categoryId]),
            Summary(id: "7", title: "Atomic Habits", author: "James Clear", synopsis: "A guide to building good habits and breaking bad ones.", coverImageUrl: "https://example.com/atomic-habits.jpg", playingLength: "10h 5m", purchaseBookUrl: "https://example.com/atomic-habits", categories: [categoryId]),
            Summary(id: "8", title: "Deep Work", author: "Cal Newport", synopsis: "A book about how to focus without distraction.", coverImageUrl: "https://example.com/deep-work.jpg", playingLength: "7h 44m", purchaseBookUrl: "https://example.com/deep-work", categories: [categoryId]),
            Summary(id: "9", title: "The One Thing", author: "Gary Keller", synopsis: "A book about focusing on the one most important task at a time.", coverImageUrl: "https://example.com/the-one-thing.jpg", playingLength: "5h 35m", purchaseBookUrl: "https://example.com/the-one-thing", categories: [categoryId]),
            Summary(id: "10", title: "Essentialism", author: "Greg McKeown", synopsis: "A book about the disciplined pursuit of less.", coverImageUrl: "https://example.com/essentialism.jpg", playingLength: "6h 15m", purchaseBookUrl: "https://example.com/essentialism", categories: [categoryId])
        ]
    case "financial-education":
        return [
            Summary(id: "11", title: "Rich Dad Poor Dad", author: "Robert Kiyosaki", synopsis: "A book about financial independence and wealth building.", coverImageUrl: "https://example.com/rich-dad-poor-dad.jpg", playingLength: "6h 20m", purchaseBookUrl: "https://example.com/rich-dad-poor-dad", categories: [categoryId]),
            Summary(id: "12", title: "The Millionaire Next Door", author: "Thomas J. Stanley", synopsis: "A study of millionaires and their habits.", coverImageUrl: "https://example.com/millionaire-next-door.jpg", playingLength: "8h 50m", purchaseBookUrl: "https://example.com/millionaire-next-door", categories: [categoryId]),
            Summary(id: "13", title: "Your Money or Your Life", author: "Vicki Robin", synopsis: "A book about transforming your relationship with money.", coverImageUrl: "https://example.com/your-money-or-your-life.jpg", playingLength: "11h 35m", purchaseBookUrl: "https://example.com/your-money-or-your-life", categories: [categoryId]),
            Summary(id: "14", title: "The Total Money Makeover", author: "Dave Ramsey", synopsis: "A proven plan for financial fitness.", coverImageUrl: "https://example.com/total-money-makeover.jpg", playingLength: "9h 13m", purchaseBookUrl: "https://example.com/total-money-makeover", categories: [categoryId]),
            Summary(id: "15", title: "The Simple Path to Wealth", author: "JL Collins", synopsis: "A guide to investing and achieving financial independence.", coverImageUrl: "https://example.com/simple-path-to-wealth.jpg", playingLength: "8h 5m", purchaseBookUrl: "https://example.com/simple-path-to-wealth", categories: [categoryId])
        ]
    case "life-philosophy":
        return [
            Summary(id: "16", title: "Meditations", author: "Marcus Aurelius", synopsis: "A book about personal philosophy and Stoicism.", coverImageUrl: "https://example.com/meditations.jpg", playingLength: "8h 45m", purchaseBookUrl: "https://example.com/meditations", categories: [categoryId]),
            Summary(id: "17", title: "The Obstacle Is the Way", author: "Ryan Holiday", synopsis: "A book about turning adversity into advantage.", coverImageUrl: "https://example.com/obstacle-is-the-way.jpg", playingLength: "6h 15m", purchaseBookUrl: "https://example.com/obstacle-is-the-way", categories: [categoryId]),
            Summary(id: "18", title: "Man's Search for Meaning", author: "Viktor Frankl", synopsis: "A book about finding meaning in life through suffering.", coverImageUrl: "https://example.com/mans-search-for-meaning.jpg", playingLength: "9h 10m", purchaseBookUrl: "https://example.com/mans-search-for-meaning", categories: [categoryId]),
            Summary(id: "19", title: "The Power of Now", author: "Eckhart Tolle", synopsis: "A book about the importance of living in the present moment.", coverImageUrl: "https://example.com/power-of-now.jpg", playingLength: "7h 45m", purchaseBookUrl: "https://example.com/power-of-now", categories: [categoryId]),
            Summary(id: "20", title: "The Subtle Art of Not Giving a F*ck", author: "Mark Manson", synopsis: "A counterintuitive approach to living a good life.", coverImageUrl: "https://example.com/subtle-art.jpg", playingLength: "5h 50m", purchaseBookUrl: "https://example.com/subtle-art", categories: [categoryId])
        ]
    default:
        return []
    }
}

// Create sections with 5 summaries each for the 4 categories
let sections = categories.map { category in
    Section(category: category, summaries: createBooksForCategory(categoryId: category.id!))
}

// Create a dummy weekly summary (from the first book of the first category)
let weeklySummaryCategory = categories.first!
let weeklySummaryBook = createBooksForCategory(categoryId: weeklySummaryCategory.id!).first!
let weeklySummaryModel = WeeklySummaryModel(category: weeklySummaryCategory, summary: weeklySummaryBook)

// Create the dummy HomeUiState instance
let dummyHomeUiState = HomeUiState(
    isLoading: false,
    weeklySummary: weeklySummaryModel,
    sections: sections,


    error: nil
)

let dummySummaries = [
    Summary(id: "1", title: "Start with Why", author: "Simon Sinek", synopsis: "A book about the importance of knowing your why.", coverImageUrl: "https://example.com/start-with-why.jpg", playingLength: "8h 35m", purchaseBookUrl: "https://example.com/start-with-why", categories: ["categoryId"]),
    Summary(id: "2", title: "Good to Great", author: "Jim Collins", synopsis: "A book about how companies transition from good to great.", coverImageUrl: "https://example.com/good-to-great.jpg", playingLength: "9h 58m", purchaseBookUrl: "https://example.com/good-to-great", categories: ["categoryId"]),
    Summary(id: "3", title: "Lean In", author: "Sheryl Sandberg", synopsis: "A book about women, work, and the will to lead.", coverImageUrl: "https://example.com/lean-in.jpg", playingLength: "7h 24m", purchaseBookUrl: "https://example.com/lean-in", categories: ["categoryId"]),
    Summary(id: "4", title: "The 4-Hour Workweek", author: "Tim Ferriss", synopsis: "A guide to escaping the 9-to-5 grind.", coverImageUrl: "https://example.com/4-hour-workweek.jpg", playingLength: "13h 12m", purchaseBookUrl: "https://example.com/4-hour-workweek", categories: ["categoryId"]),
    Summary(id: "5", title: "The Lean Startup", author: "Eric Ries", synopsis: "A book on how today's entrepreneurs use continuous innovation to create successful businesses.", coverImageUrl: "https://example.com/lean-startup.jpg", playingLength: "10h 34m", purchaseBookUrl: "https://example.com/lean-startup", categories: ["categoryId"]),
    Summary(id: "6", title: "Lean In", author: "Sheryl Sandberg", synopsis: "A book about women, work, and the will to lead.", coverImageUrl: "https://example.com/lean-in.jpg", playingLength: "7h 24m", purchaseBookUrl: "https://example.com/lean-in", categories: ["categoryId"]),
]

let SUMMARY_TEXT = """
### 1. **Introduction**

*Never Split the Difference: Negotiating As If Your Life Depended On It* is a book by Chris Voss with Tahl Raz, published in 2016. Chris Voss, a former FBI lead international hostage negotiator, shares advanced negotiation techniques based on his extensive experience dealing with high-stakes situations involving terrorists, kidnappers, and criminals. After his FBI career, Voss founded The Black Swan Group, a consulting firm that applies these negotiation strategies in business and personal contexts.

Tahl Raz, an award-winning journalist, co-authors the book, making Voss's methods clear and easy to understand.

The main thesis of *Never Split the Difference* is that effective negotiation is not about compromise but about understanding and influencing the other person's emotions and thoughts to achieve the best results. Voss argues that traditional negotiation tactics, which often focus on logical reasoning and splitting the difference, are not enough to get the best results. Instead, he promotes a more detailed approach that uses psychological principles and empathetic communication.

Key elements of this approach include:

- **Empathy:** Understanding and expressing the emotions and perspectives of the other person to build rapport and trust.
- **Active Listening:** Paying close attention to the other person's words and emotions, and responding in a way that shows you understand them.
- **Tactical Communication:** Using specific techniques like mirroring, labeling, and calibrated questions to guide the conversation and influence the other person's decisions.
- **Behavioral Psychology:** Using insights from behavioral psychology to predict and influence the other person's actions.

Voss illustrates these principles with real-life examples from his career as a hostage negotiator, showing how these techniques can be used in various negotiation scenarios, from high-stakes business deals to everyday personal interactions. The book provides practical tools and strategies that readers can use to improve their negotiation skills and achieve better outcomes without having to compromise.

### 2. **Key Concepts and Techniques**

#### **Mirroring**

**Definition:**
Mirroring is the technique of imitating the counterpart’s words to build rapport.

**Purpose:**
The main goal of mirroring is to encourage the other person to elaborate and feel understood. By repeating the last few words or the main idea of what the counterpart has said, you create a sense of connection and empathy.

**Example:**
If your counterpart says, "I'm worried about meeting the deadline," you can mirror by responding, "Meeting the deadline?" This simple repetition prompts the counterpart to expand on their thoughts, providing more information and fostering a deeper conversation.

#### **Tactical Empathy**

**Definition:**
Tactical empathy involves understanding the feelings and mindset of the counterpart and articulating them.

**Purpose:**
The purpose of tactical empathy is to build trust and open communication channels. By showing that you understand their perspective, you create an environment where the counterpart feels safe to share more information and engage in a collaborative dialogue.

**Example:**
If the counterpart expresses concern about the potential risks of a deal, you might respond, "I can see that you’re worried about the risks involved." This shows that you recognize and acknowledge their concerns, which can help to establish a more cooperative and trusting relationship.

#### **Accusation Audit**

**Definition:**
An accusation audit involves preemptively addressing potential accusations or negative perceptions that the counterpart might have.

**Purpose:**
The aim of an accusation audit is to neutralize negative dynamics and build credibility. By acknowledging potential criticisms before the counterpart brings them up, you disarm their objections and demonstrate honesty and transparency.

**Example:**
If you anticipate that the counterpart might think you are only interested in your own benefit, you might say, "You probably think I’m just looking out for my own interests here." This approach helps to clear the air and sets the stage for a more open and honest negotiation.

#### **Calibrated Questions**

**Definition:**
Calibrated questions are open-ended questions that start with “what” or “how.”

**Purpose:**
The purpose of calibrated questions is to encourage the counterpart to think and engage more deeply, allowing you to gather more information and guide the conversation without being confrontational. These questions help you to uncover the counterpart’s needs and concerns while keeping the dialogue constructive.

**Example:**
Instead of asking, "Do you agree with this proposal?" you might ask, "How do you see this proposal fitting into your plans?" This type of question prompts the counterpart to provide more detailed and insightful responses, facilitating a more productive negotiation.

#### **No-Oriented Questions**

**Definition:**
No-oriented questions are designed to get a “no” response from the counterpart.

**Purpose:**
The purpose of no-oriented questions is to empower the counterpart and clarify their boundaries. By framing questions in a way that makes it easy for the counterpart to say “no,” you help them feel in control and reduce defensiveness, leading to more honest and open communication.

**Example:**
Instead of asking, "Is this a good time to talk?" you might ask, "Is this a bad time to talk?" This allows the counterpart to say "no" comfortably, which can lead to a more relaxed and productive conversation.

#### **The F-word: Fair**

**Definition:**
Using the concept of fairness to reset or steer negotiations.

**Purpose:**
The aim of invoking fairness is to leverage the powerful human desire for equitable treatment. By framing the negotiation in terms of fairness, you can create a sense of balance and legitimacy, making it easier to reach an agreement that both parties feel good about.

**Example:**
If the counterpart feels that the negotiation is one-sided, you might say, "I want to make sure you feel this is a fair deal." This reassures them that their interests are being considered, which can help to rebuild trust and facilitate a more constructive negotiation process.

#### **Bending Reality**

**Definition:**
Bending reality involves influencing the counterpart’s perceptions to make your proposal more attractive.

**Purpose:**
The purpose of bending reality is to shape how the counterpart views the situation, making your offer seem more appealing by adjusting their expectations and framing the context positively. This technique helps you steer the negotiation toward a more favorable outcome without the need for drastic compromises.

**Example:**
If you want to make a financial offer seem more attractive, you might highlight the long-term benefits and savings: "While the initial investment is higher, this solution will save you significant costs over the next five years." This approach helps the counterpart see the value and benefits of your proposal in a broader context.

#### **Black Swans**

**Definition:**
Black swans are unexpected pieces of information that can change the course of a negotiation.

**Purpose:**
The purpose of identifying and leveraging black swans is to uncover hidden factors that can give you a significant advantage in the negotiation. These pieces of information are often crucial and can shift the dynamics, enabling you to find creative solutions and better deals.

**Example:**
During a negotiation, you might discover that the counterpart has an urgent deadline that wasn’t initially disclosed. By addressing this need and offering a solution that meets their timeline, you can significantly enhance your position and reach a more favorable agreement.

### **Application Scenarios**

#### **Business Negotiations**

**Applying the Techniques in Business Contexts:**
The negotiation strategies outlined in *Never Split the Difference* are particularly effective in business settings where stakes are high, and outcomes can significantly impact the bottom line. Techniques such as tactical empathy, calibrated questions, and labeling can help you build stronger relationships with clients, vendors, and partners. By understanding and addressing their needs and concerns, you can negotiate more favorable terms and create win-win situations.

**Case Studies and Examples:**
1. **Client Negotiation:** Suppose you are negotiating a contract with a new client. Using calibrated questions like "What are the most important outcomes you’re looking for in this partnership?" can help you uncover their priorities and tailor your proposal accordingly. Employing tactical empathy by acknowledging their concerns about budget constraints ("It sounds like staying within budget is crucial for you") builds trust and shows that you are considerate of their needs.

2. **Vendor Negotiation:** When negotiating with a vendor for better pricing or terms, an accusation audit can be beneficial. You might say, "You probably think I’m just trying to squeeze out a better deal for my company." This approach helps to address any negative perceptions the vendor might have and opens the door for a more honest discussion.

#### **Personal Negotiations**

**Using the Principles in Personal Life:**
The negotiation techniques from *Never Split the Difference* can also be applied in personal situations, such as family discussions, buying a car, or resolving disagreements with friends. These techniques help in creating more harmonious and productive interactions by focusing on understanding and addressing the emotions and perspectives of the other party.

**Illustrative Anecdotes:**
1. **Family Decisions:** When discussing vacation plans with family members, you can use mirroring to ensure everyone feels heard. For example, if someone says, "I want to go somewhere warm," you can mirror by responding, "Somewhere warm?" This encourages them to elaborate and share more details about their preferences.

2. **Buying a Car:** In negotiations with a car dealer, no-oriented questions can be effective. Instead of asking, "Can you lower the price?" you might ask, "Is it a bad idea to discuss a better price?" This approach makes the dealer feel more comfortable and less defensive, leading to a more constructive conversation.

3. **Resolving Friend Disagreements:** Labeling can be useful in resolving conflicts with friends. If a friend seems upset, you could say, "It seems like you’re feeling really frustrated with what happened." This shows empathy and understanding, helping to de-escalate the situation and foster open communication.

#### **Conflict Resolution**

**Implementing Strategies for Resolving Conflicts:**
The principles from *Never Split the Difference* are highly effective in conflict resolution, whether in professional or personal settings. Techniques like tactical empathy and labeling help to de-escalate tensions and facilitate more constructive dialogue. By addressing the underlying emotions and concerns, you can find common ground and work towards mutually acceptable solutions.

**Practical Advice and Scenarios:**
1. **Workplace Conflicts:** If there is a conflict between team members, using tactical empathy can help to understand both sides. For instance, saying, "I can see that you’re both very passionate about this project" acknowledges their emotions and sets the stage for a more productive discussion about how to move forward.

2. **Customer Complaints:** When dealing with an upset customer, labeling their emotions can be very effective. You might say, "It sounds like you’re really frustrated with the service you received." This shows that you are listening and understanding their feelings, which can help to calm the situation and lead to a resolution.

3. **Mediating Disputes:** In mediation scenarios, calibrated questions can guide the conversation towards solutions. Asking questions like, "How can we address both parties' concerns?" encourages those involved to think collaboratively and consider the needs of everyone involved.

### Key Takeaways

1. **Prepare Thoroughly**
   - Understand both your needs and the counterpart’s needs, goals, and constraints before entering a negotiation. Detailed preparation allows you to anticipate potential challenges and develop effective strategies.

2. **Listen Actively**
   - Focus on truly understanding the counterpart rather than just pushing your agenda. Active listening involves paying close attention to what the other person is saying and responding in a way that shows you comprehend their perspective.

3. **Stay Calm and Composed**
   - Maintain emotional control throughout the negotiation. Staying calm helps you think more clearly and react more strategically, even in high-pressure situations.

4. **Be Flexible and Creative**
   - Look for win-win solutions and think outside the box. Flexibility allows you to adapt to new information and changing circumstances, while creativity helps you find solutions that satisfy both parties.

5. **Leverage Empathy and Rapport**
   - Build strong connections with the counterpart by showing empathy and establishing rapport. Understanding their emotions and perspectives fosters trust and cooperation, making it easier to reach a mutually beneficial agreement.

6. **Ask Calibrated Questions**
   - Use open-ended questions starting with “what” or “how” to encourage the counterpart to provide more information and engage more deeply in the conversation. This helps you gather valuable insights and steer the negotiation in a constructive direction.

7. **Use Tactical Empathy**
   - Demonstrate understanding of the counterpart’s feelings and viewpoints. This technique helps to calm tensions and opens up more collaborative dialogue.

8. **Preemptively Address Negatives**
   - Conduct an accusation audit to address potential negative perceptions or objections before they become major issues. This proactive approach disarms criticism and builds credibility.

9. **Employ No-Oriented Questions**
   - Frame questions to get a “no” response, empowering the counterpart and reducing defensiveness. This approach makes them feel more in control and leads to more honest and open communication.

10. **Highlight Fairness**
    - Invoke the concept of fairness to create a sense of balance and legitimacy. Emphasizing fairness reassures the counterpart that their interests are being considered, facilitating a more constructive negotiation.

11. **Bend Reality with Framing**
    - Influence the counterpart’s perceptions by framing the context positively. Highlighting long-term benefits and adjusting expectations makes your proposal more appealing.

12. **Look for Black Swans**
    - Identify and leverage unexpected pieces of information that can shift the dynamics of the negotiation. These hidden factors often provide significant advantages and enable creative solutions.

### Conclusion

**Summary of Key Insights:**
*Never Split the Difference* by Chris Voss provides a wealth of advanced negotiation techniques derived from the high-stakes world of FBI hostage negotiations. The book emphasizes the importance of understanding and influencing the counterpart's emotions and thought processes rather than relying on traditional compromise-based tactics. Key concepts such as mirroring, labeling, tactical empathy, calibrated questions, no-oriented questions, and identifying black swans are central to this approach, offering practical tools to enhance negotiation outcomes.

**Practical Tips for Application:**
1. **Start Small:** Begin by applying these techniques in everyday situations to build your confidence and skills.
2. **Prepare and Research:** Thorough preparation and understanding of both your and the counterpart’s needs are crucial.
3. **Listen and Empathize:** Focus on active listening and demonstrating empathy to build rapport and trust.
4. **Use Strategic Questions:** Employ calibrated and no-oriented questions to guide the conversation and gather valuable information.
5. **Be Honest and Transparent:** Conduct accusation audits to address potential criticisms upfront, fostering a more open and honest dialogue.
6. **Stay Calm:** Maintain emotional control to think clearly and react strategically.
7. **Adapt and Be Creative:** Be flexible and look for innovative solutions that satisfy both parties.

**Final Thoughts:**
Negotiation is both an art and a science, requiring continuous practice and refinement. By incorporating the principles from *Never Split the Difference*, you can transform your approach to negotiation, whether in business, personal life, or conflict resolution. These techniques not only help you achieve better outcomes but also build stronger relationships and foster mutual respect. Remember, effective negotiation is about understanding and connecting with the other party, ultimately leading to more successful and satisfying agreements for everyone involved.

"""
