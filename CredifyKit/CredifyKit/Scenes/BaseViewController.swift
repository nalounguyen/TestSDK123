//
//  BaseViewController.swift
//  CredifyKit
//
//  Created by Nalou Nguyen on 18/03/2021.
//  Copyright © 2021 Credify. All rights reserved.
//

import UIKit

class BaseViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        localization()
    }
    
    func localization() { }
    
    deinit {
        print("\(self) is deinit")
    }

}
