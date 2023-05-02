//
//  BookMarkController.swift
//  NoticeBoard
//
//  Created by 윤준영 on 2023/05/01.
//

import Cocoa

class BookmarkViewController: NSViewController {
    
    @IBOutlet var tableView: NSTableView!
    
    var notices: [Notice] = [] // 게시글
    let bookmarkedNoticeManager = BookmarkedNoticeManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.notices = bookmarkedNoticeManager.getNotices()
        self.tableView.reloadData()
        
        tableView.action = #selector(onItemClicked)
    }
    
    @IBAction func onBack(_ sender: Any) {
        if let controller = self.storyboard?.instantiateController(withIdentifier: "main") as? ViewController {
            self.view.window?.contentViewController = controller
        }
    }
    
    @IBAction func onDeleteClicked(_ sender: Any) {
        let alert = NSAlert()
        
        alert.messageText = "모든 북마크 해제"
        alert.informativeText = "모든 북마크를 해제하시겠습니까?"
        alert.addButton(withTitle: "확인")
        alert.addButton(withTitle: "취소")
        
        alert.beginSheetModal(for: self.view.window!) { (response) in
            if response.rawValue == 1000 {
                self.bookmarkedNoticeManager.removeAll()
                self.notices = []
                self.tableView.reloadData()
            }
        }
    }
    
    @objc func onItemClicked() {
        NSWorkspace.shared.open(URL(string: notices[tableView.clickedRow].url)!)
    }
}

extension BookmarkViewController: NSTableViewDataSource, NSTableViewDelegate {
    func numberOfRows(in tableView: NSTableView) -> Int {
        return bookmarkedNoticeManager.getNotices().count
    }

    func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {
        let notice = notices[row]
        
        guard let cell = tableView.makeView(withIdentifier: tableColumn!.identifier, owner: self) as? NoticeTableCell else { return nil }
        
        cell.noticeType.stringValue = notice.type == 0 ? "공지" : "일반"
        cell.noticeType.textColor = notice.type == 0 ? NSColor(red: 0.8, green: 0.15, blue: 0, alpha: 1.0) : NSColor.textColor
        cell.noticeText.stringValue = notice.title
        cell.noticeText.textColor = .textColor
        
        return cell
    }
    
    func tableViewSelectionDidChange(_ notification: Notification) {
        tableView.deselectRow(tableView.selectedRow) // 클릭 후 포커스가 유지되는 현상 방지
    }
}
