import Foundation

class BookmarkedNoticeManager {
    let encoder = JSONEncoder() // json 형식으로 변환하기 위한 인코더
    let decoder = JSONDecoder() // json 객체를 Notice 객체로 변환하기 위한 디코더
    
    var bookmarkedNotices: [Notice] = [] // 북마크 한 게시글이 저장돌 배열
    
    init() {
        // 저장된 북마크 게시글을 불러옴
        if let encodedBookmarkedNotices = UserDefaults.standard.object(forKey: "bookmarked_notices") as? [Data] {
            for encodedBookmarkedNotice in encodedBookmarkedNotices {
                if let bookmarkedNotice = try? decoder.decode(Notice.self, from: encodedBookmarkedNotice) {
                    self.bookmarkedNotices.append(bookmarkedNotice)
                }
            }
        }
    }
    
    // bookmarkedNotices 배열에 저장된 Notice 객체들과 인코더를 가지고 변환하여 데이터 저장
    func saveData() {
        var encodedBookmarkedNotices: [Data] = []
        for bookmarkedNotice in bookmarkedNotices {
            if let encodedBookmarkedNotice = try? encoder.encode(bookmarkedNotice) {
                encodedBookmarkedNotices.append(encodedBookmarkedNotice)
            }
        }
        UserDefaults.standard.set(encodedBookmarkedNotices, forKey: "bookmarked_notices")
    }
    
    // 북마크 한 게시글 데이터를 불러옴
    func getNotices() -> [Notice] {
        return bookmarkedNotices.reversed() // 최신 북마크 게시글을 가장 위에 표시하기 위해 reversed 진행
    }
    
    // 북마크한 게시글 추가
    func addNotice(notice: Notice) {
        // 방문한 게시글이 100개 이상이면 가장 오래된 데이터 하나 삭제
        if(bookmarkedNotices.count >= 100) {
            bookmarkedNotices.removeFirst()
        }
        
        bookmarkedNotices.append(notice)
        saveData()
    }
    
    // noticeId로 해당 게시글이 북마크되었는지 확인
    func contains(noticeId: String) -> Bool {
        for notice in bookmarkedNotices {
            if (notice.id == noticeId) {
                return true
            }
        }
        return false
    }
    
    // 북마크 게시글 데이터 업데이트
    func updateData() {
        bookmarkedNotices = []
        if let encodedBookmarkedNotices = UserDefaults.standard.object(forKey: "bookmarked_notices") as? [Data] {
            for encodedBookmarkedNotice in encodedBookmarkedNotices {
                if let bookmarkedNotice = try? decoder.decode(Notice.self, from: encodedBookmarkedNotice) {
                    self.bookmarkedNotices.append(bookmarkedNotice)
                }
            }
        }
    }
    
    // 특정 게시글 데이터 삭제
    func remove(noticeId: String) {
        for (i, notice) in bookmarkedNotices.enumerated() {
            if (notice.id == noticeId) {
                bookmarkedNotices.remove(at: i)
                saveData()
                return
            }
        }
    }
    
    // 모든 방문 게시글 데이터 삭제
    func removeAll() {
        bookmarkedNotices.removeAll()
        saveData()
    }
}
