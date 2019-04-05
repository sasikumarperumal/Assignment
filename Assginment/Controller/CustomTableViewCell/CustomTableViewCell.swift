//
//  CustomTableViewCell.swift
//  Assginment
//
//  Created by ndot on 05/04/19.
//  Copyright © 2019 ndot. All rights reserved.
//

import UIKit

class CustomTableViewCell: UITableViewCell {
    
    var titleImageView = UIImageView()
    var titleLabel = UILabel()
    var titleDescription = UILabel()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        self.selectionStyle = .none
        // Configure the view for the selected state
    }
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.basicSetup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func basicSetup()-> Void {
        self.backgroundColor = UIColor.white
        self.addSubview(titleImageView)
        self.addSubview(titleLabel)
        self.addSubview(titleDescription)
        //Adding Constraints
        titleLabel.anchor(top: self.topAnchor, leading: self.leadingAnchor, bottom: nil, trailing: self.trailingAnchor, padding: UIEdgeInsets(top: 5, left: 5, bottom: 0, right: 5), size: CGSize(width: titleLabel.frame.width, height: 40))
        titleImageView.anchor(top: titleLabel.bottomAnchor, leading: self.leadingAnchor, bottom: nil, trailing: self.trailingAnchor, padding: UIEdgeInsets(top: 5, left: 5, bottom: 0, right: 5), size: CGSize(width: titleImageView.frame.width, height: 100))
        titleDescription.anchor(top: titleImageView.bottomAnchor, leading: self.leadingAnchor, bottom: self.bottomAnchor, trailing: self.trailingAnchor, padding: UIEdgeInsets(top: 10, left: 5, bottom: 5, right: 5), size: .zero)
        
        //Setting attributes
        titleImageView.contentMode = .scaleAspectFit
        titleLabel.textAlignment = .left
        titleLabel.textColor = UIColor.darkText
        titleDescription.textAlignment = .left
        titleDescription.textColor = UIColor.darkGray
        titleDescription.numberOfLines = 0
    }
    
}
