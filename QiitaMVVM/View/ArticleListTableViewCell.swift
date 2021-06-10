//
//  ArticleListTableViewCell.swift
//  QiitaMVVM
//
//  Created by 信田　虎太郎 on 2021/06/09.
//

import UIKit

class ArticleListTableViewCell: UITableViewCell {

    @IBOutlet weak var title: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
