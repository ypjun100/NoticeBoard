import Cocoa

extension SettingsController: NSTableViewDataSource, NSTableViewDelegate {
    // NSTableViewDataSource::
    // 테이블의 행의 수
    func numberOfRows(in tableView: NSTableView) -> Int {
        return boards.count
    }

    // NSTableViewDelegate::
    // 테이블의 각 행 데이터 정의
    func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {
        let board = boards[row]
        
        guard let cell = tableView.makeView(withIdentifier: tableColumn!.identifier, owner: self) as? BoardTableCell else { return nil }
        
        cell.boardId = board.id
        cell.boardName.stringValue = board.name
        
        return cell
    }
    
    // NSTableViewDelegate::
    // 테이블에서 선택한 행이 바뀔 시
    func tableViewSelectionDidChange(_ notification: Notification) {
        selectedTableRow = tableView.selectedRow
    }
}
