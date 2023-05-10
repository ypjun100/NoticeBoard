import Cocoa

extension BookmarkViewController: NSTableViewDataSource, NSTableViewDelegate {
    // NSTableViewDataSource::
    // 테이블의 행의 수
    func numberOfRows(in tableView: NSTableView) -> Int {
        return bookmarkedNoticeManager.getNotices().count
    }

    // NSTableViewDelegate::
    // 테이블의 각 행 데이터 정의
    func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {
        let notice = notices[row]
        
        guard let cell = tableView.makeView(withIdentifier: tableColumn!.identifier, owner: self) as? NoticeTableCell else { return nil }
        
        cell.noticeText.stringValue = notice.title
        cell.noticeText.textColor = .textColor
        
        return cell
    }
    
    // NSTableViewDelegate::
    // 테이블에서 선택한 행이 바뀔 시
    func tableViewSelectionDidChange(_ notification: Notification) {
        tableView.deselectRow(tableView.selectedRow) // 클릭 후 포커스가 유지되는 현상 방지
    }
}
