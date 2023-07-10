import Cocoa

extension BookmarkViewController: NSTableViewDataSource, NSTableViewDelegate {
    // NSTableViewDataSource::
    // 테이블의 행의 수
    func numberOfRows(in tableView: NSTableView) -> Int {
        // 북마크가 없는 경우 'Nothing To Show Cell'을 보여주기 위해 1을 반환
        if notices.count == 0 {
            isTableViewEmpty = true
            return 1
        }
        return notices.count
    }

    // NSTableViewDelegate::
    // 테이블의 각 행 데이터 정의
    func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {
        // 테이블이 비어있는 경우
        if isTableViewEmpty {
            guard let cell = tableView.makeView(withIdentifier: .init("NothingToShowCell"), owner: self) as? NSTableCellView else { return nil }
            isTableViewEmpty = false
            return cell
        }
        
        let notice = notices[row]
        
        guard let cell = tableView.makeView(withIdentifier: tableColumn!.identifier, owner: self) as? NoticeTableCell else { return nil }
        
        cell.noticeTitle.stringValue = notice.title
        cell.noticeTitle.textColor = .textColor
        
        return cell
    }
    
    // NSTableViewDelegate::
    // 테이블에서 선택한 행이 바뀔 시
    func tableViewSelectionDidChange(_ notification: Notification) {
        tableView.deselectRow(tableView.selectedRow) // 클릭 후 포커스가 유지되는 현상 방지
    }
}
