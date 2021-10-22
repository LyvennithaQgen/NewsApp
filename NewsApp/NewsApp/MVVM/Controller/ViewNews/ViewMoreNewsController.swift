//
//  ViewMoreNewsController.swift
//  NewsApp
//
//  Created by Lyvennitha on 22/10/21.
//

import Foundation
import UIKit
import WebKit

class ViewMoreNewsController: UIViewController{
    @IBOutlet weak var webView: WKWebView!
    @IBOutlet weak var titleText: UILabel!
    
    var urlStriing = ""
    var titleStr = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        webView.load(NSURLRequest(url: NSURL(string: urlStriing)! as URL) as URLRequest)
        titleText.text = titleStr
    }
}
