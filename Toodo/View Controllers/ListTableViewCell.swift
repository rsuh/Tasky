//
//  ListTableViewCell.swift
//  Toodo
//
//  Created by Reginald Suh on 2015-07-14.
//  Copyright (c) 2015 ReginaldSuh. All rights reserved.
//

import UIKit

class ListTableViewCell: UITableViewCell {

    @IBOutlet weak var badgeImage: UIImageView!
    @IBOutlet weak var taskCount: UILabel!
    @IBOutlet weak var listTitle: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    var list: List? {
        didSet {
            if let listTitle = listTitle, taskCount = taskCount {
                listTitle.text = "Test, Work"
                taskCount.text = "0"
            }
        }
    }
    

}
