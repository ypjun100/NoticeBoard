import Cocoa

extension MainController: NSTableViewDataSource, NSTableViewDelegate {
    // 테이블뷰 초기화
    func initTableView() {
        tableView.action = #selector(onTableItemClicked) // 테이블 요소 선택시 액션
        
        // 사용자가 맨 아래로 스크롤 하는 경우의 옵저버
        NotificationCenter.default.addObserver(self, selector: #selector(onScrollDidEnd), name: NSScrollView.didEndLiveScrollNotification, object: nil)
    }
    
    // NSTableViewDataSource::
    // 테이블의 행의 수
    func numberOfRows(in tableView: NSTableView) -> Int {
        return (notices.count)
    }

    // NSTableViewDelegate::
    // 테이블의 각 행 데이터 정의
    func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {
        let notice = notices[row]
        
        guard let cell = tableView.makeView(withIdentifier: tableColumn!.identifier, owner: self) as? NoticeTableCell else { return nil }
        
        cell.noticeType.stringValue = notice.type == 0 ? "공지" : "일반"
        cell.noticeType.textColor = notice.type == 0 ? NSColor(red: 0.8, green: 0.15, blue: 0, alpha: 1.0) : NSColor.textColor
        cell.noticeText.stringValue = notice.title
        cell.noticeText.textColor = .textColor
        
        // 만약 방문한 게시글 매니저에서 현재 게시판 ID가 포함되어 있는지 확인
        if(visitedNoticeManagers[currentBoardSelectionIndex].contains(noticeId: notice.id)) {
            cell.noticeType.textColor = .gray
            cell.noticeText.textColor = .gray
        }
        
        return cell
    }
    
    // NSTableViewDelegate::
    // 테이블에서 선택한 행이 바뀔 시
    func tableViewSelectionDidChange(_ notification: Notification) {
        tableView.deselectRow(tableView.selectedRow) // 클릭 후 포커스가 유지되는 현상 방지
    }
    
    // 게시글 행 클릭 시
    @objc func onTableItemClicked() {
        visitedNoticeManagers[currentBoardSelectionIndex].addNotice(noticeId: notices[tableView.clickedRow].id)
        NSWorkspace.shared.open(URL(string: notices[tableView.clickedRow].url)!) // url로 브라우저 오픈
        tableView.reloadData(forRowIndexes: IndexSet(arrayLiteral: tableView.clickedRow), columnIndexes: IndexSet(integer: 0))
    }
    
    // 사용자 스크롤 종료 시
    @objc func onScrollDidEnd() {
        // 만약 현재 스크롤 위치가 스크롤 뷰의 맨 하단인 경우 새로운 게시글 페이지에서 게시글들을 불러옴
        if(scrollView.contentView.bounds.origin.y + scrollView.contentView.bounds.height == scrollView.documentView?.bounds.height) {
            boardPageIndex += 1
            updateBoardData()
        }
    }
}
