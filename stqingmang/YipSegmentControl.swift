//
//  YipSegmentControl.swift
//  stqingmang
//
//  Created by iOSDev on 2017/5/3.
//  Copyright © 2017年 eddie. All rights reserved.
//

import UIKit

class YipSegmentControl: UICollectionViewController {
    var cellNibName:String = "YipSegmentItem"
    var sectionInsetLeft:CGFloat = 0
    var sectionInsetRight:CGFloat = 0
    
    var itemWidths = [Int:CGFloat]()

    var segWidthFirst:CGFloat = 0 {
        didSet{
            guard let c = self.collectionView else { return }
            (c.collectionViewLayout as? UICollectionViewFlowLayout)?.sectionInset.left = (c.bounds.width/2) - (segWidthFirst/2)
        }
    }
    
    var segWidthLast:CGFloat = 0 {
        didSet{
            guard let c = self.collectionView else { return }
            (c.collectionViewLayout as? UICollectionViewFlowLayout)?.sectionInset.right = (c.bounds.width/2) - (segWidthLast/2)
        }
    }
    
    var titles = [String]()
    var selectedIndex:Int = 0 {
        willSet{
            if let item = self.collectionView?.cellForItem(at: IndexPath(item: selectedIndex, section: 0)) {
                self.unselectedBlock?(item)
                self.addAnimate(view: item.contentView)
            }
        }
        
        didSet {
            if let item = self.collectionView?.cellForItem(at: IndexPath(item: selectedIndex, section: 0)) {
                self.selectedBlock?(item)
                self.addAnimate(view: item.contentView)
            }
        }
    }
    
    lazy var flowLayout:UICollectionViewFlowLayout? = {
        return self.collectionViewLayout as? UICollectionViewFlowLayout
    }()
    
    var selectedBlock:((UICollectionViewCell)->Void)?
    var unselectedBlock:((UICollectionViewCell)->Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.collectionView?.delegate = self
        flowLayout?.scrollDirection = .horizontal
        flowLayout?.estimatedItemSize = CGSize(width: 100, height: 70)
        flowLayout?.minimumLineSpacing = 0
        flowLayout?.minimumInteritemSpacing = 0
        collectionView?.showsHorizontalScrollIndicator = false

        // Register cell classes
        collectionView!.register(UINib(nibName: cellNibName, bundle: nil), forCellWithReuseIdentifier: cellNibName)
        collectionView?.decelerationRate = 0.1
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func configSelectedStyle(_ block:((UICollectionViewCell)->Void)?) {
        self.selectedBlock = block
    }

    func configUnselectedStyle(_ block:((UICollectionViewCell)->Void)?) {
        self.unselectedBlock = block
    }

    // MARK: UICollectionViewDataSource
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return titles.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellNibName, for: indexPath) as! YipSegmentItem
    
        cell.name.text = titles[indexPath.row]
        if selectedIndex == indexPath.row {
            selectedBlock?(cell)
        }else{
            unselectedBlock?(cell)
        }
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        selectedIndex = indexPath.row
        self.collectionView?.scrollToItem(at: IndexPath(item: selectedIndex, section: 0), at: .centeredHorizontally, animated: true)
    }
    
    func addAnimate(view:UIView?) {
        let animation = CATransition()
        animation.duration = 0.2
        animation.type = kCATransitionFromTop
        
        //设置运动速度
        animation.timingFunction = CAMediaTimingFunction.init(name: kCAMediaTimingFunctionEaseInEaseOut)
        view?.layer.add(animation, forKey: "animation")
    }
    
//    override func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
//        let cPoint = CGPoint.init(x: (self.collectionView?.superview?.center.x ?? 0) + (self.collectionView?.contentOffset.x ?? 0), y: self.collectionView?.center.y ?? 0)
//        if let indexPath = self.collectionView?.indexPathForItem(at: cPoint) {
////            guard self.selectedIndex != indexPath.row else { return }
//            self.selectedIndex = indexPath.row
//            self.collectionView?.scrollToItem(at: IndexPath(item: selectedIndex, section: 0), at: .centeredHorizontally, animated: true)
//        }
//    }
//    
//    override func scrollViewWillBeginDecelerating(_ scrollView: UIScrollView) {
//        let cPoint = CGPoint.init(x: (self.collectionView?.superview?.center.x ?? 0) + (self.collectionView?.contentOffset.x ?? 0), y: self.collectionView?.center.y ?? 0)
//        if let indexPath = self.collectionView?.indexPathForItem(at: cPoint) {
////            guard self.selectedIndex != indexPath.row else { return }
//            self.selectedIndex = indexPath.row
//            self.collectionView?.scrollToItem(at: IndexPath(item: selectedIndex, section: 0), at: .centeredHorizontally, animated: true)
//        }
//    }
//    
//    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
//        let cPoint = CGPoint.init(x: (self.collectionView?.superview?.center.x ?? 0) + (self.collectionView?.contentOffset.x ?? 0), y: self.collectionView?.center.y ?? 0)
//        if let indexPath = self.collectionView?.indexPathForItem(at: cPoint) {
////            guard self.selectedIndex != indexPath.row else { return }
//            self.selectedIndex = indexPath.row
//        }
//    }
}





















