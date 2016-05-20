//
//  FirstViewController.swift
//  One Support Tool
//
//  Created by Admin on 2016-02-04.
//  Copyright © 2016 EVRY. All rights reserved.
//

import Foundation
import UIKit
import MessageUI

class TicketsViewController: UIViewController,MFMailComposeViewControllerDelegate {
    

    /////////////////////////
    // CONTACT INFORMATION //
    /////////////////////////
    let contactEmail = "alexander.taavitsainen@evry.com"
    
    @IBOutlet weak var mailTicket: UITextField!
    @IBOutlet weak var mailDescription: UITextField!
    @IBOutlet weak var mailPreviousCondition: UITextField!
    @IBOutlet weak var mailCircumstance: UITextField!
    @IBOutlet weak var mailOthersAffected: UITextField!
    @IBOutlet weak var mailSenderName: UITextField!
    @IBOutlet weak var mailSenderPhone: UITextField!
    @IBOutlet weak var mailSenderLocation: UITextField!

    @IBAction func mailSender(sender: AnyObject) {
        //let mailComposeViewController = configuredMailComposeViewController()
        //self.presentViewController(mailComposeViewController, animated: true, completion: nil)
        
        let mailComposeViewController = configuredMailComposeViewController()
        
        if MFMailComposeViewController.canSendMail(){
        
            self.presentViewController(mailComposeViewController, animated: true, completion: nil)
        }
        else{
            self.showSendMailErrorAlert()
        }
        
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        UIDevice.currentDevice().batteryMonitoringEnabled = true
    }
   
    /**
    func configuredMailComposeViewController() -> MFMailComposeViewController {
        let mailComposerVC = MFMailComposeViewController()
        mailComposerVC.mailComposeDelegate = self
        mailComposerVC.setToRecipients([contactEmail])

        // Check if anything else is empty first, if it is not, then we shouldn't send anything.
        if (mailDescription.text == nil || mailCircumstance.text == nil || mailOthersAffected.text == nil || mailPreviousCondition.text == nil || mailSenderLocation.text == nil || mailSenderName.text == nil || mailSenderPhone.text == nil) {
            let alertController = UIAlertController(
                title: "Empty Field/s",
                message: "Please enter information in all applicable fields",
                preferredStyle: UIAlertControllerStyle.Alert)
            let okButton = UIAlertAction(
                title: "Ok",
                style: UIAlertActionStyle.Default,
                handler: nil)
        
            alertController.addAction(okButton)
            self.presentViewController(alertController, animated: true, completion: nil)
        }
        let mailSubject = mailTicket.text
        mailComposerVC.setSubject(mailSubject!)
        
        var message = mailDescription.text! + "\r\n"
        message += "WHEN DID IT LAST WORK?: " + mailPreviousCondition.text! + "\r\n"
        message += "WHEN AND WHERE DID THE PROBLEM OCCUR?: " + mailCircumstance.text! + "\r\n"
        message += "ARE OTHERS AFFECTED BY THE PROBLEM?: " + mailOthersAffected.text! + "\r\n"
        message += "NAME: " + mailSenderName.text! + "\r\n"
        message += "PHONE: " + mailSenderPhone.text! + "\r\n"
        message += "LOCATION: " + mailSenderLocation.text! + "\r\n"
        message += "----------------------------------------" + "\r\n"
        message += "BATTERY STATUS: " + batteryStatus + "\r\n"
        message += "DEVICE: " + device + "\r\n"
        message += "OS: " + osName + "\r\n"
        message += "OS VERSION: " + osVersion + "\r\n"
        message += "MEMORY: " + physicalMemory + "\r\n"
        message += "NUMBER OF PROCESSORS: " + processorCount + "\r\n"
        message += "SYSTEM UP TIME: " + systemUptime + "\r\n"
        message += "IP ADDRESS: " + IpAdress!
        
        
        mailComposerVC.setMessageBody(message, isHx x   TML: false)
        
        return mailComposerVC
    }

**/
     
    func configuredMailComposeViewController () -> MFMailComposeViewController {
        let mailComposerVC = MFMailComposeViewController()
        mailComposerVC.mailComposeDelegate = self
        
        mailComposerVC.setToRecipients([contactEmail])
        mailComposerVC.setSubject("Min test Subject")
        mailComposerVC.setMessageBody("Hej!\n\nJag heter Alexander", isHTML: false)
        
        return mailComposerVC
    }
    
    func showSendMailErrorAlert() {
    
        let sendMailAlert = UIAlertController(title: "Could Not Send Email", message: "Your device could not send e-mail. Please check e-mail configuration and try again", preferredStyle: .Alert)
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel, handler: {(alert: UIAlertAction!) in print("cancel")})
        
        sendMailAlert.addAction(cancelAction)
    
    }
    
    func mailComposeController(controller: MFMailComposeViewController, didFinishWithResult result: MFMailComposeResult, error: NSError?) {
        
        switch result.rawValue {
        
        case MFMailComposeResultCancelled.rawValue:
            print("Cancelled mail")
        case MFMailComposeResultSent.rawValue:
            print("Mail sent")
            
        default:
            break
        }
        
        self.dismissViewControllerAnimated(true, completion: nil)
        //controller.dismissViewControllerAnimated(true, completion: nil)
    }
    
    
    
    // Battery Information
    let batteryStatus = String(Int(UIDevice.currentDevice().batteryLevel) * 100) + "%"
    
    // Device Information
    let device = UIDevice.currentDevice().name
    
    // OS Information
    let osName = UIDevice.currentDevice().systemName
    
    // OS Version
    let osVersion = String(NSProcessInfo.processInfo().operatingSystemVersionString)
    
    // Memory Information
    let physicalMemory = String(NSProcessInfo.processInfo().physicalMemory)
    
    // # Processors
    let processorCount = String(NSProcessInfo.processInfo().processorCount)
    
    // System Uptime
    let systemUptime = String(NSProcessInfo.processInfo().systemUptime)
    
    // Networks available
    let IpAdress = getIFAddresses().first
    
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

