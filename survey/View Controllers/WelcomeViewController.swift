//
//  WelcomeViewController.swift
//  survey
//
//  Created by Selina Wang on 3/3/20.
//  Copyright © 2020 selina. All rights reserved.
//

import UIKit

class WelcomeViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func buttonPressed(_ sender: Any) {
        let consentVC = ConsentViewController()
        consentVC.modalPresentationStyle = .fullScreen
        consentVC.modalTransitionStyle = .flipHorizontal
        present(consentVC, animated: true, completion: nil)
    }
}
