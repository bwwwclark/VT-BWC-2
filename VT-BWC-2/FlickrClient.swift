//
//  FlickrClient.swift
//  VT-BWC-2
//
//  Created by Ben Clark on 11/16/16.
//  Copyright © 2016 Ben Clark. All rights reserved.
//

import Foundation
import Foundation
import UIKit


typealias CompletionHandler = (_ result: [Photos]?, _ error: String?) -> Void

class FlickrClient {
    var stack: CoreDataStack!
    
    
    func getPhotos(latitude: Double, longitude: Double, pin: Pin, completionHandlerForPhotos: (_ result: [Photos]?, _ error: String?) -> Void) {
        
        taskForFlickrGETMethod(latitude: latitude, longitude: longitude) { (results, error) in
            
            
            if let error = error {
                completionHandlerForPhotos(self.result, error)// not sure why it's not reading results from above
                
                
            } else {
                
                var finalPhotos:[Photos] = []
                
                let delegate = UIApplication.shared.delegate as! AppDelegate
                
                self.stack = delegate.stack
                
                let photos = results?["photos"] as! [String: AnyObject]
                
                let photo = photos["photo"] as! [[String: AnyObject]]
                
                for p in photo {
                    let farm = p["farm"]
                    let server = p["server"]
                    let id = p["id"]
                    let secret = p["secret"]
                    
                    let url = "http://farm\(farm!).staticflickr.com/\(server!)/\(id!)_\(secret!)_m.jpg"
                    
                    photo.pin = pin
                    
                    let photo = photos(url: url, data: nil, context: self.stack.context)
                    
                    do{
                        try self.stack.context.save()
                    }catch{
                        fatalError("Error while saving main context: \(error)")
                    }
                    
                    finalPhotos.append(photo)
                }
                completionHandlerForPhotos(finalPhotos, nil)
            }
        }
    }
    
    func taskForFlickrGETMethod(latitude: Double, longitude: Double, completionHandler: (_ result: AnyObject?, _ error: NSError?) -> Void) -> URLSessionDataTask {
        
        let page = String(arc4random_uniform(40) + 1)
        
        
        let url0 = "https://api.flickr.com/services/rest/?method=flickr.photos.search&api_key=7eaeeb9b2a2b5fb73118f4802fa13b65&lat=\(latitude)&lon=\(longitude)&format=json&nojsoncallback=1&per_page=21&page=\(page)"
        
        let urlBase = Constants.Flickr.APIScheme + Constants.Flickr.APIHost + Constants.Flickr.APIPath
        
        
        //Break up or make less complex
        let ApiParameters = Constants.FlickrParameterKeys.Method + Constants.FlickrParameterValues.SearchMethod + "&" + Constants.FlickrParameterKeys.APIKey + Constants.FlickrParameterValues.APIKey + "&"
        
        let coordinateParameters = Constants.FlickrParameterValues.lat + String(latitude) + Constants.FlickrParameterValues.lon + String(longitude)
        
        let extraParameters = Constants.FlickrParameterKeys.Format + Constants.FlickrParameterValues.ResponseFormat + Constants.FlickrParameterKeys.NoJSONCallback
        
        let pageParameters = Constants.FlickrParameterKeys.PerPage + Constants.FlickrParameterValues.PerPageLimit + "&" + Constants.FlickrParameterKeys.Page + page
        
        
        
        let urlString = urlBase + ApiParameters + coordinateParameters + extraParameters + pageParameters
        
        let url = NSURL(string: urlString)
        
        let request = NSMutableURLRequest(url: url! as URL)
        
        let session = URLSession.shared
        
        let task = session.dataTask(with: request as URLRequest) { (data, response, error) in
            
            /* GUARD: Was there an error? */
            guard (error == nil) else {
                print("There was an error with your request: \(error)")
                return
            }
            
            /* GUARD: Did we get a successful 2XX response? */
            guard let statusCode = (response as? HTTPURLResponse)?.statusCode, statusCode >= 200 && statusCode <= 299 else {
                if let response = response as? HTTPURLResponse {
                    print("Your request returned an invalid response! Status code: \(response.statusCode)!")
                } else if let response = response {
                    print("Your request returned an invalid response! Response: \(response)!")
                    print(urlString)
                } else {
                    print("Your request returned an invalid response!")
                }
                return
            }
            
            /* GUARD: Was there any data returned? */
            guard let data = data else {
                print("No data was returned by the request!")
                return
            }
            
            //FlickrClient.parseJSONwithCompletionHandler(data, completionHandler: completionHandler)
            
            
            
            
        }
        task.resume()
        return task
        
    }
    
    
    
    func requestPhotoData(photos: [Photos], indexPath: NSIndexPath, completionHandlerForConvertData: @escaping (_ result: NSData?, _ error: String?) ->Void) {
        
        
        let requestURL: NSURL = NSURL(string: photos[indexPath.item].url!)! //IT DOES, but for some reason it is not recognizing it in Photos
        
        let task = URLSession.shared.dataTask(with: requestURL as URL) { (data, response, error) in
            
            guard (error == nil) else {
                
                completionHandlerForConvertData(nil, "Couldn't parse data")
                return
            }
            
            guard let data = data else {
                completionHandlerForConvertData(nil, "Could not parse data")
                return
                
            }
            completionHandlerForConvertData(data as NSData?, nil)
        }
        
        task.resume()
        
    }
    
    private func convertDataWithCompletionHandler(data: NSData, completionHandlerForConvertData: (_ result: AnyObject?, _ error: String?) -> Void) {
        var parsedResult: Any!
        
        do{
            parsedResult = try JSONSerialization.jsonObject(with: data as Data, options: .allowFragments)
             //obj = try NSJSONSerialization.JSONObjectWithData( data, options:[]) as AnyObject
        } catch {
            
            completionHandlerForConvertData(nil, "couldn't parse data")
            
        }
        completionHandlerForConvertData(parsedResult as AnyObject?, nil)
        
    }
    
    
    
    class func sharedInstance() -> FlickrClient{
        struct Singleton {
            static var sharedInstance = FlickrClient()
        }
        return Singleton.sharedInstance
    }
}














