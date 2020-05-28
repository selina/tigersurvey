//
//  SurveyViewController.swift
//  survey
//
//  Created by Selina Wang on 3/3/20.
//  Copyright © 2020 selina. All rights reserved.
//

import UIKit

class SurveyViewController: UIViewController, UITableViewDelegate, CanReceiveDataChanges {
      
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var progressBar: UIProgressView!
    @IBOutlet var tv: UITableView!
    @IBOutlet var proceedButton: UIButton!
    
    var dataSource: SurveyDataSource
    
    var imageCompletion: ((UIImage) -> ())?
    
    init(source: SurveyDataSource) {
        self.dataSource = source
        Helper.shared.postTo(survey: dataSource.surveyID, data: ["begun": Date()])
        super.init(nibName: "SurveyViewController", bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        tv.delegate = self
        tv.dataSource = dataSource
        dataSource.delegate = self
        dataSource.imgDelegate = self
        
        progressBar.progress = dataSource.progress
        titleLabel.text = dataSource.surveyTitle
        titleLabel.adjustsFontSizeToFitWidth = true
        
        tv.rowHeight = UITableView.automaticDimension
        tv.estimatedRowHeight = 600
    }
    
    @IBAction func nextPressed(_ sender: Any) {
        dataSource.nextPage()
    }
    
    func reload(progress: Float) {
        tv.reloadData()
        let topIndex = IndexPath(row: 0, section: 0)
        tv.scrollToRow(at: topIndex, at: .top, animated: false)
        progressBar.setProgress(progress, animated: true)
        if progress == 1.0 {
            proceedButton.setTitle("Done", for: .normal)
        }
    }
       
    func dismiss() {
        Helper.shared.postTo(survey: dataSource.surveyID, data: ["completed": Date()])
        if (dataSource.surveyID == "initial") {
            UserDefaults.standard.set(true, forKey: "initialized")
        }
        self.dismiss(animated: true, completion: nil)
    }
}

extension SurveyViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate, CanPullUpImagePicker {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let userImg = info[.originalImage] as! UIImage
        self.imageCompletion?(userImg)
        dismiss(animated: true, completion: nil)
    }
    
    func pullUpImagePicker(completion: @escaping (UIImage) -> ()) {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.allowsEditing = false
        imagePicker.sourceType = .photoLibrary
        self.imageCompletion = completion
        present(imagePicker, animated: true, completion: nil) 
    }
    
    func showHelp() {
        let img = UIImage(named: "example")
        let popupVC = PopupViewController(text: "navigate to Settings > Screen Time > See All Activity, then make sure the Day tab is selected and scroll down to Most Used.", image: img)
        present(popupVC, animated: true, completion: nil)
    }
    
}

protocol CanReceiveDataChanges {
    func dismiss()
    func reload(progress: Float)
}

class SurveyDataSource: NSObject, UITableViewDataSource {
    var currentPage = 0
    var pages: [[Question]]
    
    var delegate: CanReceiveDataChanges?
    var imgDelegate: CanPullUpImagePicker?
    
    var surveyTitle: String
    var surveyID: String
    
    var progress: Float {
        get {
            return Float((currentPage + 1)) / Float(pages.count)
        }
    }
    
    init(pages: [[Question]], surveyTitle: String, surveyID: String) {
        self.pages = pages
        self.surveyTitle = surveyTitle
        self.surveyID = surveyID
    }
    
    func nextPage() {
        if currentPage + 1 >= pages.count {
            // save and dismiss
            delegate?.dismiss()
        } else {
            currentPage += 1
            delegate?.reload(progress: progress)
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return pages[currentPage].count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let currentQuestion = pages[currentPage][indexPath.row]
        let cell = SurveyCell()
        switch currentQuestion.questionType {
        case .mc, .textbox:
            Helper.shared.getResponse(forSurvey: self.surveyID, question: currentQuestion.questionID) { (existingResponse) in
                if let e = existingResponse {
                    cell.load(e, currentQuestion.questionType)
                }
            }
        default:
            break
        }
       
        cell.surveyID = self.surveyID
        cell.setup(question: currentQuestion)
        cell.imgPickerDelegate = self.imgDelegate
        return cell
    }
}

