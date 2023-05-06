//
//  SettingsController.swift
//  NoticeBoard
//
//  Created by 윤준영 on 2023/05/04.
//

import Cocoa

class SettingsController: NSViewController {
    
    var visitedNoticeManagers: [VisitedNoticeManager] = []
    let bookmarkedNoticeManager = BookmarkedNoticeManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 게시판 리스트 가져오기
        if let URL = Bundle.main.url(forResource: "BoardUrl", withExtension: "plist") {
            if let data = NSArray(contentsOf: URL) as? [NSArray] {
                for elem in data {
                    visitedNoticeManagers.append(VisitedNoticeManager(boardName: elem[0] as! String))
                }
            }
        }
    }
    
    @IBAction func onDeleteVisitedNoticesClicked(_ sender: NSButton) {
        showDecisionAlert(message: "모든 방문 게시글 삭제", text: "방문한 모든 게시글 데이터를 삭제하시겠습니까?") {
            for visitedNoticeManager in self.visitedNoticeManagers {
                visitedNoticeManager.removeAll()
            }
            NotificationCenter.default.post(name: Notification.Name("visitedNoticesChanged"), object: nil)
            self.showAlert(message: "방문한 모든 게시글을 삭제하였습니다.")
        }
    }
    
    @IBAction func onDeleteBookmarkedNoticesClicked(_ sender: NSButton) {
        showDecisionAlert(message: "모든 북마크 게시글 삭제", text: "모든 북마크 게시글 데이터를 삭제하시겠습니까?") {
            self.bookmarkedNoticeManager.removeAll()
            NotificationCenter.default.post(name: Notification.Name("bookmarkedNoticesChanged"), object: nil)
            self.showAlert(message: "모든 북마크 게시글을 삭제하였습니다.")
        }
        
    }
    
    func showDecisionAlert(message: String, text: String, completion: @escaping () -> Void) {
        let alert = NSAlert()
        
        alert.messageText = message
        alert.informativeText = text
        alert.addButton(withTitle: "확인")
        alert.addButton(withTitle: "취소")
        
        alert.beginSheetModal(for: self.view.window!) { (response) in
            if response.rawValue == 1000 {
                completion()
            }
        }
    }
    
    func showAlert(message: String) {
        let alert = NSAlert()
        alert.messageText = message
        alert.beginSheetModal(for: self.view.window!)
    }
}
