import Foundation

class VisitedNoticeManager {
    var visitedNotices: [String] = [] // 방문한 게시글이 저장될 배열
    var boardName = "" // 현재 게시판의 이름
    
    init(boardName: String) {
        self.boardName = boardName
        // 게시판의 이름을 가지고 저장된 방문 게시글 배열을 불러옴
        if let visitedNotices = UserDefaults.standard.object(forKey: "visited_notices_" + self.boardName) as? [String] {
            self.visitedNotices = visitedNotices
        }
    }
    
    // 방문 게시글 데이터를 불러옴
    func getNotices() -> [String] {
        return visitedNotices
    }
    
    // 방문한 게시글을 추가
    func addNotice(noticeId: String) {
        if(noticeId == "-1") { return } // 공지사항 글이라면 따로 저장하지 않음
        
        // 방문한 게시글이 1000개 이상이면 가장 오래된 데이터 하나 삭제
        if(visitedNotices.count >= 1000) {
            visitedNotices.removeFirst()
        }
        
        visitedNotices.append(noticeId)
        UserDefaults.standard.set(visitedNotices, forKey: "visited_notices_" + self.boardName)
    }
    
    // noticeId로 해당 게시글을 방문했는지 확인
    func contains(noticeId: String) -> Bool {
        return visitedNotices.contains(noticeId)
    }
    
    // 방문 게시글 데이터 업데이트
    func updateData() {
        if let visitedNotices = UserDefaults.standard.object(forKey: "visited_notices_" + self.boardName) as? [String] {
            self.visitedNotices = visitedNotices
        }
    }
    
    // 모든 방문 게시글 데이터 삭제
    func removeAll() {
        visitedNotices.removeAll()
        UserDefaults.standard.set(visitedNotices, forKey: "visited_notices_" + self.boardName)
    }
}
