//
//  cellinfo.swift
//  customCalendar2
//
//  Created by Kris Lee on 23/07/2018.
//  Copyright © 2018 Hanung Lee. All rights reserved.
//

import Foundation
import RealmSwift

class memo: Object {
    @objc dynamic var date: String = ""
    @objc dynamic var writtendate: String = ""
    @objc dynamic var title: String = ""
    @objc dynamic var body: String = ""
    @objc dynamic var boardpath: String = ""
    var images = List<String>()
    
    
    
    //        override static func primaryKey() -> String? {
    //            return "date"
    //        }
    
    convenience init(date: String, writtendate: String, title: String, body: String, boardpath: String, images:List<String>){
        self.init()
        self.writtendate = writtendate
        self.title = title
        self.body = body
        self.boardpath = boardpath
        self.images = images
    }
    
    
}
