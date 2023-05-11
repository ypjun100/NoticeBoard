import Cocoa

class SettingsController: NSViewController {
    
    var visitedNoticeManagers: [VisitedNoticeManager] = [] // 각 게시판의 방문 게시글 매니저가 담길 배열
    let bookmarkedNoticeManager = BookmarkedNoticeManager() // 북마크 매니저
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 게시판 리스트 가져오기
        if let URL = Bundle.main.url(forResource: "BoardUrl", withExtension: "plist") { // BoardUrl.plist를 가져옴
            if let data = NSArray(contentsOf: URL) as? [NSArray] { // 데이터 추출
                for elem in data {
                    visitedNoticeManagers.append(VisitedNoticeManager(boardName: elem[0] as! String))
                }
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
