//
//  ArtistCell.swift
//  FireBaseDB
//
//  Created by Antony Leo Ruban Yesudass on 28/08/19.
//  Copyright © 2019 Antony Leo Ruban Yesudass. All rights reserved.
//

import UIKit

class ArtistCell: UITableViewCell {

    @IBOutlet weak var labelName: UILabel!
    @IBOutlet weak var labelGenre: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }

}
