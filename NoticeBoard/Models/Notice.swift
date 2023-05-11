import Foundation

/**
 게시글 정보를 담을 모델
 - Variables
    - id : 게시글의 고유 ID
    - type : 게시글의 공지사항, 일반글 여부(0이면 공지사항, 1이면 일반)
    - title : 게시글의 제목
    - url : 게시글 URL
 */
struct Notice: Codable {
    var id: Int
    var type: Int
    var title: String
    var url: String
}
