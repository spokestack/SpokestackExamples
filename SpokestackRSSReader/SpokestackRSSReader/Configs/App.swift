//
//  App.swift
//  SpokestackRSSReader
//
//  Created by Cory Wiles on 11/20/19.
//  Copyright © 2019 Spokestack. All rights reserved.
//

import Foundation

struct App {

    /// Message that is read when the app starts up
    
    static let welcomeMessage: String = "Welcome to the latest TechCrunch Headlines"
    
    /// Time delay (in seconds) between reading each headline
    
    static let actionDelay: TimeInterval = 6.5
    
    /// Button text on each item card
    
    static let actionPhrase: String = "Tell me more"
    
    /// Message that is read when all headlines have been read
    
    static let finishedMessage: String = "You're all caught up"
    
    struct Feed {
        
        /// Text for navigation bar
        
        static let heading: String = "TechCrunch"
        
        /// RSS Feed
        /// Atom, JSON and RSS are supported
        
        static let feedURL: String = "https://feeds.feedburner.com/TechCrunch/"
        
        /// The number of articles to display and read

        static let numberOfItemsToDisplay: Int = 5
    }
}
