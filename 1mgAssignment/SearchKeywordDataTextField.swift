//
//  SearchTextField.swift
//  1mgAssignment
//
//  Created by Swapnil on 26/06/20.
//  Copyright © 2020 Swapnil. All rights reserved.
//
// class for making the search textfield and its functions

import UIKit

class SearchKeywordDataTextField: UITextField
{
  var activityIndicator : UIActivityIndicatorView!
     
     override func awakeFromNib()
     {
        activityIndicator = UIActivityIndicatorView(style: UIActivityIndicatorView.Style.medium)
        activityIndicator.hidesWhenStopped = true
        activityIndicator.frame = self.bounds
        self.addSubview(activityIndicator)
     }
     
     func startAnimating ()
     {
         activityIndicator.startAnimating()
     }
     
     func stopAnimating ()
     {
         activityIndicator.stopAnimating()
     }
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
