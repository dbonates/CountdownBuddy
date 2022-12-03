//
//  CustomNSMenuItem.swift
//  CountdownBuddy
//
//  Created by Daniel Bonates on 03/12/22.
//

import Cocoa

class CustomNSMenuItem: NSMenuItem {
    
    var dateRepresented: Date = Date()

    init(dateRepresented: Date, title: String, keyEquivalent: String, action: Selector?) {
        self.dateRepresented = dateRepresented
        super.init(title: title, action: action, keyEquivalent: keyEquivalent)
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
