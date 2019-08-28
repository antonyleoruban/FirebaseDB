//
//  RemoteConfig.swift
//  FireBaseDB
//
//  Created by Antony Leo Ruban Yesudass on 28/08/19.
//  Copyright © 2019 Antony Leo Ruban Yesudass. All rights reserved.
//

import Foundation
import FirebaseRemoteConfig
import Firebase

typealias ITMRemoteConfigSuccessCallBack = (_ response : Any) -> Void
typealias ITMRemoteConfigFailuerCallBack = (_ responseError : String) -> Void

class RemoteConfigClass {
    
    let baseURL = "base_url"
    let json_Value = "json_Value"

    var remoteConfig : RemoteConfig!
    static let shared: RemoteConfigClass = {
        
        let confi = RemoteConfigClass()
        confi.remoteConfig = RemoteConfig.remoteConfig()
        
        let remoteConfigSettings = RemoteConfigSettings(developerModeEnabled: true)
        confi.remoteConfig.configSettings = remoteConfigSettings
        return confi
        
    }()
    
    func fetchConfig(success: @escaping ITMRemoteConfigSuccessCallBack, failure: @escaping ITMRemoteConfigFailuerCallBack) {
        var expirationDuration = 3600
        // If your app is using developer mode, expirationDuration is set to 0, so each fetch will
        // retrieve values from the service.
        if remoteConfig.configSettings.isDeveloperModeEnabled {
            expirationDuration = 360
        }
        // [START fetch_config_with_callback]
        // TimeInterval is set to expirationDuration here, indicating the next fetch request will use
        // data fetched from the Remote Config service, rather than cached parameter values, if cached
        // parameter values are more than expirationDuration seconds old. See Best Practices in the
        // README for more information.
        remoteConfig.fetch(withExpirationDuration: TimeInterval(expirationDuration)) { (status, error) -> Void in
            if status == .success {
                debugPrint("Config fetched!")
                //self.remoteConfig.activateFetched()
                self.remoteConfig.activate(completionHandler: { (success) in
                   // debugPrint(success)

                })
                success("Config fetched!")
            } else {
                debugPrint("Config not fetched")
                debugPrint("Error: \(error?.localizedDescription ?? "No error available.")")
                failure("Config not fetched")
            }
        }
    }
    
    func getBaseUrl1() -> String {
        return remoteConfig[baseURL].stringValue ?? ""
    }
    
    func getJSon() -> Dictionary<String, Any> {
     
       let dict = [String:String]()
       let str = remoteConfig[json_Value].stringValue
        if str != nil {
            
            let data = str!.data(using: .utf8)!
            do {
                if let jsonArray = try JSONSerialization.jsonObject(with: data, options : .allowFragments) as? Dictionary<String,Any>           {
                    return jsonArray
                    
                } else {
                    print("bad json")
                }
            } catch let error as NSError {
                print(error)
            }
        }
        return dict
    }
}


