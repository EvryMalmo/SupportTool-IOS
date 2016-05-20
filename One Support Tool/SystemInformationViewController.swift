//
//  SystemInformationViewController.swift
//  One Support Tool
//
//  Created by Admin on 2016-02-04.
//  Copyright © 2016 EVRY. All rights reserved.
//

import UIKit
import SystemConfiguration
import Foundation
import NetworkExtension

class SystemInformationViewController: UIViewController {
    
    
    @IBOutlet weak var batteryStatus: UITextField!
    @IBOutlet weak var osVersion: UITextField!
    @IBOutlet weak var device: UITextField!
    @IBOutlet weak var osName: UITextField!
    @IBOutlet weak var physicalMemory: UITextField!
    @IBOutlet weak var processorCount: UITextField!
    @IBOutlet weak var systemUptime: UITextField!
    @IBOutlet weak var IpAdress: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
         
        // Battery Information
        UIDevice.currentDevice().batteryMonitoringEnabled = true
        batteryStatus.text = String(Int(UIDevice.currentDevice().batteryLevel) * 100) + "%"
        
        // Device Information
        device.text = UIDevice.currentDevice().name
        
        // OS Information
        osName.text = UIDevice.currentDevice().systemName
        
        // OS Version
        osVersion.text = String(NSProcessInfo.processInfo().operatingSystemVersionString)
        
        // Memory Information
        physicalMemory.text = String(NSProcessInfo.processInfo().physicalMemory)
        
        // # Processors
        processorCount.text = String(NSProcessInfo.processInfo().processorCount)
        
        // System Uptime
        systemUptime.text = String(NSProcessInfo.processInfo().systemUptime)
        
        // Networks available
        IpAdress.text = getIFAddresses().first
        
    }
    
    
    func getIFAddresses() -> [String] {
        var addresses = [String]()
        
        // Get list of all interfaces on the local machine:
        var ifaddr : UnsafeMutablePointer<ifaddrs> = nil
        if getifaddrs(&ifaddr) == 0 {
            
            // For each interface ...
            for (var ptr = ifaddr; ptr != nil; ptr = ptr.memory.ifa_next) {
                let flags = Int32(ptr.memory.ifa_flags)
                var addr = ptr.memory.ifa_addr.memory
                
                // Check for running IPv4, IPv6 interfaces. Skip the loopback interface.
                if (flags & (IFF_UP|IFF_RUNNING|IFF_LOOPBACK)) == (IFF_UP|IFF_RUNNING) {
                    if addr.sa_family == UInt8(AF_INET) || addr.sa_family == UInt8(AF_INET6) {
                        
                        // Convert interface address to a human readable string:
                        var hostname = [CChar](count: Int(NI_MAXHOST), repeatedValue: 0)
                        if (getnameinfo(&addr, socklen_t(addr.sa_len), &hostname, socklen_t(hostname.count),
                            nil, socklen_t(0), NI_NUMERICHOST) == 0) {
                                if let address = String.fromCString(hostname) {
                                    addresses.append(address)
                                }
                        }
                    }
                }
            }
            freeifaddrs(ifaddr)
        }
        
        return addresses
    }
    
    
     override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}