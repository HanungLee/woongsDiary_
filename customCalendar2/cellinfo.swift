//
//  cellinfo.swift
//  customCalendar2
//
//  Created by Kris Lee on 23/07/2018.
//  Copyright © 2018 Hanung Lee. All rights reserved.
//

import Foundation
import RealmSwift

class cellinfo: Object {
    @objc dynamic var date: String = ""
    @objc dynamic var filepath: String = ""
    @objc dynamic var holiday: String = ""
    @objc dynamic var detail: String = ""
    
    
//        override static func primaryKey() -> String? {
//            return "date"
//        }
    
    convenience init(date: String, filepath: String, holiday: String, detail: String){
        self.init()
        self.date = date
        self.filepath = filepath
        self.holiday = holiday
        self.detail = detail
    }
    
    
}
