//
//  MasterViewController.swift
//  redditTest
//
//  Created by luciano on 04/06/2018.
//  Copyright © 2018 huevo. All rights reserved.
//

import UIKit

class MasterViewController: UITableViewController {

    var detailViewController: DetailViewController? = nil
    var networking: Networking = Networking()
    var articles : [Article] = []
    var cache: NSCache<AnyObject, AnyObject>!
    
    let dateFormatter = DateFormatter()
    let defaults = UserDefaults.standard
    let arrayOfObjectsKey = "arrayOfObjectsKey"
    var nextPage: String = ""
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.cache = NSCache()
        
        tableView.register(UINib(nibName: "DetailCell", bundle: nil), forCellReuseIdentifier: "DetailCell")
        if let split = splitViewController {
            let controllers = split.viewControllers
            detailViewController = (controllers[controllers.count-1] as! UINavigationController).topViewController as? DetailViewController
        }
        
        networking.getTopPost(after: "") { articlesData in
            self.articles = articlesData.children
            if let after = articlesData.after {
                self.nextPage = after
            }
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
        
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(self.handleRefresh(_:)), for: UIControlEvents.valueChanged)
        refreshControl.tintColor = .white
        
        tableView.addSubview(refreshControl)
    }
    
    @objc func handleRefresh(_ refreshControl: UIRefreshControl) {
        
        networking.getTopPost(after: "") { articlesData in
            self.articles = articlesData.children
            if let after = articlesData.after {
                self.nextPage = after
            }
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
        refreshControl.endRefreshing()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        clearsSelectionOnViewWillAppear = splitViewController!.isCollapsed
        super.viewWillAppear(animated)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Segues

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showDetail" {
            if let indexPath = tableView.indexPathForSelectedRow {
                let object = articles[indexPath.row] 
                let controller = (segue.destination as! UINavigationController).topViewController as! DetailViewController
                controller.articleData = object.data
                controller.navigationItem.leftBarButtonItem = splitViewController?.displayModeButtonItem
                controller.navigationItem.leftItemsSupplementBackButton = true
                tableView.deselectRow(at: indexPath, animated: false)
            }
        }
    }

    // MARK: - Table View
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 160
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return articles.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "DetailCell", for: indexPath) as! DetailCell

        let object = articles[indexPath.row].data
        
        cell.title.text = object.title
        if let numComments = object.numComments {
            cell.comments.text = String.init(format: NSLocalizedString("%d comments", comment: ""), numComments)
        }
        
        if let dateCreated = object.createdUTC {
            cell.created.text = dateFormatter.timeSince(from: NSDate(timeIntervalSince1970: TimeInterval(dateCreated)))
        }
        
        cell.author.text = object.author
        
        if let imageUrl = object.thumbnail {
            if (self.cache.object(forKey: imageUrl as AnyObject) != nil) {
                cell.articleImage.image = self.cache.object(forKey: imageUrl as AnyObject) as? UIImage
            } else {
                networking.loadImage(image: imageUrl) { image in
                    DispatchQueue.main.async {
                        cell.articleImage.image = image
                        self.cache.setObject(image, forKey: imageUrl as AnyObject)
                    }
                }
            }
        } else {
            cell.articleImage.image = UIImage(named: "NoImage")
        }
        
        return cell
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.performSegue(withIdentifier: "showDetail", sender: indexPath);
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }

    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            articles.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
        }
    }

    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row + 1 == articles.count {
            networking.getTopPost(after: nextPage) { articlesData in
                self.articles += articlesData.children
                if let after = articlesData.after {
                    self.nextPage = after
                }
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            }
        }
    }
}

