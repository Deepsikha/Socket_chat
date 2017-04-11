//
//  ProfileViewController.swift
//  Socket_Chat
//
//  Created by devloper65 on 4/7/17.
//  Copyright © 2017 LaNet. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController,UIScrollViewDelegate,UICollectionViewDelegate, UICollectionViewDataSource {
        
    @IBOutlet var collectionMedia: UICollectionView!
    @IBOutlet var imgBackGround: UIImageView!
    @IBOutlet var imgProfile: UIImageView!
    
    var media: [String] = ["right.jpg","imgApp.jpg","","","","","","","","","","","","",""]
    override func viewDidLoad() {
        super.viewDidLoad()
        imgProfile.layer.cornerRadius = self.imgProfile.frame.width / 2
        let blur = UIBlurEffect(style: UIBlurEffectStyle.init(rawValue: 0)!)
        let blurView = UIVisualEffectView(effect: blur)
        blurView.frame = self.imgBackGround.bounds
        blurView.autoresizingMask = [.flexibleWidth,.flexibleHeight]
        self.imgBackGround.addSubview(blurView)
        
        collectionMedia.delegate = self
        collectionMedia.dataSource = self
        collectionMedia.register(UINib(nibName:"mediaCell",bundle:nil), forCellWithReuseIdentifier: "mediaCell")
    }

    //MARK:- Collection Delegate
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return media.count
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    
        collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionMedia.dequeueReusableCell(withReuseIdentifier: "mediaCell", for: indexPath) as! mediaCell
        
        cell.imgMedia.image = UIImage(named: media[indexPath.item])
        return cell
        
    }
    
    func collectionView(_ collectionView : UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        let cellSize: CGSize = CGSize(width: 65, height: 65)
        return cellSize
    }
    
}
