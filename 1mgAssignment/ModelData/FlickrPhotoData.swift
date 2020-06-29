//
//  FlickrPhotoData.swift
//  1mgAssignment
//
//  Created by Swapnil on 26/06/20.
//  Copyright © 2020 Swapnil. All rights reserved.
//
// model data of the image got from flickr api response


import UIKit

class FlickrPhotoData
{
  let photoID : String
  let farm : Int
  let server : String
  let secret : String
  
  init (photoID:String,farm:Int, server:String, secret:String)
  {
    self.photoID = photoID
    self.farm = farm
    self.server = server
    self.secret = secret
  }
  
  func flickrPhotoImageURL(_ size:String = "m") -> URL?
  {
    if let url =  URL(string: "https://farm\(farm).staticflickr.com/\(server)/\(photoID)_\(secret)_\(size).jpg")
    {
      return url
    }
    return nil
  }
}
