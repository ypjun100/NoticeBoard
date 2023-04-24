//
//  ViewController.swift
//  NoticeBoard
//
//  Created by 윤준영 on 2023/04/22.
//

import Cocoa
import Alamofire
import SwiftSoup

class ViewController: NSViewController {
    
    @IBOutlet var scrollView: NSScrollView!
    @IBOutlet var selectView: NSView!
    @IBOutlet var tableView: NSTableView!
    @IBOutlet var progressIndicator: NSProgressIndicator!
    
    var pageIndex = 0
    
    var notices: [Notice] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        selectView.wantsLayer = true
        selectView.layer?.cornerRadius = 5.0
        selectView.layer?.backgroundColor = CGColor(gray: 1.0, alpha: 0.05)
        
        BoardParser.parse(url: "https://home.sch.ac.kr/sch/06/010100.jsp", pageIndex: pageIndex) { notices in
            self.notices = notices
            self.tableView.reloadData()
        }
        
        tableView.action = #selector(onItemClicked) // 테이블 요소 선택
        
        NotificationCenter.default.addObserver(self, selector: #selector(onScrollEnded), name: NSScrollView.didEndLiveScrollNotification, object: nil)
    }

    override var representedObject: Any? {
        didSet {
        // Update the view, if already loaded.
        }
    }
    
    @objc func onItemClicked() {
        NSWorkspace.shared.open(URL(string: "https://home.sch.ac.kr/sch/06/010100.jsp" + notices[tableView.clickedRow].noticeURL)!)
    }
    
    @objc func onScrollEnded() {
        if(scrollView.contentView.bounds.origin.y + scrollView.contentView.bounds.height == scrollView.documentView?.bounds.height) {
            progressIndicator.startAnimation(self)
            pageIndex += 1
            BoardParser.parse(url: "https://home.sch.ac.kr/sch/06/010100.jsp", pageIndex: pageIndex) { notices in
                self.notices.append(contentsOf: notices)
                self.tableView.reloadData()
                self.progressIndicator.stopAnimation(self)
            }
        }
    }
}


extension ViewController: NSTableViewDataSource, NSTableViewDelegate {
    func numberOfRows(in tableView: NSTableView) -> Int {
        return (notices.count)
    }

    func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {
        let notice = notices[row]
        
        guard let cell = tableView.makeView(withIdentifier: tableColumn!.identifier, owner: self) as? NoticeTableCell else { return nil }
        
        cell.noticeType.stringValue = notice.noticeType == 0 ? "일반" : "공지"
        cell.noticeType.textColor = notice.noticeType == 0 ? NSColor.textColor : NSColor(red: 0.8, green: 0.15, blue: 0, alpha: 1.0)
        cell.noticeText.stringValue = notice.noticeName
        
        return cell
    }
    

    func tableViewSelectionDidChange(_ notification: Notification) {
        tableView.deselectRow(tableView.selectedRow) // 클릭 후 포커스가 유지되는 현상 방지
    }
}
