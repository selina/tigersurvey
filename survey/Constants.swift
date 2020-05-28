//
//  Constants.swift
//  survey
//
//  Created by Selina Wang on 3/7/20.
//  Copyright © 2020 selina. All rights reserved.
//

import Foundation

struct Constants {
    static var deviceid: String {
        get {
            UserDefaults.standard.string(forKey: "deviceID") ?? ""
        }
    }
}
