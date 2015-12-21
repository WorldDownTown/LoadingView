//
//  ViewController.swift
//  LoadingView
//
//  Created by shoji on 2015/12/21.
//  Copyright © 2015年 com.shoji. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, Int64(1.0 * Double(NSEC_PER_SEC))), dispatch_get_main_queue()) {
            LoadingView.show()
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, Int64(1.0 * Double(NSEC_PER_SEC))), dispatch_get_main_queue()) {
                LoadingView.showMessage("errorです") {}
            }
        }
    }
}
