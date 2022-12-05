//
//  AppDelegate.swift
//  CountDownBuddy
//
//  Created by Daniel Bonates on 02/12/22.
//

import SwiftUI

class AppDelegate: NSObject, NSApplicationDelegate, NSMenuDelegate {
    
    private var statusItem: NSStatusItem?
    private var popover = NSPopover()
    private var timer: Timer!
    var selectedDate: Date! {
        didSet {
            UserDefaults.standard.set(selectedDate, forKey: "targetDate")
        }
    }
    
        
    func applicationDidFinishLaunching(_ notification: Notification) {
        
//        UserDefaults.standard.removeObject(forKey: "targetDates")
//        UserDefaults.standard.removeObject(forKey: "targetDate")
        
        statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)
        statusItem?.button?.title = "Time Buddy"
        statusItem?.menu = NSMenu()
        statusItem?.menu?.delegate = self
        
        loadSelectedDate()
        let contentView = ContentView(selectedDate: selectedDate, appDelegate: self)
        popover.contentSize = CGSize(width: 500, height: 400)
        popover.contentViewController = NSHostingController(rootView: contentView)
        
        NSEvent.addGlobalMonitorForEvents(matching: [.leftMouseDown, .rightMouseDown]) { [weak self] event in
            self?.popover.performClose(event)
        }
        
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { timer in
            let timeStr = self.updateTimer()
            self.statusItem?.button?.title = timeStr
        }
        timer.fire()
    }
    
    func loadSelectedDate() {
        selectedDate = UserDefaults.standard.object(forKey: "targetDate") as? Date ?? Date().plusMinutes(90)
    }
    
    func updateTimer() -> String {
        
        guard selectedDate != nil else { return "CountDown Buddy" }
        
        let diff = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute, .second], from: .localDate, to: selectedDate.localized())

        var finalStr = [String]()
        if let year = diff.year, year > 0 { finalStr.append("\(year) year\(year > 1 ? "s" : "")")}
        if let month = diff.month, month > 0 { finalStr.append("\(month) month\(month > 1 ? "s" : "")")}
        if let day = diff.day, day > 0 { finalStr.append("\(day) day\(day > 1 ? "s" : "")")}
        
        let minorComps = [diff.hour, diff.minute, diff.second].map { val in
            guard let val = val else {
                return "00"
            }
            return val < 10 ? "0\(val)" : "\(val)"
        }
        
        return finalStr.joined(separator: ", ") + (finalStr.isEmpty ? "" : " - ") + minorComps.joined(separator: ":")
    }
    
    @objc func showSettings() {
        guard let statusBarButton = statusItem?.button else { return }
        popover.show(relativeTo: statusBarButton.bounds, of: statusBarButton, preferredEdge: .maxY)
    }
    
    func addMenuItems() {
        statusItem?.menu?.removeAllItems()
        
        let dateFormatter = DateFormatter()
        dateFormatter.timeStyle = .full

        // dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZZZ"
        dateFormatter.dateFormat = "🗓 MM/dd/yyyy ⏱HH:mm:ss"
        
        let targetDates = UserDefaults.standard.object(forKey: "targetDates") as? [Date] ?? []

        for targetDate in targetDates {

            let formattedTime = dateFormatter.string(from: targetDate)

            let menuItem = CustomNSMenuItem(dateRepresented: targetDate, title: "\(formattedTime)", keyEquivalent: "", action: #selector(selectedDateChanged(_:)))
            statusItem?.menu?.addItem(menuItem)
        }
        
        statusItem?.menu?.addItem(.separator())
        statusItem?.menu?.addItem(withTitle: "Settings", action: #selector(showSettings), keyEquivalent: "")
        statusItem?.menu?.addItem(withTitle: "Quit", action: #selector(quit), keyEquivalent: "")

    }
    
    // MARK: - NSMenuDelegate
    func menuWillOpen(_ menu: NSMenu) {
        addMenuItems()
        popover.performClose(self)
    }
    
    @objc func quit() {
        NSApp.terminate(self)
    }
    
    @objc func selectedDateChanged(_ sender: CustomNSMenuItem) {
        self.selectedDate = sender.dateRepresented
        NSPasteboard.general.clearContents()
        NSPasteboard.general.setString(sender.title, forType: .string)
    }
}
