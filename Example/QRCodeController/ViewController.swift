//
//  ViewController.swift
//  QRCodeController
//
//  Created by Diego Marcon on 06/23/2016.
//  Copyright (c) 2016 Diego Marcon. All rights reserved.
//

import UIKit
import QRCodeController

class ViewController: UIViewController {

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        let viewController = QRCodeController()
        
        viewController.callback = { result in
            print(result)
        }
        
        present(viewController, animated: true, completion: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
