import Cocoa
import Alamofire

class MainController: NSViewController {
    
    @IBOutlet var headerStackView: NSStackView! // 헤더뷰
    @IBOutlet var boardSelectionView: NSView! // 게시판 선택 뷰
    @IBOutlet var boardSelectionMenu: NSMenu! // 게시판 선택 메뉴
    @IBOutlet var scrollView: NSScrollView! // 게시글 리스트 스크롤 뷰
    @IBOutlet var tableView: NSTableView! // 게시글 리스트 테이블 뷰
    @IBOutlet var progressIndicator: NSProgressIndicator! // 프로그레스
    @IBOutlet var searchView: NSView! // 검색창 뷰
    @IBOutlet var searchField: NSSearchField! // 검색 텍스트필드
    
    var visitedNoticeManagers: [VisitedNoticeManager] = [] // 각 게시판에 대한 게시글 방문여부 확인 매니저
    let bookmarkedNoticeManager = BookmarkedNoticeManager() // 북마크 지정/해제를 위한 매니저
    
    var boardUrls: [String] = [] // BoardUrl.plist에서 가져온 url이 저장될 배열
    var notices: [Notice] = [] // 게시글
    var currentBoardSelectionIndex = 0 // 현재 게시판 인덱스가 저장될 변수
    var boardPageIndex = 0 // 게시판 페이지 인덱스
    var currentSearchKeyword = "" // 현재 검색 키워드
    var isTableViewEmpty = false // 테이블뷰가 비어있는지
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 게시판 리스트 데이터가 변경된 경우의 옵저버
        NotificationCenter.default.addObserver(self, selector: #selector(onCustomBoardDataChanged), name: Notification.Name(rawValue: "customBoardDataChanged"), object: nil)
        
        // 방문한 게시글 데이터가 변경된 경우의 옵저버
        NotificationCenter.default.addObserver(self, selector: #selector(onVisitedNoticesDataChanged), name: Notification.Name(rawValue: "visitedNoticesDataChanged"), object: nil)
        
        // Board Select View UI 수정
        boardSelectionView.wantsLayer = true
        boardSelectionView.layer?.cornerRadius = 5.0
        boardSelectionView.layer?.backgroundColor = NSColor.boardSelectBackground?.cgColor
        
        // 게시판 리스트 가져오기
        getBoardList()
        
        // 데이터 모델 업데이트로 인한 이전 버전의 데이터가 변환이 필요한지 확인한 뒤 필요하다면 데이터 변환 실행
        if let buildVersion = Bundle.main.infoDictionary?["CFBundleVersion"] as? String {
            let lastBuildVersion = UserDefaults.standard.integer(forKey: "last_build_version")
            if (lastBuildVersion == 0) {
                // 방문 데이터 초기화 진행 (이전 방문 데이터는 더이상 표시되지 않으므로)
                for visitedNoticeManager in visitedNoticeManagers {
                    visitedNoticeManager.removeAll()
                }
                bookmarkedNoticeManager.convertPreviousData()
                bookmarkedNoticeManager.updateData()
                UserDefaults.standard.set(Int(buildVersion)!, forKey: "last_build_version")
            }
        }
        
        // 테이블뷰 초기화
        initTableView()
    }
    
    override func viewDidAppear() {
        // 뷰가 생성되고 난 뒤 게시글을 가져옴
        updateBoardData()
    }
    
    // 게시판 리스트를 가져옴
    func getBoardList() {
        let boards: [Board] = Board.getBoards()
        boards.forEach { board in
            boardUrls.append(board.url)
            boardSelectionMenu.addItem(withTitle: board.name, action: nil, keyEquivalent: "")
            visitedNoticeManagers.append(VisitedNoticeManager(boardName: board.name))
        }
    }
    
    // 게시판 리스트 데이터가 변경되었을 때 실행
    @objc func onCustomBoardDataChanged(_ notification: NSNotification) {
        boardUrls.removeAll()
        boardSelectionMenu.removeAllItems()
        visitedNoticeManagers.removeAll()
        currentBoardSelectionIndex = 0
        clearBoardData()
        getBoardList()
        updateBoardData()
    }
    
    // 방문한 게시글 데이터가 변경되었을 때 실행
    @objc func onVisitedNoticesDataChanged(_ notification: NSNotification) {
        for visitedNoticeManager in visitedNoticeManagers {
            visitedNoticeManager.updateData()
        }
        self.tableView.reloadData()
    }
    
    // 게시판 데이터 가져오기
    func updateBoardData() {
        progressIndicator.startAnimation(self)
        BoardParser.parseBoardNotices(url: boardUrls[currentBoardSelectionIndex], searchKeyword: currentSearchKeyword, pageIndex: boardPageIndex, window: self.view.window!) { notices in
            self.notices.append(contentsOf: notices)
            
            // 게시판 전체를 채울 수 없는 게시글 수라면 두 번째 페이지도 같이 불러옴
            if (self.notices.count < 15) {
                self.boardPageIndex += 1
                BoardParser.parseBoardNotices(url: self.boardUrls[self.currentBoardSelectionIndex], searchKeyword: self.currentSearchKeyword, pageIndex: self.boardPageIndex, window: self.view.window!) { notices in
                    self.notices.append(contentsOf: notices)
                    self.tableView.reloadData()
                    self.progressIndicator.stopAnimation(self)
                }
            } else {
                self.tableView.reloadData()
                self.progressIndicator.stopAnimation(self)
            }
        }
    }
    
    // 전체 보드 데이터 삭제
    func clearBoardData() {
        self.boardPageIndex = 0
        self.notices = []
        self.tableView.reloadData()
    }
    
    
    // 게시판 메뉴 아이템 변경
    @IBAction func onBoardSelectionChagned(_ sender: NSPopUpButton) {
        currentBoardSelectionIndex = sender.indexOfSelectedItem
        clearBoardData()
        updateBoardData()
    }
    
    // 검색 버튼 클릭
    @IBAction func onSearchButtonClicked(_ sender: Any) {
        headerStackView.isHidden = true
        searchView.isHidden = false
        searchField.stringValue = ""
    }
    
    // 검색 뷰 닫기
    @IBAction func onCloseSearchButtonClicked(_ sender: Any) {
        // 검색 키워드가 있는 경우 키워드 삭제 및 테이블 요소 데이터 초기화
        if (currentSearchKeyword != "") {
            currentSearchKeyword = ""
            clearBoardData()
            updateBoardData()
        }
        headerStackView.isHidden = false
        searchView.isHidden = true
    }
    
    // 북마크 아이콘 클릭
    @IBAction func onBookmarkButtonClicked(_ sender: Any) {
        // 화면 이동
        if let controller = self.storyboard?.instantiateController(withIdentifier: "bookmarkview") as? BookmarkViewController {
            self.view.window?.contentViewController = controller
        }
    }
    
    // 특정 게시글 북마킹
    @IBAction func onNoticeBookmarked(_ sender: NSMenuItem) {
        if (notices[tableView.clickedRow].id == "-1") {
            NSAlert.showAlert(window: self.view.window!, message: "공지사항은 북마크할 수 없습니다.")
            return
        }
        if (sender.title == "북마크 지정") {
            bookmarkedNoticeManager.addNotice(notice: notices[tableView.clickedRow])
        } else {
            bookmarkedNoticeManager.remove(noticeId: notices[tableView.clickedRow].id)
        }
    }
}
