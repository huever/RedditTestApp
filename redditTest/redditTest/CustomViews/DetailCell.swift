//
//  DetailCell.swift
//  redditTest
//
//  Created by luciano on 05/06/2018.
//  Copyright © 2018 huevo. All rights reserved.
//

import UIKit

class DetailCell: UITableViewCell {

    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var articleDescription: UILabel!
    @IBOutlet weak var created: UILabel!
    @IBOutlet weak var comments: UILabel!
    @IBOutlet weak var author: UILabel!
    @IBOutlet weak var articleImage: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
