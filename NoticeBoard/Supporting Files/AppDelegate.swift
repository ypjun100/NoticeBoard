//
//  AppDelegate.swift
//  NoticeBoard
//
//  Created by 윤준영 on 2023/04/22.
//
// icon image is from https://www.vecteezy.com/png/9847903-3d-notification-bell-set-ecommerce-icon

import Cocoa

@main
class AppDelegate: NSObject, NSApplicationDelegate {
    
    @IBOutlet weak var infoMenuItem: NSMenuItem!
    @IBOutlet weak var settingsMenuItem: NSMenuItem!
    @IBOutlet weak var quitMenuItem: NSMenuItem!
    
    func applicationDidFinishLaunching(_ aNotification: Notification) {
        // Insert code here to initialize your application
        infoMenuItem.title = "정보"
        settingsMenuItem.title = "설정"
        quitMenuItem.title = "종료"
    }

    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }

    func applicationSupportsSecureRestorableState(_ app: NSApplication) -> Bool {
        return true
    }

    func applicationShouldTerminateAfterLastWindowClosed(_ sender: NSApplication) -> Bool { // 창의 'x' 버튼을 누르면 프로그램 종료
        return true
    }

}

