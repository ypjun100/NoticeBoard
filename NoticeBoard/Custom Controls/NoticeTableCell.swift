//
//  NoticeTableCell.swift
//  NoticeBoard
//
//  Created by 윤준영 on 2023/04/22.
//

import Cocoa

class NoticeTableCell: NSTableCellView {
    @IBOutlet var noticeType: NSTextField!
    @IBOutlet var noticeText: NSTextField!
    
    override func draw(_ dirtyRect: NSRect) {
        super.draw(dirtyRect)

        // Drawing code here.
    }
    
}
