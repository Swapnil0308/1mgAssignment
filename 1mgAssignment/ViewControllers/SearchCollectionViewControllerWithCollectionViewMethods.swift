//
//  SearchViewControllerWithCollectionViewMethods.swift
//  1mgAssignment
//
//  Created by Swapnil on 28/06/20.
//  Copyright © 2020 Swapnil. All rights reserved.
//
// main view controller extension - when user enters the text in textfield and press enter then after getting the response from api call showing the data got from API call according to the responses

import UIKit
import Foundation

// MARK: UICollectionViewDataSource
extension SearchTextEnteringCollectionViewController
{
   override func numberOfSections(in collectionView: UICollectionView) -> Int
   {
       return 1
   }

   override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
   {
     return self.searchResult.searchResultsFromFlickrAPI.count
   }

   override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
   {
    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PhotoCollectionViewCell.identifier, for: indexPath) as! PhotoCollectionViewCell
    return cell
   }
}

// MARK: UICollectionViewDelegate
extension SearchTextEnteringCollectionViewController
{
    override func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath)
    {
        let indexofLastRow = collectionView.numberOfItems(inSection: 0) - 1
        if indexPath.row == indexofLastRow && self.pageVal != nil
        {
            self.loadPhotosofPagination()
        }
       let photoData = photoToBeDisplayedOnIndexPath(indexPath: indexPath)
       (cell as! PhotoCollectionViewCell).photoImageView.image = #imageLiteral(resourceName: "placeholder")
       ImageDownloader.shared.downloadImage(photoData, indexPath: indexPath)
       { (photoImage, urlImage, index, error) in
           if let newIndex = index
           {
            DispatchQueue.main.async
            {
               if let getCellAtIndex = collectionView.cellForItem(at: newIndex)
               {
                   (getCellAtIndex as? PhotoCollectionViewCell)!.photoImageView.image = photoImage
               }
            }
        }
      }
    }
    
    func loadPhotosofPagination()
    {
        guard let searchKeyword = self.searchKeywordTextField.text, searchKeyword.count > 0
        else
        {
            return
        }
        if !self.bLoadForPagination && self.pageVal!.currentPage! < self.pageVal!.totalNoOfPages!
        {
            self.bLoadForPagination = true
            self.callFlickrApiWithSearchKeyword(searchKeywordText: searchKeyword, currentPage: self.pageVal!.currentPage! + 1)
        }
    }
}

// MARK: UICollectionViewDelegateFlowLayout
extension SearchTextEnteringCollectionViewController: UICollectionViewDelegateFlowLayout
{
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize
    {
        let paddingBetweenCell = sectionInsets.left * (2 + 1)
        let widthToDivideInCell = self.view.frame.width - paddingBetweenCell
        let widthofCell = widthToDivideInCell / 2
        return CGSize(width: widthofCell, height: widthofCell)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets
    {
        return sectionInsets
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat
    {
        return sectionInsets.left
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize
    {
        if (self.bLoadForPagination == true)
        {
            return CGSize.zero
        }
        return CGSize(width: collectionView.bounds.size.width, height: 55)
    }
    
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView
    {
        if kind == UICollectionView.elementKindSectionFooter
        {
            let pagingScrollerFooterView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: paginationViewReuseIdentifier, for: indexPath) as! PagingScrollerFooterReusableView
            self.pagingScrollerFooterView = pagingScrollerFooterView
            self.pagingScrollerFooterView?.backgroundColor = UIColor.clear
            return pagingScrollerFooterView
        }
        else
        {
            let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: paginationViewReuseIdentifier, for: indexPath)
            return headerView
        }
    }

    override func scrollViewDidScroll(_ scrollView: UIScrollView)
    {
        let pullConstant = 100.0
        let contentOffset = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height
        let differenceinHeight = contentHeight - contentOffset
        let heightofFrame = scrollView.bounds.size.height
        var pullVal  = Float((differenceinHeight - heightofFrame))/Float(pullConstant)
        pullVal =  min(pullVal, 0.0)
        let pullRatioToScroll  = min(abs(pullVal),1.0)
        self.pagingScrollerFooterView?.transformView(transformVal:CGAffineTransform.identity, scaleFactor:CGFloat(pullRatioToScroll))
        if pullRatioToScroll >= 1
        {
            self.pagingScrollerFooterView?.animateView()
        }
    }

    override func scrollViewDidEndDecelerating(_ scrollView: UIScrollView)
    {
        let contentOffset = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height
        let differenceinHeight = contentHeight - contentOffset
        let heightofFrame = scrollView.bounds.size.height
        let pullRatioToScroll  = abs(differenceinHeight - heightofFrame)
        if pullRatioToScroll == 0.0
        {
            if (self.pagingScrollerFooterView?.isAnimating)!
            {
                self.pagingScrollerFooterView?.startAnimate()
            }
        }
    }
}

