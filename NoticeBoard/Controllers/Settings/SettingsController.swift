import Cocoa

class SettingsController: NSViewController {
    
    @IBOutlet weak var tableView: NSTableView! // 게시판 테이블
    
    var visitedNoticeManagers: [VisitedNoticeManager] = [] // 각 게시판의 방문 게시글 매니저가 담길 배열
    let bookmarkedNoticeManager = BookmarkedNoticeManager() // 북마크 매니저
    
    var boards: [Board] = Board.getCustomBoards() // 게시판 목록
    var selectedTableRow = -1 // 사용자가 선택한 게시판 행
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 게시판 리스트 데이터가 변경된 경우의 옵저버
        NotificationCenter.default.addObserver(self, selector: #selector(onCustomBoardDataChanged), name: Notification.Name(rawValue: "customBoardDataChanged"), object: nil)
        
        // 게시판 리스트 가져오기
        let entireBoards = Board.getBoards()
        for board in entireBoards {
            visitedNoticeManagers.append(VisitedNoticeManager(boardName: board.name))
        }
    }
    
    // 게시판 리스트 데이터가 변경되었을 때 실행
    @objc func onCustomBoardDataChanged(_ notification: NSNotification) {
        boards = Board.getCustomBoards()
        tableView.reloadData()
    }
    
    // 게시판 삭제
    @IBAction func onRemoveCustomBoard(_ sender: Any) {
        if selectedTableRow == -1 { return }
        
        guard let cell = tableView.view(atColumn: 0, row: selectedTableRow, makeIfNecessary: true) as? BoardTableCell else { return }
        
        if let boardId = cell.boardId {
            NSAlert.showQuestionAlert(window: self.view.window!, message: "게시판 삭제", text: cell.boardName.stringValue + " 게시판을 삭제하시겠습니까?") {
                Board.removeCustomBoard(boardId: boardId)
                NotificationCenter.default.post(name: Notification.Name("customBoardDataChanged"), object: nil)
                NSAlert.showAlert(window: self.view.window!, message: cell.boardName.stringValue + " 게시판을 삭제하였습니다.")
            }
        }
    }
    
    // 모든 방문 게시글 삭제
    @IBAction func onDeleteVisitedNoticesClicked(_ sender: NSButton) {
        NSAlert.showQuestionAlert(window: self.view.window!, message: "모든 방문 게시글 삭제", text: "방문한 모든 게시글 데이터를 삭제하시겠습니까?") {
            for visitedNoticeManager in self.visitedNoticeManagers {
                visitedNoticeManager.removeAll()
            }
            NotificationCenter.default.post(name: Notification.Name("visitedNoticesDataChanged"), object: nil)
            NSAlert.showAlert(window: self.view.window!, message: "방문한 모든 게시글을 삭제하였습니다.")
        }
    }
    
    // 모든 북마크 게시글 삭제
    @IBAction func onDeleteBookmarkedNoticesClicked(_ sender: NSButton) {
        NSAlert.showQuestionAlert(window: self.view.window!, message: "모든 북마크 게시글 삭제", text: "모든 북마크 게시글 데이터를 삭제하시겠습니까?") {
            self.bookmarkedNoticeManager.removeAll()
            NotificationCenter.default.post(name: Notification.Name("bookmarkedNoticesDataChanged"), object: nil)
            NSAlert.showAlert(window: self.view.window!, message: "모든 북마크 게시글을 삭제하였습니다.")
        }
    }
}
