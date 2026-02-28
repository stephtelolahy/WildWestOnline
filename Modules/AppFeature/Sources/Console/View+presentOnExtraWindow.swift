//
//  View+presentOnExtraWindow.swift
//  WildWestOnline
//
//  Created by Hugues Stéphano TELOLAHY on 28/02/2026.
//

import SwiftUI

#if canImport(UIKit)
import UIKit

extension View {
    func presentOnExtraWindow() {
        ViewControllerOverExtraWindow(rootView: self)
            .present()
    }
}

private class ViewControllerOverExtraWindow<T: View>: UIHostingController<T> {
    func present() {
        guard UIViewController.extraWindow == nil else {
            UIViewController.extraWindow?.rootViewController?.dismiss(animated: true) { [weak self] in
                self?.hideExtraWindow()
            }
            return
        }

        guard let scene = UIApplication.shared.connectedScenes.first as? UIWindowScene else {
            return
        }

        let newWindow = UIWindow(windowScene: scene)
        newWindow.frame = UIScreen.main.bounds
        newWindow.windowLevel = .alert

        let newRootVC = UIViewController()
        newRootVC.view.backgroundColor = UIColor.clear
        newWindow.rootViewController = newRootVC
        newWindow.makeKeyAndVisible()

        UIViewController.extraWindow = newWindow
        newRootVC.present(self, animated: true)
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        hideExtraWindow()
    }

    private func hideExtraWindow() {
        UIViewController.extraWindow?.isHidden = true
        UIViewController.extraWindow = nil
    }
}

private extension UIViewController {
    static var extraWindow: UIWindow?
}
#else
// Fallback for platforms without UIKit (e.g., macOS)
extension View {
    func presentOnExtraWindow() {
        // No-op on platforms that don't support UIKit windows.
    }
}
#endif
