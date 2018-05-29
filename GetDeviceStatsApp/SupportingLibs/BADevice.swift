//
//  BADevice.swift
//  GetDeviceStatsApp
//
//  Created by Андрей Бабий on 26.05.18.
//  Copyright © 2018 Андрей Бабий. All rights reserved.
//

import Foundation
import UIKit

private enum Device {
    case phone
    case pad
    case another
}

protocol DeviceState {
    func changeFontSize()
}

final class BADevice {
    
    private var state: DeviceState = Another()
    private var device: Device = Device.another
    private var changeView: [UIView]
    
    init(changeView: [UIView]) {
        self.changeView = changeView
    }
    
    private func determineRuningDevice() {
        switch UIDevice.current.userInterfaceIdiom {
        case .phone:
            device = .phone
            state = Phone(changeView: changeView)
        case .pad:
            device = .pad
            state = Pad(changeView: changeView)
        default:
            device = .another
            state = Another()
        }
    }
    
    func changeFontSize() {
        determineRuningDevice()
        state.changeFontSize()
        
    }
    
}

final class Phone: DeviceState {
    private var changeView: [UIView]
    init(changeView: [UIView]) {
        self.changeView = changeView
    }
    func changeFontSize() {
        for element in changeView {
            change(element: element)
        }
        
    }
    
    private func change(element: UIView) {
        if let view = element as? UIStackView {
            for view in view.subviews as [UIView] {
                if let lable = view as? UILabel {
                    lable.font = UIFont.systemFont(ofSize: 13.0)
                }
            }
        } else if let view = element as? UILabel {
            view.font = UIFont.systemFont(ofSize: 13.0)
        }
    }
}



final class Pad: DeviceState {
    private var changeView: [UIView]
    init(changeView: [UIView]) {
        self.changeView = changeView
    }
    func changeFontSize() {
        for element in changeView {
            change(element: element)
        }
        
    }
    
    private func change(element: UIView) {
        if let view = element as? UIStackView {
            for view in view.subviews as [UIView] {
                if let lable = view as? UILabel {
                    lable.font = UIFont.systemFont(ofSize: 20.0)
                }
            }
        } else if let view = element as? UILabel {
            view.font = UIFont.systemFont(ofSize: 20.0)
        }
    }
}

final class Another: DeviceState {
    func changeFontSize() {
        
    }
}
