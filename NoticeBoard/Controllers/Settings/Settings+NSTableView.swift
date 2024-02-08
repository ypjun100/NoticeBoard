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
    // 테이블의 각 행이 선택될 때 가져올 각 행의 ID
    func tableView(_ tableView: NSTableView, pasteboardWriterForRow row: Int) -> NSPasteboardWriting? {
        return String(boards[row].id) as NSString
    }
    
    // NSTableViewDelegate::
    // 테이블의 각 행을 움직일 때마다 실행됨
    func tableView(_ tableView: NSTableView, validateDrop info: NSDraggingInfo, proposedRow row: Int, proposedDropOperation dropOperation: NSTableView.DropOperation) -> NSDragOperation {
        
        // 만약 드래그하고 있는 요소가 다른 요소 위에 올려져 있는 상태라면 무시함
        guard dropOperation == .above, let tableView = info.draggingSource as? NSTableView else {
            return []
        }
        
        tableView.draggingDestinationFeedbackStyle = .gap
        return .move
    }
    
    // NSTableViewDelegate::
    // 사용자가 드래그하고 있던 행을 놓은경우
    func tableView(_ tableView: NSTableView, acceptDrop info: NSDraggingInfo, row: Int, dropOperation: NSTableView.DropOperation) -> Bool {
        guard let items = info.draggingPasteboard.pasteboardItems,
              let pasteBoardItem = items.first,
              let pasteBoardItemName = pasteBoardItem.string(forType: .string),
              let index = findBoardIndex(id: pasteBoardItemName) else { return false }
        
        Board.reorderCustomBoard(from: index, to: row) // 배열 순서 변경
        
        // 테이블뷰 업데이트
        tableView.beginUpdates()
        tableView.moveRow(at: index, to: (index < row ? row - 1 : row))
        tableView.endUpdates()
        
        // 메인화면 뷰 업데이트
        NotificationCenter.default.post(name: Notification.Name("customBoardDataChanged"), object: nil)
        
        return true
    }
    
    // ID값으로 boards 배열 내의 원소에 대한 인덱스를 반환
    func findBoardIndex(id: String) -> Int? {
        for (i, board) in boards.enumerated() {
            if String(board.id) == id {
                return i
            }
        }
        return nil
    }
    
    // NSTableViewDelegate::
    // 테이블에서 선택한 행이 바뀔 시
    func tableViewSelectionDidChange(_ notification: Notification) {
        selectedTableRow = tableView.selectedRow
    }
}
