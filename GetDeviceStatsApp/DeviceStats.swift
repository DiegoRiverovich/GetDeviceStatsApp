//
//  DeviceStats.swift
//  GetDeviceStatsApp
//
//  Created by Андрей Бабий on 24.05.18.
//  Copyright © 2018 Андрей Бабий. All rights reserved.
//

import Foundation
import UIKit
import CoreTelephony // for connection type
import SystemConfiguration.CaptiveNetwork // for wi-fi SSID

struct Constants {
    static let ssid = "ssid"
    static let bssid = "bssid"
    static let stringNull = "Null"
    static let stringError = "Error"
    
    static let WiFi = "WiFi"
    static let cell2G = "2G"
    static let cell3G = "3G"
    static let cell4G = "4G"
}

final class DeviceStats {
    
    static let shared = DeviceStats()
    
    private var _deviceModel: String?
    var deviceModel: String {
        get {
            if _deviceModel != nil {
                return _deviceModel!
            } else {
                _deviceModel = getDeviceModel()
                return _deviceModel ?? Constants.stringNull
            }
        }
    }
    
    private var _osVersion: String?
    var osVersion: String {
        get {
            if _osVersion != nil {
                return _osVersion!
            } else {
                _osVersion = getOSVersion()
                return _osVersion ?? Constants.stringNull
            }
        }
    }
    
    private var _udid: String?
    var udid: String {
        get {
            if _udid != nil {
                return _udid!
            } else {
                _udid = getUDID()
                return _udid ?? Constants.stringNull
            }
        }
    }
    
    private var _screenResolution: String?
    var screenResolution: String {
        get {
            if _screenResolution != nil {
                return _screenResolution!
            } else {
                _screenResolution = getScreenResolution()
                return _screenResolution ?? Constants.stringNull
            }
        }
    }
    
    private var _deviceDpi: String?
    var deviceDpi: String {
        get {
            if _deviceDpi != nil {
                return _deviceDpi!
            } else {
                _deviceDpi = getDeviceDpi()
                return _deviceDpi ?? Constants.stringNull
            }
        }
    }
    
    private var _networkType: String?
    var networkType: String {
        get {
            if _networkType != nil {
                return _networkType!
            } else {
                _networkType = getNetworkType()
                return _networkType ?? Constants.stringNull
            }
        }
    }
    
    private var _wiFiInfo: [String:String]?
    var wiFiInfo: [String:String] {
        get {
            if _wiFiInfo != nil {
                return _wiFiInfo!
            } else {
                _wiFiInfo = getWiFiInfo()
                return _wiFiInfo ?? [Constants.ssid:Constants.stringNull, Constants.bssid:Constants.stringNull]
            }
        }
    }

    private init() {
        
    }
    
    func getDeviceModel() -> String {
        return UIDevice.modelName
    }
    
    func getOSVersion() -> String {
        return UIDevice.current.systemVersion
    }
    
    func getUDID() -> String {
        return UIDevice.current.identifierForVendor!.uuidString
    }
    
    func getScreenResolution() -> String {
        return "\(UIScreen.main.bounds.width) x \(UIScreen.main.bounds.height)"
    }
    
    func getDeviceDpi() -> String {
        return UIDevice.modelDPI
    }
    
    func getNetworkType() -> String {
        if let reachability = Reachability.forInternetConnection() {
            reachability.startNotifier()
            let status = reachability.currentReachabilityStatus()
            if status == .init(0) {
                // .NotReachable
                //print("Not Reachable")
                return Constants.stringNull
            }
            else if status == .init(1) {
                // .ReachableViaWiFi
                //print("Reachable Via WiFi")
                return Constants.WiFi
                
            }
            else if status == .init(2) {
                // .ReachableViaWWAN
                let netInfo = CTTelephonyNetworkInfo()
                if let cRAT = netInfo.currentRadioAccessTechnology  {
                    switch cRAT {
                    case CTRadioAccessTechnologyGPRS,
                         CTRadioAccessTechnologyEdge,
                         CTRadioAccessTechnologyCDMA1x:
                        //print("Reachable Via 2G")
                        return Constants.cell2G
                    case CTRadioAccessTechnologyWCDMA,
                         CTRadioAccessTechnologyHSDPA,
                         CTRadioAccessTechnologyHSUPA,
                         CTRadioAccessTechnologyCDMAEVDORev0,
                         CTRadioAccessTechnologyCDMAEVDORevA,
                         CTRadioAccessTechnologyCDMAEVDORevB,
                         CTRadioAccessTechnologyeHRPD:
                        //print("Reachable Via 3G")
                        return Constants.cell3G
                    case CTRadioAccessTechnologyLTE:
                        //print("Reachable Via 4G")
                        return Constants.cell4G
                    default:
                        fatalError(Constants.stringError)
                    }
                }
            }
        } else {
            return Constants.stringNull
        }
        return Constants.stringNull
    }
    
    func getWiFiInfo() -> [String:String]? /*String?*/ {
        //var ssid: String?
        var info: [String:String]? = [:]
        if let interfaces = CNCopySupportedInterfaces() as NSArray? {
            for interface in interfaces {
                if let interfaceInfo = CNCopyCurrentNetworkInfo(interface as! CFString) as NSDictionary? {
                    //ssid = interfaceInfo[kCNNetworkInfoKeySSID as String] as? String
                    info?[Constants.ssid] = interfaceInfo[kCNNetworkInfoKeySSID as String] as? String
                    info?[Constants.bssid] = interfaceInfo[kCNNetworkInfoKeyBSSID as String] as? String
                    break
                }
            }
        }
        //return ssid
        return info
    }
    
    func getCurrentTime() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm:ss" //"dd-MM-yyyy HH:mm"
        let dateInFormat = dateFormatter.string(from: Date())
        return dateInFormat
    }

}
