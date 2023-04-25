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
    
    @IBOutlet var boardSelectView: NSView!
    @IBOutlet var scrollView: NSScrollView!
    @IBOutlet var tableView: NSTableView!
    @IBOutlet var progressIndicator: NSProgressIndicator!
    
    let visitedNoticeManager = VisitedNoticeManager() // 게시글 방문여부 확인 매니저
    var pageIndex = 0 // 게시판 페이지 인덱스
    var notices: [Notice] = [] // 게시글
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Board Select View UI 수정
        boardSelectView.wantsLayer = true
        boardSelectView.layer?.cornerRadius = 5.0
        boardSelectView.layer?.backgroundColor = CGColor(gray: 1.0, alpha: 0.05)
        
        // 게시판 데이터 가져오기
        BoardParser.parse(url: "https://home.sch.ac.kr/sch/06/010100.jsp", pageIndex: pageIndex) { notices in
            self.notices = notices
            self.tableView.reloadData()
        }
        
        tableView.action = #selector(onItemClicked) // 테이블 요소 선택시 액션
        
        NotificationCenter.default.addObserver(self, selector: #selector(onScrollEnded), name: NSScrollView.didEndLiveScrollNotification, object: nil) // 아래로 스크롤 시 알림
        
        visitedNoticeManager.removeAll() // 테스트용
    }
    
    // 게시글 행 클릭시
    @objc func onItemClicked() {
        visitedNoticeManager.addNotice(noticeId: notices[tableView.clickedRow].id)
        NSWorkspace.shared.open(URL(string: "https://home.sch.ac.kr/sch/06/010100.jsp" + notices[tableView.clickedRow].url)!)
        tableView.reloadData(forRowIndexes: IndexSet(arrayLiteral: tableView.clickedRow), columnIndexes: IndexSet(integer: 0))
    }
    
    // 사용자 스크롤 종료시
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
        
        cell.noticeType.stringValue = notice.type == 0 ? "공지" : "일반"
        cell.noticeType.textColor = notice.type == 0 ? NSColor(red: 0.8, green: 0.15, blue: 0, alpha: 1.0) : NSColor.textColor
        cell.noticeText.stringValue = notice.title
        cell.noticeText.textColor = .textColor
        
        if(visitedNoticeManager.contains(noticeId: notice.id)) {
            cell.noticeType.textColor = .gray
            cell.noticeText.textColor = .gray
        }
        
        return cell
    }
    
    func tableViewSelectionDidChange(_ notification: Notification) {
        tableView.deselectRow(tableView.selectedRow) // 클릭 후 포커스가 유지되는 현상 방지
    }
}
