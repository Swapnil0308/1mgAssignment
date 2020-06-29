//
//  FlickrAPIResponseFetching.swift
//  1mgAssignment
//
//  Created by Swapnil on 26/06/20.
//  Copyright © 2020 Swapnil. All rights reserved.
//
// class for making the flickr api call and its handlitation according to the response

import Foundation

import UIKit

let apiKey = "4d972a8eaeac4db640a75e7b8297940e" //1mg api key
//let apiKey = "831d7ffe2b378d0225bb22d63c1bd90d" (myAPIKey)

class FlickrAPIResponseFetching
{
    // making flickr API call and handlitaion of its cases in response
    func searchFlickrAPIDataForKeyword(_ searchKeyword: String, pageValue: Int = 1,completion : @escaping (_ results: FlickrSearchResultsFromFlickerAPI?, _ paging: PaginationData?,_ error : NSError?) -> Void)
    {
        guard let searchURL = searchFlickrAPIDataForKeyword(searchKeyword, pageValue: pageValue)
        else
        {
            let APIError = NSError(domain: "FlickrSearchError", code: 0, userInfo: [NSLocalizedFailureReasonErrorKey:"Response error"])
            completion(nil, nil,APIError)
            return
        }
        
        let searchRequest = URLRequest(url: searchURL)
        
        URLSession.shared.dataTask(with: searchRequest, completionHandler:
        { (data, response, error) in
            
            if let _ = error
            {
                let APIError = NSError(domain: "FlickrSearchError", code: 0, userInfo: [NSLocalizedFailureReasonErrorKey:"Response error from API"])
                OperationQueue.main.addOperation({
                    completion(nil, nil,APIError)
                })
                return
            }
            
            guard let _ = response as? HTTPURLResponse,
            let data = data
            else
            {
                let APIError = NSError(domain: "FlickrSearchError", code: 0, userInfo: [NSLocalizedFailureReasonErrorKey:"Response error from API"])
                OperationQueue.main.addOperation({
                    completion(nil, nil,APIError)
                })
                return
            }
            
            do
            {
                guard let apiDataDictionary = try JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions(rawValue: 0)) as? [String: AnyObject],
                let flickrAPIData = apiDataDictionary["stat"] as? String
                else
                {
                    let APIError = NSError(domain: "FlickrSearchError", code: 0, userInfo: [NSLocalizedFailureReasonErrorKey:"Response error from API"])
                    OperationQueue.main.addOperation({
                        completion(nil, nil,APIError)
                    })
                    return
                }
                
                switch (flickrAPIData)
                {
                case "ok":
                    print("Results processed OK")
                case "fail":
                    if let errorMessage = apiDataDictionary["message"]
                    {
                        
                        let APIError = NSError(domain: "FlickrSearchError", code: 0, userInfo: [NSLocalizedFailureReasonErrorKey:errorMessage])
                        
                        OperationQueue.main.addOperation({
                            completion(nil, nil,APIError)
                        })
                    }
                    let APIError = NSError(domain: "FlickrSearchError", code: 0, userInfo: [NSLocalizedFailureReasonErrorKey:"Response error"])
                    
                    OperationQueue.main.addOperation({
                        completion(nil, nil,APIError)
                    })
                    return
                default:
                    let APIError = NSError(domain: "FlickrSearchError", code: 0, userInfo: [NSLocalizedFailureReasonErrorKey:"Response error from API"])
                    OperationQueue.main.addOperation({
                        completion(nil, nil,APIError)
                    })
                    return
                }
                print(apiDataDictionary)
                
                guard let photosDictionaryFromAPI = apiDataDictionary["photos"] as? [String: AnyObject],
                let photosReceived = photosDictionaryFromAPI["photo"] as? [[String: AnyObject]]
                else
                {
                    let APIError = NSError(domain: "FlickrSearchError", code: 0, userInfo: [NSLocalizedFailureReasonErrorKey:"Response error from API"])
                    OperationQueue.main.addOperation({
                        completion(nil, nil,APIError)
                    })
                    return
                }
                var paginationData : PaginationData?
                var flickrPhotoData = [FlickrPhotoData]()
                
                for photoObject in photosReceived
                {
                    guard let photoID = photoObject["id"] as? String,
                    let farm = photoObject["farm"] as? Int ,
                    let server = photoObject["server"] as? String ,
                    let secret = photoObject["secret"] as? String
                    else
                    {
                        break
                    }
                   let flickrPhotoDictFromAPI = FlickrPhotoData(photoID: photoID, farm: farm, server: server, secret: secret)
                    flickrPhotoData.append(flickrPhotoDictFromAPI)
                }
                
                if let currentPageofPaginationofPhotos = photosDictionaryFromAPI["page"] as? Int,
                let totalPagesForPagination = photosDictionaryFromAPI["pages"] as? Int ,
                let numberOfPhotos = photosDictionaryFromAPI["total"] as? String
                {
                    paginationData = PaginationData(totalPages: totalPagesForPagination, elements: Int32(numberOfPhotos)!, currentPage: currentPageofPaginationofPhotos)
                }
                
                OperationQueue.main.addOperation ({
                    completion(FlickrSearchResultsFromFlickerAPI(searchResultsFromFlickrAPI: flickrPhotoData),paginationData,nil)
                })
            }
            catch _
            {
                completion(nil, nil,nil)
                return
            }
            
            
        }) .resume()
    }
    
    fileprivate func searchFlickrAPIDataForKeyword(_ searchKeyword:String, pageValue: Int = 1) -> URL?
    {
        
        guard let allowedCharactersinUrlWithKeyword = searchKeyword.addingPercentEncoding(withAllowedCharacters: CharacterSet.alphanumerics)
        else
        {
            return nil
        }
        
        let URLString = "https://api.flickr.com/services/rest/?method=flickr.photos.search&api_key=\(apiKey)&text=\(allowedCharactersinUrlWithKeyword)&per_page=20&format=json&nojsoncallback=1&page=\(pageValue)"
        
        guard let url = URL(string:URLString) else
        {
            return nil
        }
        
        return url
    }
}

