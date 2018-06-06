//
//  DetailViewController.swift
//  redditTest
//
//  Created by luciano on 04/06/2018.
//  Copyright © 2018 huevo. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {

    @IBOutlet weak var detailDescriptionLabel: UILabel!
    @IBOutlet weak var articleImage: UIImageView!
    @IBOutlet weak var articleTitle: UILabel!
    @IBOutlet weak var totalComments: UILabel!
    
    var networking: Networking = Networking()
    var articleData: ArticleData?
    
    func configureView() {
        // Update the user interface for the detail item.
        
        articleTitle.text = articleData?.title
        if let numComments = articleData?.numComments {
            totalComments.text = String.init(format: NSLocalizedString("%d comments", comment: ""), numComments)
        }
        
        self.title = articleData?.author
        
        if let image = articleData?.preview?.images.first?.source.url {
            networking.loadImage(image: image) { image in
                DispatchQueue.main.async {
                    self.articleImage.image = image
                }
            }
        } else {
            self.articleImage.image = UIImage(named: "NoImage")
        }
        
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        configureView()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    var detailItem: Article? {
        didSet {
            // Update the view.
            configureView()
        }
    }


}

