import Foundation

class VisitedNoticeManager {
    var visitedNotices: [Int] = []
    
    init() {
        if let visitedNotices = UserDefaults.standard.object(forKey: "visited_notices") as? [Int] {
            self.visitedNotices = visitedNotices
        }
    }
    
    func getNotices() -> [Int] {
        return visitedNotices
    }
    
    func addNotice(noticeId: Int) {
        if(noticeId == -1) { return } // 공지사항 글이라면 따로 저장하지 않음
        visitedNotices.append(noticeId)
        UserDefaults.standard.set(visitedNotices, forKey: "visited_notices")
    }
    
    func contains(noticeId: Int) -> Bool {
        return visitedNotices.contains(noticeId)
    }
    
    func removeAll() {
        visitedNotices.removeAll()
        UserDefaults.standard.set(visitedNotices, forKey: "visited_notices")
    }
}
