//
//  QuestionType.swift
//  jp
//
//  Created by Selina Wang on 3/1/20.
//  Copyright © 2020 selina. All rights reserved.
//

import Foundation

struct Scale {
    static let numeric = ["1", "2", "3", "4", "5"]
    static let likert = ["Strongly Disagree", "Disagree", "Neither agree nor disagree", "Agree", "Strongly Agree"]
    static let frequency = ["Never", "Rarely", "Sometimes", "Often", "Constantly"]
}

enum QuestionType {
    case mc(answers: [String])
    case image
    case textbox
    case onlytext
}
