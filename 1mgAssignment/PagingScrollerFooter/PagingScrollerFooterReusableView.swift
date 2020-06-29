//
//  PagingScrollerFooterReusableView.swift
//  1mgAssignment
//
//  Created by Swapnil on 26/06/20.
//  Copyright © 2020 Swapnil. All rights reserved.
//
// scroller footer view class 

import UIKit
import Foundation

class PagingScrollerFooterReusableView: UICollectionReusableView
{
  @IBOutlet weak var scrollerIndicator: UIActivityIndicatorView!
    var isAnimating:Bool = false
    var transformView: CGAffineTransform?

    override func awakeFromNib()
    {
        super.awakeFromNib()
        self.prepareInitialAnimation()
    }
    
    override func layoutSubviews()
    {
        super.layoutSubviews()
    }
    
    func transformView(transformVal:CGAffineTransform, scaleFactor:CGFloat)
    {
        if isAnimating
        {
            return
        }
        self.transformView = transformVal
        self.scrollerIndicator?.transform = CGAffineTransform.init(scaleX: scaleFactor, y: scaleFactor)
    }
    
    func prepareInitialAnimation()
    {
        self.isAnimating = false
        self.scrollerIndicator?.stopAnimating()
        self.scrollerIndicator?.transform = CGAffineTransform.init(scaleX: 0.0, y: 0.0)
    }
    
    func startAnimate()
    {
        self.isAnimating = true
        self.scrollerIndicator?.startAnimating()
    }
    
    func stopAnimate()
    {
        self.isAnimating = false
        self.scrollerIndicator?.stopAnimating()
    }
    
    func animateView()
    {
        if isAnimating
        {
            return
        }
        self.isAnimating = true
        UIView.animate(withDuration: 0.2)
        {
            self.scrollerIndicator?.transform = CGAffineTransform.identity
        }
    }
}
