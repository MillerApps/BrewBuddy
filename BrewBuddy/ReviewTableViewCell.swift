//
//  ReviewTableViewCell.swift
//  
//
//  Created by Tyler Miller on 6/25/15.
//
//

import UIKit

class ReviewTableViewCell: UITableViewCell {

    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var rating: HCSStarRatingView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
