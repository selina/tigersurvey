//
//  SurveyCell.swift
//  jp
//
//  Created by Selina Wang on 3/1/20.
//  Copyright © 2020 selina. All rights reserved.
//

import UIKit

protocol CanPullUpImagePicker {
    func pullUpImagePicker(completion: @escaping (UIImage) -> ())
    func showHelp()
}

class SurveyCell: UITableViewCell, UITextFieldDelegate {
    var question: Question?
    
    var imgPickerDelegate: CanPullUpImagePicker?
    
    var surveyID: String = ""
    
    var questionTitle: UILabel = {
        let label = UILabel()
        label.textColor = UIColor(named: "textColor")
        label.font = UIFont.systemFont(ofSize: 20, weight: UIFont.Weight.medium)
        label.numberOfLines = 0
        return label
    }()

    var tf: UITextField = {
        let tf = UITextField()
        tf.borderStyle = UITextField.BorderStyle.none
        tf.backgroundColor = UIColor.clear
        tf.placeholder = "type answer here..."
        tf.textColor = UIColor(named: "textColor")
        tf.font = UIFont.systemFont(ofSize: 14)
        tf.minimumFontSize = 12
        tf.adjustsFontSizeToFitWidth = true
        return tf
    }()

    var sc: UISegmentedControl = UISegmentedControl()
    
    var picker: UIButton = {
        let picker = UIButton()
        picker.setTitle("upload image", for: .normal)
        picker.setImage(UIImage(systemName: "camera"), for: .normal)
        picker.tintColor = UIColor(named: "textColor")
        picker.borderColor = UIColor(named: "textColor")
        picker.borderWidth = 2
        picker.cornerRadius = 10
        picker.setTitleColor(UIColor(named: "textColor"), for: .normal)
        picker.setInsets(forContentPadding: picker.contentEdgeInsets, imageTitlePadding: 10)
        
        return picker
    }()
    
    var help: UIButton = {
        let help = UIButton()
       help.setTitle("?", for: .normal)
       help.tintColor = UIColor(named: "textColor")
       help.borderColor = UIColor(named: "textColor")
       help.borderWidth = 2
       help.cornerRadius = 10
       help.setTitleColor(UIColor(named: "backgroundColor"), for: .normal)
       help.backgroundColor = UIColor(named: "textColor")
//       help.setInsets(forContentPadding: picker.contentEdgeInsets, imageTitlePadding: 10)
       
       return help
    }()
    
    var imgDisplay: UIImageView = {
        let imgDisplay = UIImageView(image: nil)
        imgDisplay.borderColor = UIColor(named: "textColor")
        imgDisplay.borderWidth = 1
        return imgDisplay
    }()

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }
        
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setup(question: Question) {
        self.question = question
        
        self.backgroundColor = UIColor(named: "backgroundColor")
        
        questionTitle.text = question.questionText
        addSubview(questionTitle)
        questionTitle.anchor(top: topAnchor, left: leftAnchor, bottom: nil, right: rightAnchor, paddingTop: 10, paddingLeft: 10, paddingBottom: 0, paddingRight: 0, width: 0, height: 0, enableInsets: false)
        
        switch question.questionType {
        case let .mc(answers):
            sc = UISegmentedControl(items: answers)
            sc.addTarget(self, action: #selector(segmentSelected(sender:)), for: .valueChanged)
            addSubview(sc)
            sc.anchor(top: questionTitle.bottomAnchor, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, paddingTop: 20, paddingLeft: 0, paddingBottom: 20, paddingRight: 0, width: 0, height: 75, enableInsets: false)
        case .image:
            help.addTarget(self, action:#selector(self.showHelp), for: .touchUpInside)
            addSubview(help)
            help.anchor(top: questionTitle.bottomAnchor, left: nil, bottom: nil, right: rightAnchor, paddingTop: 20, paddingLeft: 10, paddingBottom: 0, paddingRight: 10, width: 50, height: 60, enableInsets: false)
            
            picker.addTarget(self, action:#selector(self.showImgPicker), for: .touchUpInside)
            addSubview(picker)
            picker.anchor(top: questionTitle.bottomAnchor, left: leftAnchor, bottom: nil, right: help.leftAnchor, paddingTop: 20, paddingLeft: 10, paddingBottom: 0, paddingRight: 10, width: 0, height: 60, enableInsets: false)
            
            addSubview(imgDisplay)
            imgDisplay.anchor(top: picker.bottomAnchor, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, paddingTop: 20, paddingLeft: 10, paddingBottom: 0, paddingRight: 10, width: 0, height: 400, enableInsets: false)
        case .textbox:
            tf.delegate = self
            addSubview(tf)
            tf.anchor(top: questionTitle.bottomAnchor, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, paddingTop: 20, paddingLeft: 10, paddingBottom: 50, paddingRight: 10, width: 0, height: 0, enableInsets: false)
        case .onlytext:
            NSLayoutConstraint.activate([
                questionTitle.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -10)
            ])
        }
    }
    
    func load(_ existing: String, _ questionType: QuestionType) {
        switch questionType {
        case let .mc(answers):
            if let foundIndex = answers.firstIndex(where: { (option) -> Bool in
                return option == existing
            }) {
                sc.selectedSegmentIndex = foundIndex
            }
        case .textbox:
            tf.text = existing
        default:
            return
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        Helper.shared.postTo(survey: surveyID, data: [question?.questionID ?? "" : textField.text!])
    }
    
    @objc func segmentSelected(sender: UISegmentedControl) {
        let answer = sender.titleForSegment(at: sender.selectedSegmentIndex)!
        Helper.shared.postTo(survey: surveyID, data: [question?.questionID ?? "" : answer])
    }
    
    @objc func showImgPicker() {
        imgPickerDelegate?.pullUpImagePicker(completion: { (image) in
            self.imgDisplay.image = image
            Helper.shared.upload(image: image, survey: self.surveyID, questionID: self.question?.questionID ?? "")
        })
    }
    
    @objc func showHelp() {
        imgPickerDelegate?.showHelp()
    }
}
