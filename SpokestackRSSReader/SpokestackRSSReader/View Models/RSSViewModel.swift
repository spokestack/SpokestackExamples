//
//  RSSViewModel.swift
//  SpokestackRSSReader
//
//  Created by Cory Wiles on 11/15/19.
//  Copyright © 2019 Spokestack. All rights reserved.
//

import Foundation
import Combine
import AVFoundation
import UIKit

private let workItemQueue: DispatchQueue = DispatchQueue(label: "com.spokestack.workitem.queue")

/// Transform RSSFeedItem  information into values that can be displayed on a view.
/// To aid in state management it is an `ObserverableObject`
class RSSViewModel: ObservableObject {

    // MARK: Interneal (properties)
    
    /// Read-only list of `RSSFeedItem`'s.
    /// It will be published to any subscribers
    @Published private (set) var feedItems: Array<RSSFeedItem> = [] {
        
        didSet {
            self.queuedItems = feedItems
        }
    }
    
    /// Optional `RSSFeedItem` instance
    /// It will be published to any subscribers
    @Published private (set) var currentItem: RSSFeedItem?
    
    // MARK: Private (properties)
    
    /// Whether or not the current item's description is being read
    private var processingCurrentItemDescription: Bool = false
    
    /// `SpeechController` instance
    private var speechController: SpeechController = SpeechController()
    
    /// Holds instances of `AnyCancellable` which will be cancled on deallocation
    private var subscriptions = Set<AnyCancellable>()
    
    /// `DispatchWorkItem` instance that is used to read the current item's desc.
    /// It will be cancelled and the next headline will be read if the time exceeds
    /// `App.actionDelay`
    private var workerItem: DispatchWorkItem!
    
    /// Whether or not the entire feed has finished processing. When `true` the `App.finishedMessage`
    /// is synthesized
    private var isFinished: Bool = false
    
    /// Whether or not  the `App.welcomeMessage` has not been synthensized. If it hasn't and the
    /// the `feedItems` property is not empty then call `processHeadlines`
    private var shouldAnnounceWelcome: Bool = true {
        
        didSet {
            
            if !shouldAnnounceWelcome {
    
                if !self.feedItems.isEmpty {
                    self.processHeadlines()
                }
            }
        }
    }
    
    /// Array of `RSSFeedItem`'s. Once an an item has finished playing it is removed from
    /// the list.
    private var queuedItems: Array<RSSFeedItem> = []
    
    // MARK: Initializers
    
    init() {}
    
    // MARK: Internal (methods)
    
    /// Passes the rss feed item description to the speech controller for processing
    /// This will pause the next headline from being "read".
    /// - Parameter description: `RSSFeedItem.description`
    /// - Returns: Void
    func readArticleDescription(_ description: String) -> Void {
        
        self.processingCurrentItemDescription = true
        self.speechController.respond(description)
    }
    
    /// Handles the logic of announcing the welcome text, loading the feed and
    /// setting up the `speechController.textPublisher`
    /// - Returns: Void
    func activateSpeech() -> Void {
        
        if self.shouldAnnounceWelcome {

            self.speechController.respond(App.welcomeMessage)
            self.load()

        } else {

            self.load()
        }

        self.speechController.textPublisher.sink( receiveCompletion: { _ in },
                                                  receiveValue: { [unowned self] value in
            
                                                    self.readArticleDescription(self.currentItem!.description)
        })
        .store(in: &self.subscriptions)
    }
    
    /// Deactivates the `speechController`'s pipleline ASR.
    /// - Returns: Void
    func deactiveSpeech() -> Void {
        self.speechController.deactivatePipelineASR()
    }
    
    // MARK: Private (methods)
    
    /// Loads / parses the rss feed
    /// - Returns: Void
    private func load() -> Void {
        
        let feedURL: URL = URL(string: App.Feed.feedURL)!
        let rssController: RSSController = RSSController(feedURL)
        
        rssController.parseFeed({[unowned self] feedItems in
            
            self.feedItems = feedItems
            /// Tell the speech controller to cache mp3's and then send publisher that it is done
            self.shouldAnnounceWelcome.toggle()
        })
    }
    
    /// Processes each headline after it has finished playing
    /// It is called after the `shouldAnnounceWelcome` has been set to false
    /// - Returns: Void
    private func processHeadlines() -> Void {

        UIApplication.shared.isIdleTimerDisabled = true
        
        self.speechController.itemFinishedPublisher.sink(receiveCompletion: {_ in }, receiveValue: {value in

            self.processingCurrentItemDescription = false

            /// The "welcome" has finished playing, but none of the headlines  have been read if the feed items
            /// and the queued items are the same
            
            if self.feedItems.count == self.queuedItems.count {
                
                if let item: RSSFeedItem = self.queuedItems.first {

                    self.queuedItems.remove(at: 0)
                    self.currentItem = item
                    self.speechController.respond(item.title)
                }
                
            } else if !self.queuedItems.isEmpty {

                self.workerItem = DispatchWorkItem { [weak self] in
                    
                    guard let strongSelf = self else {
                        return
                    }
                    
                    if !strongSelf.workerItem.isCancelled {
                        print("Not cancelled so start")
                        strongSelf.speechController.activatePipelineASR()
                    } else {
                        print("The work item is cancelled")
                        strongSelf.speechController.stop()
                    }
                    
                    self?.workerItem = nil
                }
                
                workItemQueue.async(execute: self.workerItem)
                workItemQueue.asyncAfter(deadline: .now() + App.actionDelay) {[weak self] in
                    
                    DispatchQueue.main.async {
                        self?.workerItem?.cancel()
                        self?.processNextItem()
                    }
                }
                
            } else {

                if !self.isFinished {
                
                    self.speechController.respond(App.finishedMessage)
                    self.isFinished.toggle()
                    UIApplication.shared.isIdleTimerDisabled = false
                }
            }
            
        }).store(in: &self.subscriptions)
    }
    
    /// Handles processing the next `RSSFeedItem` in the `queuedItems`
    /// if there is one
    /// - Returns: Void
    private func processNextItem() -> Void {
        
        if self.processingCurrentItemDescription {
            return
        }

        if let nextItem: RSSFeedItem = self.queuedItems.first {
   
             self.queuedItems.remove(at: 0)
             self.currentItem = nextItem
             self.speechController.respond(nextItem.title)
        }
    }
}

