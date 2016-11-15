//
//  RecordingTableViewCell.swift
//  Fermata
//
//  Created by jfang19 on 11/14/16.
//  Copyright © 2016 joshuafang. All rights reserved.
//

import UIKit

class RecordingTableViewCell: UITableViewCell {
	var cellLabel: UILabel!

	func setup(title: String) {
		cellLabel.text = title
	}

	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
		super.init(style: style, reuseIdentifier: reuseIdentifier)

		cellLabel = UILabel(frame: CGRect(x: 20, y: 20, width: 100, height: 20))
		cellLabel.textColor = UIColor.black
		cellLabel.font = UIFont(name: "Helvetica Neue", size: 12.0)

		self.contentView.backgroundColor = UIColor.red

		addSubview(cellLabel)
	}

	override func setSelected(_ selected: Bool, animated: Bool) {
			super.setSelected(selected, animated: animated)

			// Configure the view for the selected state
	}

}
