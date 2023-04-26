import Foundation

class VisitedNoticeManager {
    var visitedNotices: [Int] = []
    var boardName = ""
    
    init(boardName: String) {
        self.boardName = boardName
        if let visitedNotices = UserDefaults.standard.object(forKey: "visited_notices_" + self.boardName) as? [Int] {
            self.visitedNotices = visitedNotices
        }
    }
    
    func getNotices() -> [Int] {
        return visitedNotices
    }
    
    func addNotice(noticeId: Int) {
        if(noticeId == -1) { return } // 공지사항 글이라면 따로 저장하지 않음
        
        // 방문한 게시글이 1000개 이상이면 가장 오래된 데이터 하나 삭제
        if(visitedNotices.count >= 1000) {
            visitedNotices.removeFirst()
        }
        
        visitedNotices.append(noticeId)
        UserDefaults.standard.set(visitedNotices, forKey: "visited_notices_" + self.boardName)
    }
    
    func contains(noticeId: Int) -> Bool {
        return visitedNotices.contains(noticeId)
    }
    
    func removeAll() {
        visitedNotices.removeAll()
        UserDefaults.standard.set(visitedNotices, forKey: "visited_notices_" + self.boardName)
    }
}
