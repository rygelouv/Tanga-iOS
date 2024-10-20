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
