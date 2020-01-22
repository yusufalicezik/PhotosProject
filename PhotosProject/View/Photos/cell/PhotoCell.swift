//
//  PhotoCell.swift
//  PhotosProject
//
//  Created by Yusuf ali cezik on 21.01.2020.
//  Copyright © 2020 Yusuf Ali Cezik. All rights reserved.
//

import UIKit
import SDWebImage

class PhotoCell: UITableViewCell {

    @IBOutlet weak var photoImageView: UIImageView!
    @IBOutlet weak var photoTitleLabel: UILabel!
    
    public var photoVM: PhotoViewModel! {
        didSet {
            photoImageView.sd_setImage(with: photoVM.imageUrl, completed: nil)
            photoTitleLabel.text = photoVM.imageTitle
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
