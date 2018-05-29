//
//  ViewController.swift
//  GetDeviceStatsApp
//
//  Created by Андрей Бабий on 22.05.18.
//  Copyright © 2018 Андрей Бабий. All rights reserved.
//

import UIKit

class ViewController: UIViewController, GPSLocationProtocol {
    
    @IBOutlet weak var leftStackView: UIStackView!
    @IBOutlet weak var rightStackView: UIStackView!
    
    @IBOutlet weak var deviceModelLabel: UILabel!
    @IBOutlet weak var osVersionLabel: UILabel!
    @IBOutlet weak var udidLabel: UILabel!
    @IBOutlet weak var screenResolutionLabel: UILabel!
    @IBOutlet weak var dpiLabel: UILabel!
    @IBOutlet weak var gpsCoordinatesLabel: UILabel!
    @IBOutlet weak var networkConnectionTypeLabel: UILabel!
    @IBOutlet weak var wifiSSIDLabel: UILabel!
    @IBOutlet weak var wifiBSSIDLabel: UILabel!
    @IBOutlet weak var currentTimeLabel: UILabel!
    
    
    @IBOutlet weak var getStatsButtonOutlet: UIButton!
    
    @IBAction func getStatsButtonAction(_ sender: UIButton) {
        showStats()
        gps?.getGPSLocation()
        moveButtonDownAndShowStackViews()
    }
    
    var gps: GPSLocation?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        gps = GPSLocation()
        gps?.delegate = self
        
        // button view setup
        getStatsButtonSetup()
        
        // hide Stacks View
        hideStacksView()
        
        let device = BADevice(changeView: [leftStackView, rightStackView])
        device.changeFontSize()
        
    }
    
    private func moveButtonDownAndShowStackViews() {
        UIView.animate(withDuration: 0.5, animations: { [weak self] in
            guard let weakSelf = self else { return }
            weakSelf.getStatsButtonOutlet.center = CGPoint(x: weakSelf.view.frame.width / 2, y: weakSelf.view.frame.height * 0.95)
        }) { (finished) in
            if finished {
                UIView.animate(withDuration: 0.5, animations: { [weak self] in
                    guard let weakSelf = self else { return }
                    weakSelf.leftStackView.alpha = 1.0
                    weakSelf.rightStackView.alpha = 1.0
                })
            }
        }
    }
    
    private func hideStacksView() {
        leftStackView.alpha = 0.0
        rightStackView.alpha = 0.0
    }
    
    private func showStats() {
        
        //print("Device model \(DeviceStats.shared.deviceModel)")
        deviceModelLabel.text = DeviceStats.shared.deviceModel
        //print("OS Version \(DeviceStats.shared.osVersion)")
        osVersionLabel.text = DeviceStats.shared.osVersion
        //print("UDID \(DeviceStats.shared.udid)")
        udidLabel.text = DeviceStats.shared.udid
        //print("Screen resolution \(DeviceStats.shared.screenResolution)")
        screenResolutionLabel.text = DeviceStats.shared.screenResolution
        //print("Device DPI \(DeviceStats.shared.deviceDpi)")
        dpiLabel.text = DeviceStats.shared.deviceDpi
        //print("Connection type \(DeviceStats.shared.networkType)")
        networkConnectionTypeLabel.text = DeviceStats.shared.networkType
        //print("Wi-fi SSID \(deviceShared.getWiFiInfo() ?? "Null")")
        //print("Wi-fi SSID \(DeviceStats.shared.wiFiInfo[Constants.ssid] ?? Constants.stringNull)")
        wifiSSIDLabel.text = DeviceStats.shared.wiFiInfo[Constants.ssid] ?? Constants.stringNull
        //print("Wi-fi BSSID \(DeviceStats.shared.wiFiInfo[Constants.bssid] ?? Constants.stringNull)")
        wifiBSSIDLabel.text = DeviceStats.shared.wiFiInfo[Constants.bssid] ?? Constants.stringNull
        //print("Current time: \(DeviceStats.shared.getCurrentTime())")
        currentTimeLabel.text = DeviceStats.shared.getCurrentTime()
        
    }
    
    func callbackLocation(latitude: Double, longitude: Double) {
        //print("Lat:\(latitude), Lon:\(longitude)")
        gpsCoordinatesLabel.text = "Latitude:\(latitude),\nLongitude:\(longitude)"
    }
    
    func callbackErrorLocation(location: String) {
        //print("Error callbacklocation: \(location)")
        gpsCoordinatesLabel.text = "\(location)"
    }
    
    
    private func getStatsButtonSetup() {
        getStatsButtonOutlet.backgroundColor = .clear
        getStatsButtonOutlet.layer.cornerRadius = 1
        getStatsButtonOutlet.layer.borderWidth = 1
        getStatsButtonOutlet.layer.borderColor = UIColor.lightGray.cgColor
        getStatsButtonOutlet.setTitleColor(UIColor.lightGray, for: .normal)
        
        getStatsButtonOutlet.center = CGPoint(x: self.view.frame.width / 2, y: self.view.frame.height / 2)
    }

}

