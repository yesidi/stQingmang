//
//  IndexController.swift
//  stqingmang
//
//  Created by iOSDev on 2017/5/2.
//  Copyright © 2017年 eddie. All rights reserved.
//

import UIKit

@IBDesignable
class IndexController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "YipSegmentControlMini" {
            let c = segue.destination as! YipSegmentControl
            c.titles = ["bringbuys", "科技美学", "家居", "电竞", "美妆", "健身"]
            c.cellNibName = "YipSegmentItem"
            
            c.configSelectedStyle({ (cell) in
                guard let item = cell as? YipSegmentItem else { return }
                item.name.textColor = UIColor.black
            })
            c.configUnselectedStyle({ (cell) in
                guard let item = cell as? YipSegmentItem else { return }
                item.name.textColor = UIColor(white: 0.88, alpha: 1)
            })
        }else if segue.identifier == "YipSegmentControl" {
            let c = segue.destination as! YipSegmentControl
            c.titles = ["bringbuys", "科技美学", "家居", "电竞", "美妆", "健身"]
            c.cellNibName = "YipSegmentItemLarge"
            
            c.configSelectedStyle({ (cell) in
                guard let item = cell as? YipSegmentItemLarge else { return }
                item.name.textColor = UIColor.black
                item.img?.isHidden = false
                item.noti?.isHidden = false
                item.subtitle?.isHidden = false
            })
            c.configUnselectedStyle({ (cell) in
                guard let item = cell as? YipSegmentItemLarge else { return }
                item.name.textColor = UIColor(white: 0.88, alpha: 1)
                item.img?.isHidden = true
                item.noti?.isHidden = true
                item.subtitle?.isHidden = true
            })
        }
    }

}

class IndexPageViewController: UIPageViewController, UIPageViewControllerDelegate, UIScrollViewDelegate, UIPageViewControllerDataSource {
    
    private var currentPage: Int = 0
    
    var vcs = [UIViewController]()
    
    var itemOffsetXArray = [CGFloat]()
    
    lazy var yipSeg:YipSegmentControl = {
        return (self.parent as! IndexController).childViewControllers.last as! YipSegmentControl
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        delegate = self
        dataSource = self
        (view.subviews.first as? UIScrollView)?.delegate = self
        
        var cls = [UIColor]()
        cls.append(.cyan)
        cls.append(.brown)
        cls.append(.blue)
        cls.append(.green)
        cls.append(.gray)
        cls.append(.green)
        for i in 0...5 {
            let c = UIViewController()
            c.view.backgroundColor = cls[i]
            vcs.append(c)
            self.addChildViewController(c)
        }
        
        setViewControllers([vcs.first!], direction: .forward, animated: true) { (flag) in
            
        }
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        itemOffsetXArray.removeAll()
        for i in 0...5 {
            var ox:CGFloat = (yipSeg.collectionView?.collectionViewLayout as? UICollectionViewFlowLayout)?.sectionInset.left ?? 0
            for j in 0..<i {
                ox += yipSeg.itemWidths[j]!
            }
            itemOffsetXArray.append(ox + yipSeg.itemWidths[i]!/2 - (375/2))
        }
        
        let movedOffsetX = scrollView.contentOffset.x - view.frame.size.width
        var offsetXDiff: CGFloat = 0
        
        if movedOffsetX < 0 && currentPage > 0 {
            offsetXDiff = itemOffsetXArray[currentPage] - itemOffsetXArray[currentPage - 1]
        }else if movedOffsetX > 0 && currentPage < vcs.count - 1 {
            offsetXDiff = itemOffsetXArray[currentPage + 1] - itemOffsetXArray[currentPage]
        }else if movedOffsetX < 0 && currentPage == 0 {
            offsetXDiff = 100
        }else if movedOffsetX > 0 && currentPage == vcs.count - 1 {
            offsetXDiff = 100
        }
        
        if offsetXDiff != 0 {
            yipSeg.collectionView!.contentOffset.x = itemOffsetXArray[currentPage] + movedOffsetX/(view.frame.size.width / offsetXDiff)
        }
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        if viewController == vcs.last {
            return nil
        }else{
            return vcs[vcs.index(of: viewController)! + 1]
        }
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        if viewController == vcs.first {
            return nil
        }else{
            return vcs[vcs.index(of: viewController)! - 1]
        }
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        if completed {
            guard let index = vcs.index(of: pageViewController.viewControllers!.last!) else { return }
            currentPage = index
        }
    }
}











