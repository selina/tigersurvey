//
//  Data.swift
//  survey
//
//  Created by Selina Wang on 3/4/20.
//  Copyright © 2020 selina. All rights reserved.
//

import Foundation

struct InitialSurveyQuestions {
    static let age = Question(id: "age", questionText: "what's your age?", type: QuestionType.textbox)
    static let gender = Question(id: "gender", questionText: "what's your gender?", type: QuestionType.textbox)
    static let ethnicity = Question(id: "ethnicity", questionText: "which ethnicity/ethnicities do you identify with?", type: QuestionType.textbox)
    static let employment = Question(id: "employment", questionText: "what's your current employment status?", type: QuestionType.textbox)
    static let location = Question(id: "location", questionText: "what city are you located in right now?", type: QuestionType.textbox)
    
    static let p0 = Question(id: "p0", questionText: "generally, I am someone who...", type: QuestionType.onlytext)
    static let p1 = Question(id: "p1", questionText: "often compares myself with others with respect to what I have accomplished in life", type: QuestionType.mc(answers: Scale.likert))
    static let p2 = Question(id: "p2", questionText: "always wants to know what others in a similar situation would do", type: QuestionType.mc(answers: Scale.likert))
    static let p3 = Question(id: "p3", questionText: "worries a lot", type: QuestionType.mc(answers: Scale.likert))
    static let p4 = Question(id: "p4", questionText: "gets nervous easily", type: QuestionType.mc(answers: Scale.likert))
    static let p5 = Question(id: "p5", questionText: "remains calm in tense situations", type: QuestionType.mc(answers: Scale.likert))
    static let p6 = Question(id: "p6", questionText: "is talkative", type: QuestionType.mc(answers: Scale.likert))
    static let p7 = Question(id: "p7", questionText: "is outgoing, sociable", type: QuestionType.mc(answers: Scale.likert))
    static let p8 = Question(id: "p8", questionText: "is reserved", type: QuestionType.mc(answers: Scale.likert))
    static let p9 = Question(id: "p9", questionText: "is original, comes up with new ideas", type: QuestionType.mc(answers: Scale.likert))
    static let p10 = Question(id: "p10", questionText: "values artistic, aesthetic experiences", type: QuestionType.mc(answers: Scale.likert))
    static let p11 = Question(id: "p11", questionText: "has an active imagination", type: QuestionType.mc(answers: Scale.likert))
    static let p12 = Question(id: "p12", questionText: "is sometimes rude to others", type: QuestionType.mc(answers: Scale.likert))
    static let p13 = Question(id: "p13", questionText: "has a forgiving nature", type: QuestionType.mc(answers: Scale.likert))
    static let p14 = Question(id: "p14", questionText: "is considerate and kind to almost everyone", type: QuestionType.mc(answers: Scale.likert))
    static let p15 = Question(id: "p15", questionText: "does a thorough job", type: QuestionType.mc(answers: Scale.likert))
    static let p16 = Question(id: "p16", questionText: "tends to be lazy", type: QuestionType.mc(answers: Scale.likert))
    static let p17 = Question(id: "p17", questionText: "does things efficiently", type: QuestionType.mc(answers: Scale.likert))
    static let p18 = Question(id: "p18", questionText: "tends to worry about what other people think of me", type: QuestionType.mc(answers: Scale.likert))
    
    static let estimated_sm_time = Question(id: "estimated_sm_time", questionText: "On average, how much time do you estimate you spend on social media every day?", type: QuestionType.textbox)
    static let estimated_news_time = Question(id: "estimated_news_time", questionText: "On average, how much time do you estimate you spend reading the news every day?", type: QuestionType.textbox)
    
    static let demographics = [age, gender, ethnicity, employment, location]
    static let personality1 = [p0, p1, p2, p3, p4, p5, p6, p7, p8, p9]
    static let personality2 = [p10, p11, p12, p13, p14, p15, p16, p17, p18]
    static let est_consumption = [estimated_sm_time, estimated_news_time]
    
    static func datasource() -> SurveyDataSource {
        return SurveyDataSource(pages: [InitialSurveyQuestions.demographics, InitialSurveyQuestions.personality1, InitialSurveyQuestions.personality2, InitialSurveyQuestions.est_consumption], surveyTitle: "a few questions before we begin...", surveyID: "initial")
    }
}

struct DailySurveyQuestions {
    static let wb1 = Question(id: "wb1", questionText: "I am satisfied with the way my life is going", type: QuestionType.mc(answers: Scale.likert))
    static let wb2 = Question(id: "wb2", questionText: "I feel socially connected", type: QuestionType.mc(answers: Scale.likert))
    static let wb3 = Question(id: "wb3", questionText: "I feel stressed", type: QuestionType.mc(answers: Scale.likert))
    static let wb4 = Question(id: "wb4", questionText: "Today was a productive day", type: QuestionType.mc(answers: Scale.likert))
    static let wb5 = Question(id: "wb5", questionText: "I feel lonely", type: QuestionType.mc(answers: Scale.likert))
    static let wb6 = Question(id: "wb6", questionText: "I am a person of worth, at least on an equal plane with others.", type: QuestionType.mc(answers: Scale.likert))
    
    static let usage_question = Question(id: "", questionText: "when using social media today, how often did you:", type: QuestionType.onlytext)
    static let dm = Question(id: "dm", questionText: "direct message friends", type: QuestionType.mc(answers: Scale.frequency))
    static let comment = Question(id: "comment", questionText: "comment on posts (e.g. meme tags)", type: QuestionType.mc(answers: Scale.frequency))
    static let stories = Question(id: "stories", questionText: "watch stories (e.g. Instagram, Snap, Facebook)", type: QuestionType.mc(answers: Scale.frequency))
    static let newsfeed = Question(id: "newsfeed", questionText: "casually browse/like others' newsfeed posts", type: QuestionType.mc(answers: Scale.frequency))
    
    static let wellbeing = [wb1, wb2, wb3, wb4, wb5, wb6]
    static let image = [Question(id: "image", questionText: "please upload a screenshot of your Screen Time statistics for today", type: QuestionType.image)]
    static let usage = [usage_question, dm, comment, stories, newsfeed]
    static let anything_else = [Question(id: "anything_else", questionText: "is there anything else you’d like to tell us about your day that might provide us with some more context?", type: QuestionType.textbox)]

    
    static func datasource() -> SurveyDataSource {
        let title = "daily survey - \(Helper.shared.dateString(from: Helper.shared.currentLoggableDate()))".lowercased()
        return SurveyDataSource(pages: [DailySurveyQuestions.wellbeing, DailySurveyQuestions.image, DailySurveyQuestions.usage, DailySurveyQuestions.anything_else], surveyTitle: title, surveyID: Helper.shared.currentDailySurveyURL)
    }
}
