import Cocoa

class BookmarkViewController: NSViewController {
    
    @IBOutlet var tableView: NSTableView! // 테이블 뷰
    @IBOutlet var noBookmarkedLabel: NSTextField! // 테이블 요소가 없을 경우 나타날 알림 텍스트뷰
    
    let bookmarkedNoticeManager = BookmarkedNoticeManager() // 북마크 매니저
    
    var notices: [Notice] = [] // 게시글이 저장될 배열
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 북마크 게시글 데이터가 변경될 시 실행
        NotificationCenter.default.addObserver(self, selector: #selector(onBookmarkedNoticesDataChanged), name: Notification.Name(rawValue: "bookmarkedNoticesDataChanged"), object: nil)
        
        tableView.action = #selector(onTableItemClicked)
        
        updateBookmark()
    }
    
    // 북마크 매니저에서 북마크 한 게시글 데이터를 가져옴
    func updateBookmark() {
        self.notices = self.bookmarkedNoticeManager.getNotices()
        self.tableView.reloadData()
        
        noBookmarkedLabel.isHidden = self.notices.count == 0 ? false : true
    }
    
    // 북마크 한 게시글 데이터가 변결될 때 실행
    @objc func onBookmarkedNoticesDataChanged(_ notification: NSNotification) {
        self.bookmarkedNoticeManager.updateData()
        self.tableView.reloadData()
    }
    
    // 테이블 행 클릭
    @objc func onTableItemClicked() {
        NSWorkspace.shared.open(URL(string: notices[tableView.clickedRow].url)!)
    }
    
    
    // 뒤로가기 버튼 클릭
    @IBAction func onBackButtonClicked(_ sender: Any) {
        if let controller = self.storyboard?.instantiateController(withIdentifier: "main") as? MainController {
            self.view.window?.contentViewController = controller
        }
    }
    
    // 모든 북마크 데이터 삭제 버튼 클릭
    @IBAction func onDeleteButtonClicked(_ sender: Any) {
        NSAlert.showQuestionAlert(window: self.view.window!, message: "모든 북마크 해제", text: "모든 북마크를 해제하시겠습니까?") {
            self.bookmarkedNoticeManager.removeAll()
            self.updateBookmark()
            NSAlert.showAlert(window: self.view.window!, message: "모든 북마크 게시글을 삭제하였습니다.")
        }
    }
    
    // 북마크 게시글 해제
    @IBAction func onNoticeUnBookmarked(_ sender: Any) {
        self.bookmarkedNoticeManager.remove(noticeId: notices[tableView.clickedRow].id)
        updateBookmark()
    }
}
