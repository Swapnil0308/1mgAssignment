//
//  SearchTextEnteringCollectionViewController.swift
//  1mgAssignment
//
//  Created by Swapnil on 26/06/20.
//  Copyright © 2020 Swapnil. All rights reserved.
//
// main view controller on which user will search by entering text in textfield

import UIKit

final class SearchTextEnteringCollectionViewController: UICollectionViewController
{
    var searchResult = FlickrSearchResultsFromFlickerAPI()
    let flickrClassReference = FlickrAPIResponseFetching()
    let paginationViewReuseIdentifier = "ScrollerFooterReusableView"
    @IBOutlet weak var searchKeywordTextField: SearchKeywordDataTextField!
    var searchesResultFromAPI = FlickrSearchResultsFromFlickerAPI()
    var pageVal: PaginationData?
    let sectionInsets = UIEdgeInsets(top: 10.0, left: 10.0, bottom: 10.0, right: 10.0)
    var pagingScrollerFooterView: PagingScrollerFooterReusableView?
    var bLoadForPagination = Bool()
    var breachabilityToNetwork = ReachabilityToNetwork()
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        self.bLoadForPagination = false
       
        // Register cell classes
        self.collectionView.register(UINib(nibName: "PagingScrollerFooterReusableView", bundle: nil), forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: paginationViewReuseIdentifier)
    }
    
    func photoToBeDisplayedOnIndexPath(indexPath: IndexPath) -> FlickrPhotoData
    {
        return searchResult.searchResultsFromFlickrAPI[(indexPath as NSIndexPath).row]
    }
     /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */
}

// MARK: UITextFieldDelegate
extension SearchTextEnteringCollectionViewController: UITextFieldDelegate
{
    func textFieldShouldReturn(_ textField: UITextField) -> Bool
    {
        textField.resignFirstResponder()
        self.pageVal = nil
        self.bLoadForPagination = true
        guard let searchKeywordText = textField.text, searchKeywordText.count > 0
        else
        {
            self.searchResult.searchResultsFromFlickrAPI.removeAll()
            self.collectionView?.reloadData()
            self.bLoadForPagination = false
            return true
        }
        if (breachabilityToNetwork.isConnectedToNetwork() == true)
        {
          self.searchKeywordTextField.startAnimating()
           self.callFlickrApiWithSearchKeyword(searchKeywordText: searchKeywordText, currentPage: 1)
        }
        else
        {
            self.searchKeywordTextField.activityIndicator.stopAnimating()
            self.showToastMessage(message: "No Internet Connection.Please try again!", font: .systemFont(ofSize: 12.0))
        }
       
        return true
    }
}

