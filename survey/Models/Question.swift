//
//  Question.swift
//  jp
//
//  Created by Selina Wang on 3/1/20.
//  Copyright © 2020 selina. All rights reserved.
//

import Foundation

class Question {
    let questionID: String // used for firebase 
    let questionText: String
    let questionType: QuestionType
    
    init(id: String, questionText: String, type: QuestionType) {
        questionID = id
        self.questionText = questionText
        self.questionType = type
    }
}

