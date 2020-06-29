//
//  OperationQueue.swift
//  1mgAssignment
//
//  Created by Swapnil on 29/06/20.
//  Copyright © 2020 Swapnil. All rights reserved.
//
// class with methods to use for operation during the network call

import UIKit
import Foundation

class OperationQueueExtension: Operation
{
    var imagedownloadHandler: ImageDownloadHandler?
    var imageUrl: URL!
    var indexPath: IndexPath?
   
    override var isAsynchronous: Bool
    {
        get
        {
           return  true
        }
    }
    
    private var _executing = false
    {
        willSet
        {
            willChangeValue(forKey: "isExecuting")
        }
        didSet
        {
            didChangeValue(forKey: "isExecuting")
        }
    }
    
    private var _finish = false
    {
       willSet
       {
           willChangeValue(forKey: "isFinished")
       }
       didSet
       {
           didChangeValue(forKey: "isFinished")
       }
    }
    
    override var isExecuting: Bool
    {
        return _executing
    }
    
    override var isFinished: Bool
    {
        return _finish
    }
    
    func executing(_ executing: Bool)
    {
        _executing = executing
    }
    
    func finish(_ finish: Bool)
    {
        _finish = finish
    }
    
    required init (url: URL, indexPath: IndexPath?)
    {
        self.imageUrl = url
        self.indexPath = indexPath
    }
    
    override func main()
    {
        guard isCancelled == false else
        {
            finish(true)
            return
        }
        self.executing(true)
        self.downloadImageFromUrl()
    }
    
    // to download image from the URL
    func downloadImageFromUrl()
    {
       let newURLSession = URLSession.shared
       let imagedownloadTask = newURLSession.downloadTask(with: self.imageUrl)
       { (responseDataofAPI, response, error) in
        
        if let responseData = responseDataofAPI, let data = try? Data(contentsOf: responseData)
        {
            let photoImage = UIImage(data: data)
            self.imagedownloadHandler?(photoImage,self.imageUrl, self.indexPath,error)
        }
          self.finish(true)
          self.executing(false)
        }
        imagedownloadTask.resume()
    } 
}
