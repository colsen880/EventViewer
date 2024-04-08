//
//  DetailsViewController.swift
//  EventViewer
//
//  Created by Chad Olsen on 8/7/19.
//  Copyright © 2019 colsen. All rights reserved.
//

import UIKit

class DetailsViewController: UIViewController {
    
    var event : Event?
    
    let eventImageView = UIImageView()
    
    let locationLabel = UILabel()
    let dateLabel = UILabel()
    let typeLabel = UILabel()
    let favoriteButton = UIButton()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.title = event?.title
        setupView()
    }
    
    func setupView() {
        
        addImage()
        
        addLabels()
        
        addPerformingLabels()
        
        addFavoriteButton()
        
    }
    
    //Adds an image to the top of the view
    func addImage() {
        if let imageUrl = event?.getImageUrl(), let data = try? Data(contentsOf: imageUrl) {
            self.eventImageView.image = UIImage(data: data)
        }
        eventImageView.translatesAutoresizingMaskIntoConstraints = false
        eventImageView.sizeToFit()
        self.view.addSubview(eventImageView)
    }
    
    func addLabels() {
        locationLabel.text = event?.venue?.displayLocation
        locationLabel.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(locationLabel)
        
        if let date = event?.getDateString() {
            dateLabel.text = date
        }
        dateLabel.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(dateLabel)
        
        if let typeString = event?.type {
            typeLabel.text = "Event type: \(typeString)"
        }
        typeLabel.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(typeLabel)
        
        
        
        let views = ["eventImage" : eventImageView, "locationLabel" : locationLabel, "dateLabel" : dateLabel, "typeLabel" : typeLabel]
        
        let horizontalConstraint = NSLayoutConstraint.constraints(withVisualFormat: "H:|-[eventImage]-|", options: .alignAllTop, metrics: nil, views: views)
        
        let verticalConstraint = NSLayoutConstraint.constraints(withVisualFormat: "V:|-100-[eventImage]-5-[locationLabel(==30)]-5-[dateLabel(==locationLabel)]-5-[typeLabel]-(>=5)-|", options: .alignAllLeft, metrics: nil, views: views)
        view.addConstraints(horizontalConstraint + verticalConstraint)
        var multiplier : CGFloat = 1.0
        if let height = eventImageView.image?.size.height, let width = eventImageView.image?.size.width {
            multiplier = height/width
        }
        let imageWConstraint = NSLayoutConstraint(item: eventImageView, attribute: .width, relatedBy: .equal, toItem: view, attribute: .width, multiplier: 1, constant: -30)
        let imageHConstraint = NSLayoutConstraint(item: eventImageView, attribute: .height, relatedBy: .equal, toItem: eventImageView, attribute: .width, multiplier: multiplier, constant: 0)
        view.addConstraints([imageWConstraint, imageHConstraint])
    }
    
    //Adds labels to the view if there is more than one Performer
    func addPerformingLabels() {
        if let performing = event?.performers {
            if performing.count > 1 {
                let performingLabel = UILabel()
                performingLabel.text = "Performing:"
                performingLabel.translatesAutoresizingMaskIntoConstraints = false
                self.view.addSubview(performingLabel)
                
                let performingYConstraint = NSLayoutConstraint(item: performingLabel, attribute: .top, relatedBy: .equal, toItem: self.typeLabel, attribute: .bottom, multiplier: 1, constant: 5)
                let performingXConstraint = NSLayoutConstraint(item: performingLabel, attribute: .left, relatedBy: .equal, toItem: self.typeLabel, attribute: .left, multiplier: 1, constant: 0)
                let performingHConstraint = NSLayoutConstraint(item: performingLabel, attribute: .height, relatedBy: .equal, toItem: typeLabel, attribute: .height, multiplier: 1, constant: 0)
                let performingWConsraint = NSLayoutConstraint(item: performingLabel, attribute: .width, relatedBy: .equal, toItem: typeLabel, attribute: .width, multiplier: 1, constant: 0)
                self.view.addConstraints([performingXConstraint, performingYConstraint, performingHConstraint, performingWConsraint])
                
                var previousView : UIView = performingLabel
                for performer in performing {
                    
                    let label = UILabel()
                    label.text = performer.name
                    label.translatesAutoresizingMaskIntoConstraints = false
                    
                    self.view.addSubview(label)
                    
                    let heightConstraint = NSLayoutConstraint(item: label, attribute: .height, relatedBy: .equal, toItem: performingLabel, attribute: .height, multiplier: 1, constant: 0)
                    let widthConstraint = NSLayoutConstraint(item: label, attribute: .right, relatedBy: .equal, toItem: self.view, attribute: .right, multiplier: 1, constant: -15)
                    let xConstraint = NSLayoutConstraint(item: label, attribute: .left, relatedBy: .equal, toItem: performingLabel, attribute: .left, multiplier: 1, constant: 15)
                    let yConstraint = NSLayoutConstraint(item: label, attribute: .top, relatedBy: .equal, toItem: previousView, attribute: .bottom, multiplier: 1, constant: 5)
                    self.view.addConstraints([heightConstraint, widthConstraint, xConstraint, yConstraint])
                    previousView = label
                }
            }
        }
    }
    
    func addFavoriteButton() {
        if let eventLocal = event {
            favoriteButton.setTitle("Favorite", for: .normal)
            if !eventLocal.favorite {
                favoriteButton.backgroundColor = .gray
            } else {
                favoriteButton.backgroundColor = .blue
            }
                favoriteButton.setTitleColor(.white, for: .normal)
            favoriteButton.translatesAutoresizingMaskIntoConstraints = false
            favoriteButton.addTarget(self, action: #selector(favButtonSelected), for: .touchUpInside)
            
            self.view.addSubview(favoriteButton)
            
            let views = ["favButton" : favoriteButton]
            
            let hoConstraint = NSLayoutConstraint.constraints(withVisualFormat: "H:|-[favButton]-|", options: .alignAllBottom, metrics: nil, views: views)
            let veConstraint = NSLayoutConstraint.constraints(withVisualFormat: "V:|-(>=5)-[favButton(==50)]-50-|", options: .alignAllLeft, metrics: nil, views: views)
            
            self.view.addConstraints(hoConstraint + veConstraint)
        }
    }
    
    @objc func favButtonSelected() {
        if event?.favorite ?? false {
            event?.favorite = false
            favoriteButton.backgroundColor = UIColor.gray

        } else {
            event?.favorite = true
            favoriteButton.backgroundColor = .blue

        }
    }

}
