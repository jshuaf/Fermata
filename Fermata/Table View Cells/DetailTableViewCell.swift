//
//  DetailTableViewCell.swift
//  Fermata
//
//  Created by jfang19 on 1/16/17.
//  Copyright © 2017 joshuafang. All rights reserved.
//

import UIKit

enum DetailTableViewCellAccent {
  case Small
  case Middle
  case Large
}

class DetailTableViewCell: UITableViewCell {
  override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
    super.init(style: UITableViewCellStyle.default, reuseIdentifier: reuseIdentifier)
    selectionStyle = .none
  }

  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  internal func setupTextLabels(titleText: String, firstDetailText: String, secondDetailText: String?) {
    let labelsView = contentView.addView(x: 0.87, y: 1.05, w: 0.36, h: 0.72)
    labelsView.addLabel(style: LabelStyle.Body.Primary(), alignLeft: labelsView, y: 0.32, text: titleText)
    labelsView.addLabel(style: LabelStyle.Detail.Light(), alignLeft: labelsView, y: 1.21, text: firstDetailText)
    if secondDetailText != nil {
      labelsView.addLabel(style: LabelStyle.Detail.Light(), alignLeft: labelsView, y: 1.76, text: secondDetailText!)
    }
  }

  internal func setupLeftDetail(accent: DetailTableViewCellAccent, mainText: String, detailText: String) {

  }

}
