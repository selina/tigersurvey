//
//  HomeViewController.swift
//  survey
//
//  Created by Selina Wang on 3/3/20.
//  Copyright © 2020 selina. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet var tv: UITableView!
    @IBOutlet var logTodayButton: UIButton!
    
    @IBOutlet var daysLoggedLabel: UILabel!
    
    @IBOutlet var progressStack: UIStackView!
    
    var data: [String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tv.dataSource = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        loadHistory()
        setupButton()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if (data.count >= 7 && !UserDefaults.standard.bool(forKey: "thanked")) {
            let popupVC = PopupViewController(text: "you made it to the end! 🎉🎉🎉 thank you so very much for your sustained participation--it will not be in vain! we would love to hear your thoughts as a participant; please email sw24@princeton.edu if you would like to share your opinion.", image: nil)
            
            present(popupVC, animated: true, completion: nil)
            UserDefaults.standard.set(true, forKey: "thanked")
            
            let center = UNUserNotificationCenter.current()
            center.removeAllPendingNotificationRequests()
        }
    }
    
    func loadHistory() {
        Helper.shared.getLoggedDates { (d: [String]) in
            self.data = d
            self.reload()
        }
    }
    
    func reload() {
        tv.reloadData()
        
        var count = max(data.count, 0) // lower bound at 0 days
        daysLoggedLabel.text = "\(count) / 7 days complete!"
        
        if count > 0 {
            count = min(count, 7) // upper bound at 7 days
            for i in 1...count {
                if let view = progressStack.viewWithTag(i) {
                    view.backgroundColor = UIColor(named: "textColor")
                }
            }
        }
    }
    
    func setupButton() {
        if Helper.shared.isLoggingAllowed {
            logTodayButton.backgroundColor = UIColor(named: "textColor")
            logTodayButton.borderColor = UIColor(named: "textColor")
        }
        else {
            logTodayButton.backgroundColor = UIColor.gray
            logTodayButton.borderColor = UIColor.gray
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        cell.textLabel?.text = "✅ " + data[indexPath.row]
        cell.backgroundColor = .clear
        cell.textLabel?.textColor = UIColor(named: "textColor")
        return cell
    }
    
    @IBAction func logTodayPressed(_ sender: UIButton) {
        if Helper.shared.isLoggingAllowed {
            let surveyVC = SurveyViewController(source: DailySurveyQuestions.datasource())
            surveyVC.modalPresentationStyle = .fullScreen
            present(surveyVC, animated: true, completion: nil)
        } else {
            let popupVC = PopupViewController(text: "Please come back during the hours of 8 PM tonight to 12 PM tomorrow to log today's usage!", image: nil)

            present(popupVC, animated: true, completion: nil)
        }
        
//        let surveyVC = SurveyViewController(source: DailySurveyQuestions.datasource())
//        surveyVC.modalPresentationStyle = .fullScreen
//        present(surveyVC, animated: true, completion: nil)
    }
}
