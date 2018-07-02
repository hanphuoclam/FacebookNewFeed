//
//  FeedCell.swift
//  FacebookNewFeed
//
//  Created by LamHan on 6/28/18.
//  Copyright © 2018 LamHan. All rights reserved.
//

import UIKit

let cellId = "cellId"

let imageCache = NSCache<NSString, UIImage>()

class FeedCell: UICollectionViewCell {
    
    var feedController : FeedController?
    
    @objc func animate() {
        feedController?.animateImageView(statusImageView)
    }
    
    var post:Post?{
        didSet {
            
            statusImageView.image = UIImage(named: "gray")
            if let statusImageUrl = post?.statusImageUrl {
                
                if let cacheImage = imageCache.object(forKey: statusImageUrl as NSString) {
                    self.statusImageView.image = cacheImage
                }else {
                    let req = URLRequest(url: URL(string: statusImageUrl)!)
                    URLSession.shared.dataTask(with: req as URLRequest) { (data, response, error) in
                        if error != nil {
                            print(error!)
                            return
                        }
                        
                        let image = UIImage(data: data!)
                        
                        imageCache.setObject(image!, forKey: statusImageUrl as NSString)
                        
                        DispatchQueue.main.async {
                            self.statusImageView.image = image
                        }
                        }.resume()
                }
            }
            
            setupNameLocationStatusAndProfileName()
        }
    }
    
    private func setupNameLocationStatusAndProfileName() {
        if let name = post?.name {
            let attributedText = NSMutableAttributedString(string: name, attributes: [NSAttributedStringKey.font : UIFont.boldSystemFont(ofSize: 14)])
            
            attributedText.append(NSAttributedString(string: "\nDecember 18 ・ San Francisco ・ ", attributes: [NSAttributedStringKey.font : UIFont.systemFont(ofSize: 12), NSAttributedStringKey.foregroundColor : UIColor.rgb(red: 155, green: 161, blue: 171)]))
            
            let paragrabStyle = NSMutableParagraphStyle()
            paragrabStyle.lineSpacing = 4
            
            attributedText.addAttributes([NSAttributedStringKey.paragraphStyle : paragrabStyle], range: NSMakeRange(0, attributedText.string.count))
            
            let attachment = NSTextAttachment()
            attachment.image = UIImage(named: "globe_small")
            attachment.bounds = CGRect(x: 0, y: -2, width: 12, height: 12)
            attributedText.append(NSAttributedString(attachment: attachment))
            
            nameLabel.attributedText = attributedText
        }
        if let statusText = post?.statusText {
            statusTextView.text = statusText
        }
        if let profileImage = post?.profileImageName {
            profileImageView.image = UIImage(named: profileImage)
        }
        if let statusImage = post?.statusImageName {
            statusImageView.image = UIImage(named: statusImage)
        }
        if let numLikes = post?.numLikes, let numComments = post?.numComments {
            likesCommentsLabel.text = "\(numLikes) Likes   \(numComments) Coments"
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    let nameLabel : UILabel = {
        let label = UILabel()
        label.numberOfLines = 2
        
        return label
    }()
    
    let profileImageView : UIImageView = {
       let image = UIImageView()
        image.image = UIImage(named: "zuckprofile")
        image.contentMode = .scaleAspectFit
        image.backgroundColor = UIColor.black
        return image
    }()
    
    let statusTextView : UITextView = {
       let status = UITextView()
        status.text = "Status"
        status.font = UIFont.systemFont(ofSize: 14)
        return status
    }()
    
    let statusImageView : UIImageView = {
       let statusImage = UIImageView()
        statusImage.image = UIImage(named: "zuckdog")
        statusImage.contentMode = .scaleAspectFill
        statusImage.layer.masksToBounds = true
        statusImage.isUserInteractionEnabled = true
        return statusImage
    }()
    
    let likesCommentsLabel : UILabel = {
       let likeCmtLabel = UILabel()
        likeCmtLabel.text = "888 Likes   999 Coments"
        likeCmtLabel.font = UIFont.systemFont(ofSize: 12)
        likeCmtLabel.textColor = UIColor.rgb(red: 155, green: 161, blue: 171)
        return likeCmtLabel
    }()
    
    let dividerView : UIView = {
       let divView = UIView()
        divView.backgroundColor = UIColor.rgb(red: 226, green: 228, blue: 232)
        return divView
    }()
    
    static func buttonForTitle(title: String, imageName: String) -> UIButton {
        let button = UIButton()
        button.setTitle(title, for: .normal)
        button.setTitleColor(UIColor.rgb(red: 143, green: 150, blue: 163), for: .normal)
        button.setImage(UIImage(named: imageName), for: .normal)
        button.titleEdgeInsets = UIEdgeInsets(top: 0, left: 8, bottom: 0, right: 0)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
        return button
    }
    
    let likeButton = FeedCell.buttonForTitle(title: "Like", imageName: "like")
    let commentButton = FeedCell.buttonForTitle(title: "Comment", imageName: "comment")
    let shareButton = FeedCell.buttonForTitle(title: "Share", imageName: "share")
    
    func setupView() {
        backgroundColor = UIColor.white
        
        addSubview(nameLabel)
        addSubview(profileImageView)
        addSubview(statusTextView)
        addSubview(statusImageView)
        addSubview(likesCommentsLabel)
        addSubview(dividerView)
        
        addSubview(likeButton)
        addSubview(commentButton)
        addSubview(shareButton)
        
        statusImageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(FeedCell.animate as (FeedCell) -> () -> ())))
        
        addConstraintsWithFormat(format: "H:|-8-[v0(44)]-8-[v1]|", views: profileImageView,nameLabel)
        addConstraintsWithFormat(format: "H:|-4-[v0]-4-|", views: statusTextView)
        addConstraintsWithFormat(format: "H:|[v0]|", views: statusImageView)
        addConstraintsWithFormat(format: "H:|-12-[v0]|", views: likesCommentsLabel)
        addConstraintsWithFormat(format: "H:|-12-[v0]-12-|", views: dividerView)
        //button constraint
        addConstraintsWithFormat(format: "H:|[v0(v1)][v1(v2)][v2]|", views: likeButton,commentButton,shareButton)
        addConstraintsWithFormat(format: "V:|-12-[v0]", views: nameLabel)
        addConstraintsWithFormat(format: "V:|-8-[v0(44)]-4-[v1]-4-[v2(200)]-8-[v3(24)]-8-[v4(0.4)][v5(44)]|", views: profileImageView,statusTextView,statusImageView,likesCommentsLabel,dividerView,likeButton)
        addConstraintsWithFormat(format: "V:[v0(44)]|", views: commentButton)
        addConstraintsWithFormat(format: "V:[v0(44)]|", views: shareButton)
    }
}

extension UIColor {
    static func rgb(red:CGFloat, green:CGFloat, blue:CGFloat) -> UIColor {
        return UIColor(red: red/255, green: green/255, blue: blue/255, alpha: 1)
    }
}

extension UIView {
    func addConstraintsWithFormat(format:String,views:UIView...) {
        var viewDictionary = [String:UIView]()
        for (index,view) in views.enumerated() {
            let key = "v\(index)"
            viewDictionary[key] = view
            view.translatesAutoresizingMaskIntoConstraints = false
        }
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: format, options: NSLayoutFormatOptions(), metrics: nil, views: viewDictionary))
    }
}
