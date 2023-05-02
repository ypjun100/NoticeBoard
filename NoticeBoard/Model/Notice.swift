import Foundation

struct Notice: Codable {
    var id: Int
    var type: Int // 0 - 공지사항, 1 - 일반
    var title: String
    var url: String
}
