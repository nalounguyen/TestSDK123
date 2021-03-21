//
//  UIApplication+Extension.swift
//  CredifyKit
//
//  Created by Nalou Nguyen on 16/03/2021.
//

import UIKit

extension UIApplication {
    func topMostViewController() -> UIViewController? {
        return self.keyWindow?.rootViewController?.topMostViewController()
    }
}
