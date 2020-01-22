//
//  CommentCell.swift
//  PhotosProject
//
//  Created by Yusuf ali cezik on 22.01.2020.
//  Copyright © 2020 Yusuf Ali Cezik. All rights reserved.
//

import UIKit

class CommentCell: UITableViewCell {

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var mailLabel: UILabel!
    @IBOutlet weak var commentBodyLabel: UILabel!
    
    public var commentVM: CommentViewModel! {
        didSet {
            nameLabel.text = commentVM.username
            mailLabel.text = commentVM.email
            commentBodyLabel.text = commentVM.commentText
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
