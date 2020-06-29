//
//  PhotoCollectionViewCell.swift
//  1mgAssignment
//
//  Created by Swapnil on 28/06/20.
//  Copyright © 2020 Swapnil. All rights reserved.
//
// class of collectionview cell used to show image from flickr api response

import UIKit

class PhotoCollectionViewCell: UICollectionViewCell
{
    @IBOutlet weak var photoImageView: UIImageView!
}

extension PhotoCollectionViewCell
{
    static var identifier: String
    {
        return String(describing: self)
    }
}
