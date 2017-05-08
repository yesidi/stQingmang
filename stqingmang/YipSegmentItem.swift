//
//  YipSegmentItem.swift
//  stqingmang
//
//  Created by iOSDev on 2017/5/3.
//  Copyright © 2017年 eddie. All rights reserved.
//

import UIKit

class YipSegmentItem: UICollectionViewCell {
    @IBOutlet weak var name: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func preferredLayoutAttributesFitting(_ layoutAttributes: UICollectionViewLayoutAttributes) -> UICollectionViewLayoutAttributes {
        let p = super.preferredLayoutAttributesFitting(layoutAttributes)
        print("p.indexRow: \(p.indexPath.row)-----p.width: \(p.frame.width)")
        if let s = self.findNextResponder(self, targerClass: YipSegmentControl.self) {
            s.itemWidths[p.indexPath.row] = p.frame.width
            if s.sectionInsetLeft == 0 && p.indexPath.row == 0 {
                s.sectionInsetLeft = p.frame.width
                self.perform(#selector(refreshLeft), with: nil, afterDelay: 0)
            }
            
            if s.sectionInsetRight == 0 && p.indexPath.row == s.collectionView!.numberOfItems(inSection: 0) - 1 {
                s.sectionInsetRight = p.frame.width
                self.perform(#selector(refreshRight), with: nil, afterDelay: 0)
            }
        }

        return p
    }
    
    func refreshLeft() {
        let segControl = self.findNextResponder(self, targerClass: YipSegmentControl.self)
        if let s = self.findNextResponder(self, targerClass: YipSegmentControl.self) {
            segControl?.segWidthFirst = s.sectionInsetLeft
        }
    }
    
    func refreshRight() {
        let segControl = self.findNextResponder(self, targerClass: YipSegmentControl.self)
        if let s = self.findNextResponder(self, targerClass: YipSegmentControl.self) {
            segControl?.segWidthLast = s.sectionInsetRight
        }
    }
    
    //寻找nextResponder
    func findNextResponder<T:AnyObject>(_ responder:AnyObject?, targerClass:T.Type) -> T? {
        guard let aResponder = responder else { return nil }
        if aResponder.self is T {
            return aResponder as? T
        }else{
            return self.findNextResponder(aResponder.next, targerClass: targerClass)
        }
    }
}
