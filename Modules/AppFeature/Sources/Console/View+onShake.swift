//
//  DeviceShakeViewModifier.swift
//  WildWestOnline
//
//  Created by Hugues Stéphano TELOLAHY on 28/02/2026.
//

import SwiftUI
#if canImport(UIKit)
import UIKit
#endif

// Shake gesture for SwiftUI
// From: https://www.hackingwithswift.com/quick-start/swiftui/how-to-detect-shake-gestures
extension View {
    /// Calls `action` when a device shake gesture is detected.
    /// - Parameter action: A closure executed on the main thread when a shake is detected.
    func onShake(perform action: @escaping () -> Void) -> some View {
        self.modifier(DeviceShakeViewModifier(action: action))
    }
}

#if canImport(UIKit)
// Strongly-typed notification name to avoid stringly-typed APIs.
extension Notification.Name {
    static let deviceDidShake = Notification.Name("deviceDidShakeNotification")
}

//  Override the default behavior of shake gestures to send our notification instead.
extension UIWindow {
    // swiftlint:disable:next override_in_extension
    override open func motionEnded(_ motion: UIEvent.EventSubtype, with event: UIEvent?) {
        if motion == .motionShake {
            NotificationCenter.default.post(name: .deviceDidShake, object: nil)
        }
    }
}
#endif

struct DeviceShakeViewModifier: ViewModifier {
    let action: () -> Void

    func body(content: Content) -> some View {
        #if canImport(UIKit)
        return content
            .onReceive(
                NotificationCenter.default
                    .publisher(for: .deviceDidShake)
                    .receive(on: RunLoop.main)
            ) { _ in
                action()
            }
        #else
        return content
        #endif
    }
}
