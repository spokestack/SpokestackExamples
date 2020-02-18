//
//  AppDelegate.swift
//  SpokestackStarter
//
//  Created by Noel Weichbrodt on 2/18/20.
//  Copyright © 2020 Spokestack, Inc. All rights reserved.
//

import UIKit
import AVFoundation

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var newBluetoothAvailable: Bool?
    var usingBluetoothInput: Bool?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(audioRouteChanged),
                                               name: AVAudioSession.routeChangeNotification,
                                               object: AVAudioSession.sharedInstance())
        let session: AVAudioSession = AVAudioSession.sharedInstance()
        let sessionCategory: AVAudioSession.Category = .playAndRecord
        let sessionOptions: AVAudioSession.CategoryOptions = [.allowBluetoothA2DP, .allowAirPlay, .defaultToSpeaker]
        do {
            // try session.setPreferredIOBufferDuration(0.01)
            if ((session.category != sessionCategory) || !(session.categoryOptions.contains(sessionOptions))) { // TODO: add (session.ioBufferDuration != self.bufferDuration) once mode-based wakeword is enabled
                try session.setCategory(sessionCategory, mode: .default, options: sessionOptions)
                // TODO: The below line implicitly disables HFP output. Investigate buffer duration versus bluetooth output settings.
                // try session.setPreferredIOBufferDuration(self.bufferDuration)
                try session.setActive(true, options: .notifyOthersOnDeactivation)
            }
        } catch {
            print("AppDelegate application error when setting AudioSession category")
        }
        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }

    @objc private func audioRouteChanged(_ notification: Notification) {
        guard let userInfo = notification.userInfo,
            let reasonValue = userInfo[AVAudioSessionRouteChangeReasonKey] as? UInt,
            let reason = AVAudioSession.RouteChangeReason(rawValue:reasonValue) else {
                return
        }
        switch reason {
        case .newDeviceAvailable:
            self.newBluetoothAvailable = true
            // useBluetoothHFPInput()
            break
        case .oldDeviceUnavailable:
            self.newBluetoothAvailable = false
            self.usingBluetoothInput = false
        default:
            break
        }
    }
    
    @objc private func useBluetoothHFPInput() {
        print("AppDelegate useBluetoothHFPInput")
        let session = AVAudioSession.sharedInstance()
        guard let inputs = session.availableInputs else {
            return
        }
        for input in inputs {
            if (input.portType == AVAudioSession.Port.bluetoothHFP) {
                do {
                    try session.setPreferredInput(input)
                    self.newBluetoothAvailable = false
                } catch {
                    print("AppDelegate useBluetoothHFPInputIfAvailable error")
                }
            }
        }
    }
    
    public func useBluetoothHFPInputIfAvailable() {
        print("AppDelegate useBluetoothHFPInputIfAvailable")
        let session = AVAudioSession.sharedInstance()
        do {
            try session.setCategory(.playAndRecord, mode: .default, options: [.allowBluetoothA2DP, .allowAirPlay, .defaultToSpeaker, .allowBluetooth])
            try session.setActive(true, options: .notifyOthersOnDeactivation)
            self.useBluetoothHFPInput()
            self.usingBluetoothInput = true
        } catch {
            print("AppDelegate useBluetoothHFPInputIfAvailable error when setting AudioSession category")
        }
    }
    
    public func useA2DPOutputIfAvailable() {
        print("AppDelegate useA2DPOutputIfAvailable")
        let session = AVAudioSession.sharedInstance()
        do {
            try session.setCategory(.playAndRecord, mode: .default, options: [.allowBluetoothA2DP, .allowAirPlay, .defaultToSpeaker])
            try session.setActive(true, options: .notifyOthersOnDeactivation)
        } catch {
            print("AppDelegate useA2DPOutputIfAvailable error when setting AudioSession category")
        }
    }
    
    public func switchInputsIfAvailable() {
        print("AppDelegate switchInputsIfAvailable")
        if self.newBluetoothAvailable ?? false {
            print("AppDelegate switchInputsIfAvailable newBluetoothAvailable")
            if self.usingBluetoothInput ?? false {
                print("AppDelegate switchInputsIfAvailable usingBluetoothInput")
            } else {
                self.useBluetoothHFPInputIfAvailable()
            }
        } else {
            self.useA2DPOutputIfAvailable()
        }
    }
}

