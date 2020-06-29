//
//  ToastViewExtensionViewController.swift
//  1mgAssignment
//
//  Created by Swapnil on 29/06/20.
//  Copyright © 2020 Swapnil. All rights reserved.
//

import UIKit

extension UIViewController
{
   func showToastMessage(message : String, font: UIFont)
  {
    let toastMessageLabel = UILabel(frame: CGRect(x: 30, y: self.view.frame.size.height-150, width: self.view.frame.size.width - 60, height: 50))
    toastMessageLabel.textColor = UIColor.white
    toastMessageLabel.font = font
    toastMessageLabel.textAlignment = .center;
    toastMessageLabel.backgroundColor = UIColor.black.withAlphaComponent(0.6)
    toastMessageLabel.alpha = 1.0
    toastMessageLabel.layer.cornerRadius = 10
    toastMessageLabel.clipsToBounds  =  true
    toastMessageLabel.text = message
    self.view.addSubview(toastMessageLabel)
    UIView.animate(withDuration: 5.0, delay: 0.1, options: .curveEaseOut, animations:
    {
         toastMessageLabel.alpha = 0.0
    },
        completion: {(isCompleted) in
        toastMessageLabel.removeFromSuperview()
    })
} }
