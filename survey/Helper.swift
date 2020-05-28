//
//  Helper.swift
//  survey
//
//  Created by Selina Wang on 3/6/20.
//  Copyright © 2020 selina. All rights reserved.
//

import Foundation
import Firebase

class Helper {
    static let shared = Helper()
    
    let db = Firestore.firestore()
    let storage = Storage.storage().reference()
    
    let df: DateFormatter = {
        let df = DateFormatter()
        df.dateFormat = "EEEE, MMMM d"
        return df
    }()
    
    let utcdf: DateFormatter = {
        let utcdf = DateFormatter()
        utcdf.timeZone = TimeZone(identifier: "UTC")
        utcdf.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ'"
        return utcdf
    }()
    
    let utcdecoder: DateFormatter = {
        let utcdf = DateFormatter()
        utcdf.timeZone = TimeZone(identifier: "UTC")
        utcdf.dateFormat = "EEEE, MMMM d"
        return utcdf
    }()
    
    let utccal: Calendar = {
        var utccal = Calendar(identifier: .gregorian)
        utccal.timeZone = TimeZone(identifier: "UTC")!
        return utccal
    }()
    
    var isLoggingAllowed: Bool {
        get {
            let currentHour = Calendar.current.component(.hour, from: Date())
//            print(currentHour)
            return currentHour < 12 || currentHour >= 20
        }
    }
    
    var currentDailySurveyURL: String {
        get {
            return UTCMidnightStringFrom(localDate: currentLoggableDate())
        }
    }
    
    private init() {
        
    }
    
    func dateString(from date: Date) -> String {
        return df.string(from: date)
    }
    
    func UTCMidnightStringFrom(localDate date: Date) -> String {
        let components = Calendar.current.dateComponents([.day, .month, .year], from: date)
        guard let utcMidnight = utccal.date(from: components) else {return ""}
        return utcdf.string(from: utcMidnight)
    }
    
    // can log each day between 8 PM and 12 PM the next day
    func currentLoggableDate() -> Date {
        if Calendar.current.component(.hour, from: Date()) < 12 {
            return Calendar.current.date(byAdding: .day, value: -1, to: Date())!
        } else {
            return Date()
        }
    }
    
    func postTo(survey: String, data: [String : Any]) {
        db.collection(Constants.deviceid).document(survey).setData(data, merge: true) { (error) in
            if let e = error {
                print("There was an issue saving data to Firestore, \(e)")
            }
        }
    }
    
    func upload(image: UIImage, survey: String, questionID: String) {
        guard let uploadData = UIImage.pngData(image)() else {return}
//        print(uploadData)
        let deviceRef = storage.child(Constants.deviceid).child(survey)
        deviceRef.putData(uploadData, metadata: nil) { (_, error) in
            if let e = error {
                print("problems uploading image, \(e)")
            }
            deviceRef.downloadURL { (url, error) in
                if let e = error {
                    print("problems with download URL, \(e)")
                }
                guard let downloadURL = url else {return}
//                print(downloadURL)
                Helper.shared.postTo(survey: survey, data: [questionID: downloadURL.absoluteString])
            }
        }
    }
    
    func getLoggedDates(completion: @escaping (([String]) -> Void))  {
        db.collection(Constants.deviceid).getDocuments() { (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                let result = querySnapshot!.documents.reduce([Date]()) { (acc: [Date], qs) -> [Date] in
                    if let parsedDate = self.utcdf.date(from: qs.documentID) {
//                        print(formattedString)
                        return acc + [parsedDate]
                    } else {
                        return acc
                    }
                }.sorted().reversed().map { d in
                    return self.utcdecoder.string(from: d)
                }
//                print(result)
                completion(result)
            }
        }
    }
    
    func getResponse(forSurvey survey: String, question: String, completion: @escaping (String?) -> Void) {
        let surveyRef = db.collection(Constants.deviceid).document(survey)
        
        surveyRef.getDocument { (document, err) in
            completion(document?.get(question) as? String)
        }
    }
}
