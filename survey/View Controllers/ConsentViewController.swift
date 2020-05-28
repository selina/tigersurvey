//
//  ConsentViewController.swift
//  survey
//
//  Created by Selina Wang on 3/3/20.
//  Copyright © 2020 selina. All rights reserved.
//

import UIKit

class ConsentViewController: UIViewController {
    
    @IBOutlet var formText: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    @IBAction func declinePressed(_ sender: Any) {
        let welcomeVC = WelcomeViewController()
        welcomeVC.modalPresentationStyle = .fullScreen
        present(welcomeVC, animated: true, completion: nil)
    }
    
    @IBAction func consentPressed(_ sender: Any) {
        // store in user defaults that consent has been provided
        UserDefaults.standard.set(true, forKey: "consented")
        Helper.shared.postTo(survey: "consented", data: ["datetime": Date()])
        
        // start push notifications once consent is gathered
        let appDelegate = UIApplication.shared.delegate as? AppDelegate
        appDelegate?.setupNotifications()
        appDelegate?.updateFirestorePushTokenIfNeeded()
        
        let homeVC = HomeViewController()
        homeVC.modalPresentationStyle = .fullScreen
        present(homeVC, animated: true) {
            let surveyVC = SurveyViewController(source: InitialSurveyQuestions.datasource())
            surveyVC.modalPresentationStyle = .fullScreen
            homeVC.present(surveyVC, animated: false, completion: nil)
        }
    }
}
