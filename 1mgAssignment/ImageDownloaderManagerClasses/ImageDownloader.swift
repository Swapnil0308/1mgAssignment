//
//  ImageDownloader.swift
//  1mgAssignment
//
//  Created by Swapnil on 29/06/20.
//  Copyright © 2020 Swapnil. All rights reserved.
//


import UIKit
import Foundation

typealias ImageDownloadHandler = (_ image: UIImage?, _ url: URL, _ indexPath: IndexPath?, _ error: Error?) -> Void

final class ImageDownloader
{
    private var imageDownloadcompletionHandler: ImageDownloadHandler?
    lazy var imageDownloadOperationQueue: OperationQueue =
    {
        var queue = OperationQueue()
        queue.name = "com.flickrTest.imageDownloadqueue"
        queue.qualityOfService = .userInteractive
        return queue
    }()
    let imageCache = NSCache<NSString, UIImage>()
    static let shared = ImageDownloader()
    
    func downloadImage(_ photo: FlickrPhotoData, indexPath: IndexPath?, size: String = "m", handler: @escaping ImageDownloadHandler)
    {
        self.imageDownloadcompletionHandler = handler
        guard let urlofImage = photo.flickrPhotoImageURL(size) else
        {
            return
        }
        if let cache = imageCache.object(forKey: urlofImage.absoluteString as NSString)
        {
            //check if image is in cache, if YES then return the cached image
           self.imageDownloadcompletionHandler?(cache, urlofImage, indexPath, nil)
        }
        else
        {
            // To download the image
            let operationQueue = OperationQueueExtension(url: urlofImage, indexPath: indexPath)
            operationQueue.queuePriority = .high
            operationQueue.imagedownloadHandler =
            {
              (photoImage, urlImage, indexPath, error) in
                if let newPhotoImage = photoImage
                {
                    self.imageCache.setObject(newPhotoImage, forKey: urlImage.absoluteString as NSString)
                }
                self.imageDownloadcompletionHandler?(photoImage, urlImage, indexPath, error)
            }
            imageDownloadOperationQueue.addOperation(operationQueue)
        }
    }
}

