//
//  AlertController.swift
//  CredifyKit
//
//  Created by Nalou Nguyen on 16/03/2021.
//  Copyright © 2021 Credify. All rights reserved.
//

import UIKit

class AlertController: UIAlertController {
    private lazy var alertWindow: UIWindow = {
        let window = UIWindow(frame: UIScreen.main.bounds)
        window.rootViewController = ClearViewController()
        window.backgroundColor = UIColor.clear
        window.windowLevel = UIWindow.Level.alert
        return window
    }()
    
    /// Shows a custom alert controller.
    func show(animated flag: Bool = true, completion: (() -> Void)? = nil) {
//        guard let rootVC = alertWindow.rootViewController else { return }
//        alertWindow.makeKeyAndVisible()
        guard let rootVC = UIApplication.shared.topMostViewController() else { return }
        rootVC.present(self, animated: flag, completion: completion)
    }
}

private class ClearViewController: UIViewController {
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return UIApplication.shared.statusBarStyle
    }
    
    override var prefersStatusBarHidden: Bool {
        return UIApplication.shared.isStatusBarHidden
    }
}
