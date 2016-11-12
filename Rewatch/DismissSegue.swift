//
//  DismissSegue.swift
//  Rewatch
//
//  Created by Petr Reshetin on 11/11/2016.
//  Copyright © 2016 Petr Reshetin. All rights reserved.
//

import UIKit

@objc(DismissSegue) class DismissSegue: UIStoryboardSegue {
    override func perform() {
        if let controller = source.presentingViewController {
            controller.dismiss(animated: true, completion: nil)
        }
    }
}
