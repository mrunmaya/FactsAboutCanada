//
//  FactsTableViewCell.swift
//  FactsAboutCanada
//
//  Created by mrunmaya pradhan on 26/07/18.
//  Copyright © 2018 Self. All rights reserved.
//

import UIKit

class FactsTableViewCell: UITableViewCell {

    let factImageView:UIImageView = {
        let img = UIImageView()
        img.contentMode = .scaleAspectFill
        img.translatesAutoresizingMaskIntoConstraints = false
        return img
    }()

    let factTitleLabel:UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 16)
        label.textColor =  UIColor.black
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        return label
    }()

    let factDetailLabel:UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor =  UIColor.black
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    let containerView:UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.clipsToBounds = true
        return view
    }()

    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        containerView.addSubview(factImageView)
        containerView.addSubview(factTitleLabel)
        containerView.addSubview(factDetailLabel)
        self.contentView.addSubview(containerView)

        factImageView.topAnchor.constraint(equalTo:self.containerView.topAnchor).isActive = true
        factImageView.centerYAnchor.constraint(equalTo:self.contentView.centerYAnchor).isActive = true
        factImageView.widthAnchor.constraint(equalToConstant:40).isActive = true
        factImageView.heightAnchor.constraint(equalToConstant:90).isActive = true
        factImageView.leadingAnchor.constraint(equalTo:self.contentView.leadingAnchor).isActive = true
        factImageView.bottomAnchor.constraint(equalTo:self.contentView.bottomAnchor).isActive = true



        containerView.centerYAnchor.constraint(equalTo:self.factImageView.centerYAnchor).isActive = true
        containerView.leadingAnchor.constraint(equalTo:self.factImageView.trailingAnchor, constant:10).isActive = true
        containerView.trailingAnchor.constraint(equalTo:self.contentView.trailingAnchor, constant:10).isActive = true


        factTitleLabel.topAnchor.constraint(equalTo:self.containerView.topAnchor).isActive = true
        factTitleLabel.leadingAnchor.constraint(equalTo:self.factImageView.trailingAnchor,constant:100).isActive = true
        factTitleLabel.trailingAnchor.constraint(equalTo:self.containerView.trailingAnchor,constant:10).isActive = true

        factDetailLabel.topAnchor.constraint(equalTo:self.factTitleLabel.bottomAnchor).isActive = true
        factDetailLabel.leadingAnchor.constraint(equalTo:self.factImageView.trailingAnchor,constant:100).isActive = true
        factDetailLabel.trailingAnchor.constraint(equalTo:self.containerView.trailingAnchor,constant:10).isActive = true
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

}
