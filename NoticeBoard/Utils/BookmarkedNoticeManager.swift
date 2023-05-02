import Foundation

class BookmarkedNoticeManager {
    
    let encoder = JSONEncoder()
    let decoder = JSONDecoder()
    
    var bookmarkedNotices: [Notice] = []
    
    init() {
        if let encodedBookmarkedNotices = UserDefaults.standard.object(forKey: "bookmarked_notices") as? [Data] {
            for encodedBookmarkedNotice in encodedBookmarkedNotices {
                if let bookmarkedNotice = try? decoder.decode(Notice.self, from: encodedBookmarkedNotice) {
                    self.bookmarkedNotices.append(bookmarkedNotice)
                }
            }
        }
    }
    
    func getNotices() -> [Notice] {
        return bookmarkedNotices
    }
    
    func saveData() {
        var encodedBookmarkedNotices: [Data] = []
        for bookmarkedNotice in bookmarkedNotices {
            if let encodedBookmarkedNotice = try? encoder.encode(bookmarkedNotice) {
                encodedBookmarkedNotices.append(encodedBookmarkedNotice)
            }
        }
        UserDefaults.standard.set(encodedBookmarkedNotices, forKey: "bookmarked_notices")
    }
    
    func addNotice(notice: Notice) {
        // 방문한 게시글이 100개 이상이면 가장 오래된 데이터 하나 삭제
        if(bookmarkedNotices.count >= 100) {
            bookmarkedNotices.removeFirst()
        }
        
        bookmarkedNotices.append(notice)
        saveData()
    }
    
    func contains(noticeId: Int) -> Bool {
        for notice in bookmarkedNotices {
            if (notice.id == noticeId) {
                return true
            }
        }
        return false
    }
    
    func remove(noticeId: Int) {
        for (i, notice) in bookmarkedNotices.enumerated() {
            if (notice.id == noticeId) {
                bookmarkedNotices.remove(at: i)
                saveData()
                return
            }
        }
    }
    
    func removeAll() {
        bookmarkedNotices.removeAll()
        saveData()
    }
}
