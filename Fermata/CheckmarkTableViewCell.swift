//
//  CheckmarkTableViewCell.swift
//  Fermata
//
//  Created by jfang19 on 1/3/17.
//  Copyright © 2017 joshuafang. All rights reserved.
//

import UIKit

class CheckmarkTableViewCell: UITableViewCell {
  override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
    super.init(style: UITableViewCellStyle.default, reuseIdentifier: reuseIdentifier)
    selectionStyle = .none
    textLabel!.setLabelStyle(LabelStyle.Body.Primary)
    tintColor = UIColor.sunrise
  }

  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  func setup(text: String, checked: Bool) {
    self.textLabel?.text = text
    if checked {
      accessoryType = .checkmark
    }
  }

  func uncheck() {
    accessoryType = .none
  }

  func check() {
    accessoryType = .checkmark
  }

}
