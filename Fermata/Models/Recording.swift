//
//  Recording.swift
//  Fermata
//
//  Created by jfang19 on 11/23/16.
//  Copyright © 2016 joshuafang. All rights reserved.
//

import RealmSwift
import Foundation

class Recording: Object {
  dynamic var url: String = ""
  dynamic var dateCreated: NSDate = NSDate(timeIntervalSince1970: 1)
  dynamic var title: String = ""
}
