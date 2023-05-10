import Cocoa

extension MainController: NSMenuDelegate {
    // NSMenuDelegate::
    // 게시글 우클릭 메뉴가 띄우기 전 실행
    func menuWillOpen(_ menu: NSMenu) {
        // 만약 북마크에 이미 포함된 게시글이라면 '북마크 해제'를 표시하고, 그렇지 않다면 '북마크 지정'을 표시
        if (bookmarkedNoticeManager.contains(noticeId: notices[tableView.clickedRow].id)) {
            menu.item(at: 0)?.title = "북마크 해제"
        } else {
            menu.item(at: 0)?.title = "북마크 지정"
        }
    }
}
