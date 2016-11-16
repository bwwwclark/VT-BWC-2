//
//  FlickrConstants.swift
//  VT-BWC-2
//
//  Created by Ben Clark on 11/16/16.
//  Copyright © 2016 Ben Clark. All rights reserved.
//

import Foundation
import UIKit

// MARK: - Constants

extension FlickrClient {
    
    struct Constants {
        
        // MARK: Flickr
        struct Flickr {
            static let APIScheme = "https://"
            static let APIHost = "api.flickr.com"
            static let APIPath = "/services/rest/?"
            
            static let SearchBBoxHalfWidth = 1.0
            static let SearchBBoxHalfHeight = 1.0
            static let SearchLatRange = (-90.0, 90.0)
            static let SearchLonRange = (-180.0, 180.0)
            //  static let FlickrURL =  "https://api.flickr.com/services/rest/?method=flickr.photos.search&api_key=7eaeeb9b2a2b5fb73118f4802fa13b65&lat=\(latitude)&lon=\(longitude)&format=json&nojsoncallback=1&per_page=21&page=\(page)"
        }
        
        // MARK: Flickr Parameter Keys
        struct FlickrParameterKeys {
            static let Method = "method="
            static let APIKey = "api_key="
            static let GalleryID = "gallery_id="
            static let Extras = "extras="
            static let Format = "format="
            static let NoJSONCallback = "nojsoncallback=1"
            static let SafeSearch = "safe_search"
            static let Text = "text"
            static let BoundingBox = "bbox"
            static let Page = "page="
            static let PerPage = "per_page="
            
        }
        
        // MARK: Flickr Parameter Values
        struct FlickrParameterValues {
            static let SearchMethod = "flickr.photos.search"
            static let APIKey = "YOUR_API_KEY_HERE"
            static let ResponseFormat = "json"
            static let DisableJSONCallback = "1" /* 1 means "yes" */
            static let GalleryPhotosMethod = "flickr.galleries.getPhotos"
            static let GalleryID = "5704-72157622566655097"
            static let MediumURL = "url_m"
            static let UseSafeSearch = "1"
            static let FindByLatLonMethod = "flickr.places.findByLatLon"
            static let lat = "lat="
            static let lon = "lon="
            static let PerPageLimit = "21"
            
            
        }
        
        // MARK: Flickr Response Keys
        struct FlickrResponseKeys {
            static let Status = "stat"
            static let Photos = "photos"
            static let Photo = "photo"
            static let Title = "title"
            static let MediumURL = "url_m"
            static let Pages = "pages"
            static let Total = "total"
        }
        
        // MARK: Flickr Response Values
        struct FlickrResponseValues {
            static let OKStatus = "ok"
        }
        
        // FIX: As of Swift 2.2, using strings for selectors has been deprecated. Instead, #selector(methodName) should be used.
        /*
         // MARK: Selectors
         struct Selectors {
         static let KeyboardWillShow: Selector = "keyboardWillShow:"
         static let KeyboardWillHide: Selector = "keyboardWillHide:"
         static let KeyboardDidShow: Selector = "keyboardDidShow:"
         static let KeyboardDidHide: Selector = "keyboardDidHide:"
         }
         */
    }
}

