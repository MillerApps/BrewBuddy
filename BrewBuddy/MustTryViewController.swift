//
//  MustTryViewController.swift
//  BrewBuddy
//
//  Created by Tyler Miller on 7/15/15.
//  Copyright (c) 2015 Miller Apps. All rights reserved.
//

import UIKit

class MustTryViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    private let APIKey = "46fdb18ac2e65c0422cdd01a915d63cb"
    var breweries: [FeaturedBreweries] = []
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        let backItem = UIBarButtonItem(title: "", style: .Plain
            , target: nil, action: nil)
        navigationItem.backBarButtonItem = backItem
        
        getMustTrys()
    }
    
    func getMustTrys() {
        
        SVProgressHUD.showWithStatus("Retrieving must try brewery")
        showNetworkActivityIndicator(true)
        let mustTryService = FeaturedBreweriesService(APIKey: APIKey)
        mustTryService.getFeatured() {
            (let brew) in
            if let info = brew, let feature = info.featured {
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    
                    if let name = feature.name {
                        println("Feature name: \(name)")
                    }
                    
                    if let phone = feature.phone {
                        println("Feature Phone: \(phone)")
                    }
                    
                    if let id = feature.breweryId {
                        println("ID: \(id)")
                    }
                    
                    if let icon = feature.largeIconURL {
                        println("icon: \(icon)")
                    }
                    
                    if let region  = feature.region {
                        println("region: \(region)")
                    }
                    self.breweries.append(feature)
                    println(self.breweries.count)
                    
                    self.tableView.reloadData()
                    SVProgressHUD.dismiss()
                    self.showNetworkActivityIndicator(false)
                })
            }
        }
        
        
        
    }
    
    
    
    // MARK: - Table view data source
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Potentially incomplete method implementation.
        // Return the number of sections.
        if breweries.count != 0 {
            self.tableView.backgroundView = nil
            return 1
        } else {
            let messageLabel = UILabel(frame: CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height))
            messageLabel.text = "No data was available, this likely means there are no breweries in your area. Sorry!"
            messageLabel.textColor = UIColor.whiteColor()
            messageLabel.numberOfLines = 0
            messageLabel.textAlignment = NSTextAlignment.Center
            messageLabel.font = UIFont(name: "Helvetica Neue", size: 20)
            messageLabel.sizeToFit()
            
            self.tableView.backgroundView = messageLabel
            
        }
        
        return 0
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete method implementation.
        // Return the number of rows in the section.
        return breweries.count
        
    }
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath) as! BeerTableViewCell
        
        //Configure the cell...
        let brewery = breweries[indexPath.row]
        
        if let name = brewery.name {
            cell.breweryName.text = name
        }
        
        if let state = brewery.region, let city = brewery.locality {
            cell.distance.text = city + ", " + state
        } else {
            cell.distance.text = "Not Avaliable"
        }
        
        if brewery.largeIconURL != nil {
            if let iconURL = NSURL(string: brewery.largeIconURL!) {
                cell.breweryImage.hnk_setImageFromURL(iconURL)
                println(iconURL)
            }
        } else {
            cell.breweryImage.image = UIImage(named: "brewbuddy")
        }
        
        
        
        
        return cell
    }
    
    func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        if indexPath.row % 2 == 0 {
            cell.backgroundColor = UIColor(red:0.918,  green:0.894,  blue:0.886, alpha:0.85)
        } else {
            cell.backgroundColor = UIColor(red:0.929,  green:0.922,  blue:0.918, alpha:0.85)
        }
    }
    
    func configureTableView() {
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 86
    }
    
    
    
    
    
    
    
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        
        if (segue.identifier == "ShowDetails") {
            
            
            
            if let VC: DetailViewController = segue.destinationViewController as? DetailViewController{
                
                
                if let row = self.tableView.indexPathForSelectedRow()?.row {
                    if let phone = breweries[row].phone {
                        VC.phoneNum = phone
                        
                    }
                    if let name = breweries[row].name {
                        VC.nameText = name
                    } else {
                        VC.nameText = "Not Avaliable"
                    }
                    if let website = breweries[row].website {
                        VC.websiteURL = website
                    }
                    if let loc = breweries[row].streetAddress, let state = breweries[row].region, let city = breweries[row].locality {
                        VC.loc = loc + " " + city + ", " + state
                    } else {
                        VC.loc = "Not Avaliable"
                    }
                    if let image = breweries[row].largeIconURL {
                        VC.imageURL = image
                    } else {
                        VC.imageURL = nil
                    }
                    println("row \(row) was selected")
                    // println("value \(berweries[row])")
                }
            }
            
        }
    }
    
}