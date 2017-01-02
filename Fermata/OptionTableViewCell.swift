//
//  OptionTableViewCell.swift
//  Fermata
//
//  Created by jfang19 on 12/30/16.
//  Copyright © 2016 joshuafang. All rights reserved.
//

import UIKit

class OptionTableViewCell: UITableViewCell {
  override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
    super.init(style: UITableViewCellStyle.default, reuseIdentifier: reuseIdentifier)
    textLabel!.setLabelStyle(LabelStyle.Body.Primary)
  }

  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  func setup(text: String) {
    self.textLabel?.text = text
  }

}
