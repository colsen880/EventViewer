//
//  ListTableViewController.swift
//  EventViewer
//
//  Created by Chad Olsen on 8/7/19.
//  Copyright © 2019 colsen. All rights reserved.
//

import UIKit

class ListTableViewController: UITableViewController, UISearchBarDelegate {

    var events : [Event] = [] {
        //if events gets updated we want to update the tableview to show the changes
        didSet {
            tableView.reloadData()
        }
    }
    var searchBar : UISearchBar = UISearchBar(frame: .zero)
    var searchTask : DispatchWorkItem?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.register(EventTableViewCell.self, forCellReuseIdentifier: "EventCell")
        
        setupHeader()
        loadEvents(searchTerm: nil)
    }
    
    //MARK: - Setup
    
    //Adds the searchbar to the header and sets the color of the background and text
    func setupHeader() {
        self.navigationController?.navigationBar.barTintColor = UIColor.red
        self.navigationController?.navigationBar.tintColor = UIColor.white
        let textAttributes = [NSAttributedString.Key.foregroundColor:UIColor.white]
        navigationController?.navigationBar.titleTextAttributes = textAttributes
        searchBar.delegate = self
        
        navigationItem.titleView = searchBar
    }
    
    //Performs a request to the server and parses it into the model
    func loadEvents(searchTerm : String?) {
        var urlString  = "https://api.seatgeek.com/2/events?client_id=MTc4MTk2NDN8MTU2NTE0ODc5OS4zMQ"
        
        if let search = searchTerm {
            print(search)
            urlString += "&q=\(search)"
        }

        if let url = URL(string: urlString), let dataAsString = try? String(contentsOf: url, encoding: .utf8) {
            do {
                enum DateError: String, Error {
                    case invalidDate
                }
                let decoder = JSONDecoder()
                let formatter = DateFormatter()
                formatter.calendar = Calendar(identifier: .iso8601)
                formatter.locale = Locale(identifier: "en_US_POSIX")
                formatter.timeZone = TimeZone(secondsFromGMT: 0)
                
                decoder.dateDecodingStrategy = .custom({ (decoder) -> Date in
                    let container = try decoder.singleValueContainer()
                    let dateString = try container.decode(String.self)
                    
                    formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
                    if let date = formatter.date(from: dateString) {
                        return date
                    }
                    throw DateError.invalidDate
                })
                let wrappedEvents = try decoder.decode(EventList.self, from: dataAsString.data(using: .utf8)!)
                self.events = wrappedEvents.events
            } catch {
                print("errors decoding json")
                print("Error : \(error)")
                
            }
        }
    }
    
    // MARK: - Table view data source / delegate

    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 1.0
    }
    override func numberOfSections(in tableView: UITableView) -> Int {
        //For this app we will only use one section
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //The number of rows in the tableview is the number of events
        return events.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "EventCell", for: indexPath) as? EventTableViewCell
        let event = events[indexPath.row]
        cell?.titleLabel.text = event.title
        if let imageUrl = event.getImageUrl(), let data = try? Data(contentsOf: imageUrl) {
            cell?.eventImageView.image = UIImage(data: data)
        } else {
            cell?.eventImageView.image = nil
        }
        cell?.locationLabel.text = event.venue?.displayLocation
        cell?.dateLabel.text = event.getDateString()
        
        return cell!
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        let nextVC = storyboard.instantiateViewController(withIdentifier: "DetailsViewController") as? DetailsViewController
        nextVC?.event = events[indexPath.row]
        if let nvc = nextVC {
            self.navigationController?.pushViewController(nvc, animated: true)
        }
    }
    
    //MARK: - SearchBar Delegate
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        //When the user inputs data into the searchbar, start a task to get data from the server
        //if the data updates we cancel the previous request and start a new one
        self.searchTask?.cancel()
        let task = DispatchWorkItem {
            self.loadEvents(searchTerm: searchText.replacingOccurrences(of: " ", with: "+"))
        }
        self.searchTask = task
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now(), execute: task)
    }

}
