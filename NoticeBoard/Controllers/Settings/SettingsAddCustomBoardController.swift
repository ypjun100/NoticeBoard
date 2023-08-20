import Cocoa

class SettingsAddCustomBoardController: NSViewController {
    
    @IBOutlet weak var boardNameField: NSTextField! // 추가 게시판 이름 입력창
    @IBOutlet weak var boardUrlField: NSTextField! // 추가 게시판 주소
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    // 게시판 추가
    @IBAction func onAddCustomBoard(_ sender: NSButton) {
        // 사용자 입력 확인
        if (boardNameField.stringValue.isEmpty) {
            NSAlert.showAlert(window: self.view.window!, message: "게시판 이름을 입력해주세요.")
            return
        }
        if (boardUrlField.stringValue.isEmpty) {
            NSAlert.showAlert(window: self.view.window!, message: "게시판 주소를 입력해주세요.")
            return
        }
        
        BoardParser.checkBoardAvailablity(url: boardUrlField.stringValue) { (availablity, errorMessage) in
            // 잘못된 URL인 경우
            if (!availablity) {
                NSAlert.showAlert(window: self.view.window!, message: errorMessage)
                self.boardNameField.stringValue = ""
                self.boardUrlField.stringValue = ""
                return
            }
            
            // 올바른 URL인 경우
            Board.addCustomBoard(board: Board(id: Board.getCustomBoards().count + 1, name: self.boardNameField.stringValue, url: self.boardUrlField.stringValue)) // 해당 게시판 추가
            NotificationCenter.default.post(name: Notification.Name("customBoardDataChanged"), object: nil)
            NSAlert.showAlert(window: self.view.window!, message: self.boardNameField.stringValue + " 게시판이 추가되었습니다.") { () in
                self.boardNameField.stringValue = ""
                self.boardUrlField.stringValue = ""
                self.dismiss(self)
            }
        }
    }
}
