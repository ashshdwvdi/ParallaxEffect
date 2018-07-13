//
//  ViewController.swift
//  ParallaxCollectionViewEffect
//
//  Created by doodleblue-92 on 13/07/18.
//  Copyright © 2018 doodleblue-92. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    // MARK: - IBOutlets
    @IBOutlet weak var collectionView: UICollectionView!
    
    // MARK: - Properties
    let reuseIdentifier = "AnnotatedPhotoCell"
    let photosArray = [UIImage.init(named: "1.jpg"),UIImage.init(named: "2.jpg"),UIImage.init(named: "3.jpg"),UIImage.init(named: "4.jpg"),UIImage.init(named: "5.jpg"),UIImage.init(named: "6.jpg"),UIImage.init(named: "1.jpg"),UIImage.init(named: "2.jpg"),UIImage.init(named: "3.jpg"),UIImage.init(named: "4.jpg"),UIImage.init(named: "5.jpg"),UIImage.init(named: "4.jpg"),UIImage.init(named: "5.jpg"),UIImage.init(named: "6.jpg"),UIImage.init(named: "5.jpg"),UIImage.init(named: "6.jpg"),UIImage.init(named: "1.jpg"),UIImage.init(named: "2.jpg"), UIImage.init(named: "1.jpg"),UIImage.init(named: "2.jpg"),UIImage.init(named: "3.jpg"),UIImage.init(named: "4.jpg"),UIImage.init(named: "5.jpg"),UIImage.init(named: "6.jpg"),UIImage.init(named: "1.jpg"),UIImage.init(named: "2.jpg"),UIImage.init(named: "3.jpg"),UIImage.init(named: "4.jpg"),UIImage.init(named: "5.jpg"),UIImage.init(named: "6.jpg")]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupCollectionView()
    }

    func setupCollectionView(){
        collectionView.dataSource = self
        collectionView.delegate = self
        
        if let layout = collectionView.collectionViewLayout as? PinterestLayout {
            layout.delegate = self
        }
        
        self.collectionView!.alwaysBounceVertical = true
    }

}

extension ViewController : UICollectionViewDataSource, UICollectionViewDelegate{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return photosArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! AnnotatedPhotoCell
        cell.imageView.image = photosArray[indexPath.item]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if indexPath.row % 2 == 0{
            cell.layer.transform = CATransform3DMakeTranslation(-cell.frame.width, cell.frame.height, 0.0)
        }else{
            cell.layer.transform = CATransform3DMakeTranslation(cell.frame.width, cell.frame.height, 0.0)
        }
        
        UIView.animate(withDuration: 1.0, animations: {
            cell.layer.transform = CATransform3DIdentity
        }, completion: nil)
    }
}

extension ViewController: PinterestLayoutDelegate{
    func collectionView(_ collectionView: UICollectionView, heightForPhotoAtIndexPath indexPath: IndexPath) -> CGFloat {
        var height:CGFloat = CGFloat((arc4random_uniform(250) + 75))
        if height < 225.0{
            height = 200.0
        }
        return height
    }
    
    
}
extension ViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        guard let collectionView = self.collectionView else {return}
        guard let visibleCells = collectionView.visibleCells as? [AnnotatedPhotoCell] else {return}
        for parallaxCell in visibleCells {
            let yOffset = ((collectionView.contentOffset.y - parallaxCell.frame.origin.y) / parallaxCell.imageHeight) * yOffsetSpeed
            parallaxCell.offset(CGPoint(x: 0,y :yOffset))
        }
    }
}


fileprivate let yOffsetSpeed: CGFloat = 90.0
fileprivate let xOffsetSpeed: CGFloat = 100.0

class AnnotatedPhotoCell: UICollectionViewCell {
    
    @IBOutlet weak var imageView: UIImageView!

    override func awakeFromNib() {
        super.awakeFromNib()
        self.imageView.clipsToBounds = true
        self.imageView.contentMode = .scaleAspectFill
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.imageView.contentMode = .scaleAspectFill
    }
    
    var image: UIImage = UIImage() {
        didSet {
            imageView.image = image
        }
    }
    
    var imageHeight: CGFloat {
        return (imageView?.image?.size.height) ?? 100.0
    }
    
    var imageWidth: CGFloat {
        return (imageView?.image?.size.width) ?? UIScreen.main.bounds.width
    }
    
    func offset(_ offset: CGPoint) {
        imageView.frame = self.imageView.bounds.offsetBy(dx: offset.x, dy: offset.y)
    }
}

