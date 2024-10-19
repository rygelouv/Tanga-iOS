//
//  FirestoreDatabase.swift
//  Tanga
//
//  Created by Rygel Louv on 07/10/2024.
//

import Foundation

struct FirestoreDatabase {

    struct Users {
        // Collection Reference
        static let COLLECTION_NAME = "users"

        // Fields
        struct Fields {
            static let UID = "uid"
            static let FULL_NAME = "fullName"
            static let EMAIL = "email"
            static let PHOTO_URL = "photoUrl"
            static let CREATED_AT = "createdAt"
            static let SUBSCRIBED_AT = "subscribedAt"
        }
    }

    struct Summaries {
        // Collection Reference
        static let COLLECTION_NAME = "summaries"

        // Fields
        struct Fields {
            static let SLUG = "slug"
            static let TITLE = "title"
            static let AUTHOR = "author"
            static let SYNOPSIS = "synopsis"
            static let CATEGORIES = "categories"
            static let IS_VISIBLE = "isVisible"
            static let COVER_IMAGE_URL = "coverImageUrl"
            static let PLAYING_LENGTH = "playingLength"
            static let PURCHASE_BOOK_URL = "purchaseBookUrl"
        }
    }

    struct Categories {
        // Collection Reference
        static let COLLECTION_NAME = "categories"

        // Fields
        struct Fields {
            static let NAME = "name"
            static let SLUG = "slug"
        }
    }

    struct Favorites {
        // Collection Reference
        static let COLLECTION_NAME = "favorites"

        // Fields
        struct Fields {
            static let UID = "uid"
            static let TITLE = "title"
            static let AUTHOR = "author"
            static let COVER_URL = "coverUrl"
            static let USER_ID = "userId"
            static let SUMMARY_ID = "summaryId"
            static let PLAYING_LENGTH = "playingLength"
        }
    }

    struct WeeklySummary {
        // Collection Reference
        static let COLLECTION_NAME = "weeklySummary"

        // Fields
        struct Fields {
            static let SLUG = "slug"
        }
    }
}
