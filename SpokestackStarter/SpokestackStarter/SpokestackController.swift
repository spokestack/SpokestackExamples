//
//  SpokestackController.swift
//  SpokestackStarter
//
//  Created by Noel Weichbrodt on 2/18/20.
//  Copyright © 2020 Spokestack, Inc. All rights reserved.
//

import Foundation
import Spokestack

public class SpokestackController {
    /// The Spokestack speech recognition component
    public var asr: SpeechPipeline
    
    /// The Spokestack text to speech component
    public var tts: TextToSpeech
    
    public init() {
        let config = SpeechConfiguration()
        // send debug events to `didTrace`
        config.tracing = .DEBUG
        asr = SpeechPipeline(SpeechProcessors.appleSpeech.processor, speechConfiguration: config, speechDelegate: self, wakewordService: SpeechProcessors.appleWakeword.processor, pipelineDelegate: self)
        tts = TextToSpeech(self, configuration: config)
    }
    
    /// - TODO: remove the Editor placeholder for `didTrace`. It can be as simple as `print(trace)`. This function is common amongst the asr and tts delegates.
    public func didTrace(_ trace: String) {
        <#code#>
    }
}

/// - TODO: remove the Editor placeholder for `SpeechEventListener` implementation. It can be as simple as `print("SpeechEventListener")`
extension SpokestackController: SpeechEventListener {
    public func activate() {
        <#code#>
    }
    
    public func deactivate() {
        <#code#>
    }
    
    public func didError(_ error: Error) {
        <#code#>
    }
    
    public func didRecognize(_ result: SpeechContext) {
        <#code#>
    }
    
    public func didTimeout() {
        <#code#>
    }
}

/// - TODO: remove the Editor placeholder for `PipelineDelegate` implementation. It can be as simple as `print("PipelineDelegate")`
extension SpokestackController: PipelineDelegate {
    public func didInit() {
        <#code#>
    }
    
    public func didStart() {
        <#code#>
    }
    
    public func didStop() {
        <#code#>
    }
    
    public func setupFailed(_ error: String) {
        <#code#>
    }
}

/// - TODO: remove the Editor placeholder for `TextToSpeechDelegate` implementation. It can be as simple as `print("TextToSpeechDelegate")`
extension SpokestackController: TextToSpeechDelegate {
    public func success(result: TextToSpeechResult) {
        <#code#>
    }
    
    public func failure(error: Error) {
        <#code#>
    }
    
    public func didBeginSpeaking() {
        <#code#>
    }
    
    public func didFinishSpeaking() {
        <#code#>
    }
}
