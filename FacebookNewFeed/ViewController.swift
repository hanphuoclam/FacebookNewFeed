//
//  ViewController.swift
//  FacebookNewFeed
//
//  Created by LamHan on 6/28/18.
//  Copyright © 2018 LamHan. All rights reserved.
//

import UIKit

class FeedController: UICollectionViewController, UICollectionViewDelegateFlowLayout {

    var posts = [Post]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        DataExample()
        
        navigationItem.title = "News Feed"
        
        collectionView?.alwaysBounceVertical = true
        collectionView?.backgroundColor = UIColor(white: 0.95, alpha: 1)
        collectionView?.register(FeedCell.self, forCellWithReuseIdentifier: cellId)
        self.collectionView?.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.tabBarController?.navigationItem.title = "News Feed"
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return posts.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! FeedCell
        cell.post = posts[indexPath.item]
        cell.feedController = self
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout:
        UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        if let statusText = posts[indexPath.item].statusText {
            let rect = NSString(string: statusText).boundingRect(with: CGSize(width: view.frame.width, height: 1000), options: NSStringDrawingOptions.usesFontLeading.union(NSStringDrawingOptions.usesLineFragmentOrigin), attributes: [NSAttributedStringKey.font: UIFont.systemFont(ofSize: 14)], context: nil)
            let knowHeight : CGFloat = 8+44+4+4+200+8+24+8+44
            return CGSize(width: view.frame.width, height: rect.height + knowHeight + 24)
        }
        
        return CGSize(width: view.frame.width, height: 500)
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        collectionView?.collectionViewLayout.invalidateLayout()
    }
    
    let zoomImageView = UIImageView()
    let blackBackgroundView = UIView()
    let navBarCoverView = UIView()
    let tabBarCoverView = UIView()

    var StatusImageView : UIImageView?
    
    func animateImageView(_ statusImageView: UIImageView) {
        self.StatusImageView = statusImageView
        
        if let startingFrame = statusImageView.superview?.convert(statusImageView.frame, to: nil) {
            statusImageView.alpha = 0
            blackBackgroundView.frame = self.view.frame
            blackBackgroundView.backgroundColor = UIColor.black
            blackBackgroundView.alpha = 0
            view.addSubview(blackBackgroundView)
            
            navBarCoverView.frame = CGRect(x: 0, y: 0, width: 1000, height: 20 + 44)
            navBarCoverView.backgroundColor = UIColor.black
            navBarCoverView.alpha = 0
            
            if let keyWindow = UIApplication.shared.keyWindow {
                keyWindow.addSubview(navBarCoverView)
                
                tabBarCoverView.frame = CGRect(x: 0, y: keyWindow.frame.height - 49, width: view.frame.width, height: 49)
                tabBarCoverView.alpha = 0
                tabBarCoverView.backgroundColor = UIColor.black
                keyWindow.addSubview(tabBarCoverView)
            }
            
            zoomImageView.backgroundColor = UIColor.red
            zoomImageView.frame = startingFrame
            zoomImageView.isUserInteractionEnabled = true
            zoomImageView.image = statusImageView.image
            zoomImageView.contentMode = .scaleAspectFill
            zoomImageView.clipsToBounds = true
            view.addSubview(zoomImageView)
            
            zoomImageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(FeedController.zoomOut)))
            
            UIView.animate(withDuration: 0.75, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 0.5, options: .curveEaseOut, animations: { () -> Void in
                
                let height = (self.view.frame.width / startingFrame.width) * startingFrame.height
                
                let y = self.view.frame.height / 2 - height / 2
                
                self.zoomImageView.frame = CGRect(x: 0, y: y, width: self.view.frame.width, height: height)
                
                self.blackBackgroundView.alpha = 1
                
                self.navBarCoverView.alpha = 1
                
                self.tabBarCoverView.alpha = 1
                
            }, completion: nil)
            
        }
    }
    
    @objc func zoomOut(){
        if let startingFrame = StatusImageView!.superview?.convert((StatusImageView?.frame)!, to: nil) {
            UIView.animate(withDuration: 0.75, animations: {
                self.zoomImageView.frame = startingFrame
                
                self.blackBackgroundView.alpha = 0
                self.tabBarCoverView.alpha = 0
                self.navBarCoverView.alpha = 0
            }) { (didComplete) in
                self.zoomImageView.removeFromSuperview()
                self.blackBackgroundView.removeFromSuperview()
                self.navBarCoverView.removeFromSuperview()
                self.tabBarCoverView.removeFromSuperview()
                self.StatusImageView?.alpha = 1
            }
        }
    }
    
    func DataExample() {
        let postLam = Post()
        postLam.name = "Lãm Hàn"
        //                postMark.location = Location()
        //                postMark.location?.city = "San Francisco"
        //                postMark.location?.state = "CA"
        postLam.profileImageName = "zuckprofile"
        postLam.statusImageUrl = "https://scontent.fdad2-1.fna.fbcdn.net/v/t1.0-9/28276418_611050355901319_7618132880475966411_n.jpg?_nc_cat=0&oh=18c4752aa4b686b1f3539d0ad2116645&oe=5BEB7942"
        postLam.statusText = "Có đi chơi tết nha"
        //postLam.statusImageName = "zuckdog"
        postLam.numLikes = 100
        postLam.numComments = 133
        
        let postTomb = Post()
        postTomb.name = "Tomb Raider"
        //                postMark.location = Location()
        //                postMark.location?.city = "San Francisco"
        //                postMark.location?.state = "CA"
        postTomb.profileImageName = "steve_profile"
        postTomb.statusImageUrl = "https://www.wallpaperflare.com/static/906/324/936/rise-of-the-tomb-raider-lara-croft-game-bow-wallpaper.jpg"
        postTomb.statusText = "Tomb Raider 20th 2018"
        postTomb.numLikes = 1150
        postTomb.numComments = 133
        
        
                let postMark = Post()
                postMark.name = "Mark Zuckerberg"
//                postMark.location = Location()
//                postMark.location?.city = "San Francisco"
//                postMark.location?.state = "CA"
                postMark.profileImageName = "zuckprofile"
                postMark.statusText = "By giving people the power to share, we're making the world more transparent." +
                    "\nNew world after 2090s"
                postMark.statusImageUrl = "https://wallpaperbrowse.com/media/images/MTM1MzQwMzMxNTE5NTA0MzU0_onP3Ci1.jpg"
                //postMark.statusImageName = "zuckdog"
                postMark.numLikes = 400
                postMark.numComments = 123
        
                let postSteve = Post()
                postSteve.name = "Steve Jobs"
//                postSteve.location = Location()
//                postSteve.location?.city = "Cupertino"
//                postSteve.location?.state = "CA"
                postSteve.profileImageName = "steve_profile"
                postSteve.statusText = "Design is not just what it looks like and feels like. Design is how it works.\n\n" +
                    "Being the richest man in the cemetery doesn't matter to me. Going to bed at night saying we've done something wonderful, that's what matters to me.\n\n" +
                "Sometimes when you innovate, you make mistakes. It is best to admit them quickly, and get on with improving your other innovations." +
                    "\nNew Game Game of throne"
                //postSteve.statusImageName = "steve_status"
                postSteve.statusImageUrl = "https://wallpapersmug.com/large/d2b7fb/Final-Fantasy-Noctis-video-game-throne.jpg"
                postSteve.numLikes = 1000
                postSteve.numComments = 55
        
                let postGandhi = Post()
                postGandhi.name = "Mahatma Gandhi"
//                postGandhi.location = Location()
//                postGandhi.location?.city = "Porbandar"
//                postGandhi.location?.state = "India"
                postGandhi.profileImageName = "gandhi_profile"
                postGandhi.statusText = "Live as if you were to die tomorrow; learn as if you were to live forever.\n" +
                    "The weak can never forgive. Forgiveness is the attribute of the strong.\n" +
                "Happiness is when what you think, what you say, and what you do are in harmony." +
        "\nNew friend, His name is #LamHan"
                //postGandhi.statusImageName = "gandhi_status"
                postGandhi.statusImageUrl = "https://scontent.fdad2-1.fna.fbcdn.net/v/t1.0-9/22405919_550696805270008_1973488521011559633_n.jpg?_nc_cat=0&oh=226779b1301183a4d9f153349d8e9ab8&oe=5BA3AB2D"
                postGandhi.numLikes = 333
                postGandhi.numComments = 22
        
                posts.append(postLam)
                posts.append(postTomb)
                posts.append(postMark)
                posts.append(postSteve)
                posts.append(postGandhi)
    }

}

