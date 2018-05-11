//
//  VideoTableViewCell.swift
//  
//
//  Created by Bradley Boutcher on 5/10/18.
//

import UIKit

class VideoTableViewCell: UITableViewCell {

    //MARK: Properties

    @IBOutlet weak var thumbnail: UIImageView!
    @IBOutlet weak var videoTitle: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
