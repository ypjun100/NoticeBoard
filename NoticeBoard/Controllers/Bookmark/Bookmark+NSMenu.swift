import Cocoa

extension BookmarkViewController: NSMenuDelegate {
    
    // NSMenuDelegate::
    // 게시글 우클릭 메뉴가 띄우기 전 실행
    func menuWillOpen(_ menu: NSMenu) {
        // 만약 보여줄 게시글이 없는 상태에서는 메뉴를 열지 않음
        if notices.count == 0 {
            menu.cancelTracking()
        }
    }
}
