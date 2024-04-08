//
//  EventTableViewCell.swift
//  EventViewer
//
//  Created by Chad Olsen on 8/7/19.
//  Copyright © 2019 colsen. All rights reserved.
//

import UIKit

class EventTableViewCell: UITableViewCell {

    let eventImageView = UIImageView()
    let titleLabel = UILabel()
    let locationLabel = UILabel()
    let dateLabel = UILabel()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupCell()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Setup
    func setupCell() {
        //Setup the elements in the Cell
        eventImageView.translatesAutoresizingMaskIntoConstraints = false
        eventImageView.contentMode = .scaleAspectFit
        self.addSubview(eventImageView)
        
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.numberOfLines = 0
        self.addSubview(titleLabel)
        
        locationLabel.translatesAutoresizingMaskIntoConstraints = false
        locationLabel.font = UIFont(name: locationLabel.font.fontName, size: 12)
        self.addSubview(locationLabel)
        
        dateLabel.translatesAutoresizingMaskIntoConstraints = false
        dateLabel.font = UIFont(name: dateLabel.font.fontName, size: 12)
        self.addSubview(dateLabel)
        
        // Add constraints to the cell for the items
        let views = ["eventImageView" : eventImageView, "titleLabel" : titleLabel, "locationLabel" : locationLabel, "dateLabel" : dateLabel]
        let hConstraint = NSLayoutConstraint.constraints(withVisualFormat: "H:|-[eventImageView]-10-[titleLabel]-|", options: .alignAllTop, metrics: nil, views: views)
        let vConstraint = NSLayoutConstraint.constraints(withVisualFormat: "V:|-[eventImageView]-|", options: .alignAllLeft, metrics: nil, views: views)
        let labelVConstraint = NSLayoutConstraint.constraints(withVisualFormat: "V:|-[titleLabel]-[locationLabel(<=titleLabel)]-[dateLabel(==locationLabel)]-|", options: .alignAllLeft, metrics: nil, views: views)
        self.addConstraints(hConstraint + vConstraint + labelVConstraint)
        
        //Image needs to have the dimensons set
        let imageHConstraint = NSLayoutConstraint.init(item: eventImageView, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .height, multiplier: 1, constant: 100)
        let imageWConstraint = NSLayoutConstraint.init(item: eventImageView, attribute: .width, relatedBy: .equal, toItem: eventImageView, attribute: .height, multiplier: 1, constant: 0)
        
        self.addConstraints([imageHConstraint, imageWConstraint])
        
    }
}
