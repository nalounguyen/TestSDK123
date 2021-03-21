//
//  WKWebViewViewController.swift
//  Credify
//
//  Created by ShuichiNagao on 2019/08/05.
//  Copyright © 2019 Credify. All rights reserved.
//

import UIKit
import WebKit
import QuickLook
@_implementationOnly import CredifyCore

class WKWebViewViewController: UIViewController {

    @IBOutlet private weak var webView: WKWebView!
    @IBOutlet private weak var navBar: UINavigationBar!
    @IBOutlet private weak var navItem: UINavigationItem!
    
    private var url: URL!
    private var pageTitle: String!
    var dismissAction: (() -> Void)?
    
    static func instantiate(url urlString: String, title: String = "") -> WKWebViewViewController {
        let sb = UIStoryboard(name: "WKWebView", bundle: Bundle(for: WKWebViewViewController.self))
        let vc = sb.instantiateInitialViewController() as! WKWebViewViewController
        let u = URL(string: urlString)!
        vc.url = u
        vc.pageTitle = title
        return vc
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        navItem.title = pageTitle
//        navBar.titleTextAttributes = [NSAttributedString.Key.font: UIFont.abeatbyKai(), NSAttributedString.Key.foregroundColor: UIColor.ex.white]
        navBar.tintColor = UIColor.ex.primaryText
        navBar.backgroundColor = UIColor.ex.backgroundDark
        
        webView.load(URLRequest(url: url))
        webView.allowsBackForwardNavigationGestures = true
        navItem.rightBarButtonItem?.tintColor = UIColor.ex.primary
        webView.addObserver(self, forKeyPath: #keyPath(WKWebView.title), options: .new, context: nil)
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == "title" ,
           let curentTitle = navItem.title, curentTitle.isEmpty {
            navItem.title = webView.title
        }
    }
    
    @IBAction func cancel(_ sender: Any) {
        if let nav = navigationController {
            nav.dismiss(animated: true, completion: {
                OfferManager.shared.redeemSuccessEventSubject.onNext(true)
            })
        }else {
            dismiss(animated: true) { [weak self]  in
                self?.dismissAction?()
            }
        }
        
    }
    
}

extension WKWebViewViewController: WKNavigationDelegate {
    
}
