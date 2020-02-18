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
    public var asr: SpeechPipeline?
    public var tts: TextToSpeech?
    
    public init() {
        let config = SpeechConfiguration()
        config.tracing = .DEBUG
        asr = SpeechPipeline(SpeechProcessors.appleSpeech.processor, speechConfiguration: config, speechDelegate: self, wakewordService: SpeechProcessors.appleWakeword.processor, pipelineDelegate: self)
        tts = TextToSpeech(self, configuration: config)
    }
    
    
    public func didTrace(_ trace: String) {
        <#code#>
    }
}

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
