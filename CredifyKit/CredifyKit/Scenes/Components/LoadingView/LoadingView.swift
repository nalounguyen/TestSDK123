//
//  LoadingView.swift
//  Credify
//
//  Created by ShuichiNagao on 2019/06/03.
//  Copyright © 2019 Credify. All rights reserved.
//

import UIKit
import Lottie

class LoadingView: UIView {
    private static let view: AnimationView = {
        let v = AnimationView(name: "credify-loading", bundle: .CredifyKit)
        v.frame = UIApplication.shared.keyWindow!.bounds
        v.center = UIApplication.shared.keyWindow!.center
        v.loopMode = .loop
        v.contentMode = .scaleAspectFill
        v.animationSpeed = 1
        v.backgroundColor = UIColor.named("LoadingBackground")
        return v
    }()
    
    /// Displays loading view. This should be called on main thread.
    static func start() {
        DispatchQueue.main.async {
            UIApplication.shared.keyWindow?.addSubview(view)
            UIApplication.shared.keyWindow?.topViewController()?.view.isUserInteractionEnabled = false
            view.play()
        }
    }
    
    /// Removes loading view. This should be called on main thread.
    static func stop() {
        DispatchQueue.main.async {
            UIApplication.shared.keyWindow?.topViewController()?.view.isUserInteractionEnabled = true
            self.view.removeFromSuperview()
        }
    }
}

extension UIWindow {
    func topViewController() -> UIViewController? {
        var top = self.rootViewController
        while true {
            if let presented = top?.presentedViewController {
                top = presented
            } else if let nav = top as? UINavigationController {
                top = nav.visibleViewController
            } else if let tab = top as? UITabBarController {
                top = tab.selectedViewController
            } else {
                break
            }
        }
        return top
    }
}
