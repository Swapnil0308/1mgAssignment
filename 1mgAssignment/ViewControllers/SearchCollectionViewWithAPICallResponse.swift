//
//  SearchCollectionViewWithAPICallResponse.swift
//  1mgAssignment
//
//  Created by Swapnil on 28/06/20.
//  Copyright © 2020 Swapnil. All rights reserved.
//
// main view controller extension - when user enters the text in textfield and press enter then api call handilation class to get data and handle error

import UIKit
import Foundation

extension SearchTextEnteringCollectionViewController
{
  func callFlickrApiWithSearchKeyword(searchKeywordText: String, currentPage: Int)
  {
        flickrClassReference.searchFlickrAPIDataForKeyword(searchKeywordText, pageValue: currentPage)
        { dataFromAPIResponse, pageValue, errorInAPIResponse in
                   
           self.searchKeywordTextField.stopAnimating()
           if let pageValue = pageValue, pageValue.currentPage == 1
           {
               self.searchResult.searchResultsFromFlickrAPI.removeAll()
               self.collectionView?.reloadData()
           }
           
           if let errorResponse = errorInAPIResponse
           {
               print("Error:\(errorResponse)")
               return
           }
           
           if let dataFromAPI = dataFromAPIResponse
           {
               self.pageVal = pageValue
               self.searchResult.searchResultsFromFlickrAPI.append(contentsOf: dataFromAPI.searchResultsFromFlickrAPI)
               self.collectionView?.reloadData()
           }
           self.bLoadForPagination = false
         }
    }
}
