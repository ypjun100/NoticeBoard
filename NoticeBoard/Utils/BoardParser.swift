import Cocoa
import Alamofire
import SwiftSoup

let NOTICES_PER_PAGE = 10 // 게시판의 게시글 개수

class BoardParser {
    /**
     공지사항의 게시글들에 대한 정보를 가져옵니다.
     - Parameter url: 게시판 URL
     - Parameter searchKeyword: 해당 게시판에서 검색할 키워드
     - Parameter pageIndex: 현재 게시판의 페이징 인덱스
     - Parameter window: 파싱을 진행할 뷰의 window (Alert를 표시할 때 필요)
     - Parameter completion: 파싱을 수행한 후 실행될 함수
     */
    static func parseBoardNotices(url: String, searchKeyword: String, pageIndex: Int, window: NSWindow, completion: @escaping((_ notices: [Notice]) -> Void)) {
        guard let encodedSearchKeyword = searchKeyword.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) else { return } // 검색 키워드를 url 인코딩
        
        AF.request(url +
                   "?search%3Asearch_key%3Asearch=article_title&search%3Asearch_val%3Asearch=" + encodedSearchKeyword + // 검색 키워드
                   "&pager.offset=" + String(NOTICES_PER_PAGE * pageIndex) // 게시판 인덱스
        ).responseString { (response) in
            guard let html = response.value else { return }
            
            do {
                let document: Document = try SwiftSoup.parse(html)
                let elements: Elements = try document.select("tbody > tr") // 게시글 노드 배열
                
                var notices: [Notice] = [] // 게시글 배열
                
                for element in elements {
                    let noticeId = try element.select(".seq").text()
                    
                    if (noticeId == "") { continue } // noticeId가 존재하지 않으면 건너뜀 (더 이상 게시글이 없는 경우도 해당)
                    if(searchKeyword != "" && noticeId == "공지") { continue } // 검색하고 있을 때는 공지글을 제외
                    if(pageIndex != 0 && noticeId == "공지") { continue } // 게시판의 첫 페이지에서만 공지글을 가져옴
                    
                    let title = try element.select(".subject > a")
                    try title.select("span").remove() // a 태그 내의 span 태그 삭제
                    
                    let date = try element.select(".date").text().components(separatedBy: " ")[1]
                    
                    notices.append(Notice(id: noticeId == "공지" ? -1 : Int(noticeId)!,
                                          type: noticeId == "공지" ? 0 : 1,
                                          title: try title.text(),
                                          date: date,
                                          url: url + String(try element.select(".subject > a").attr("href"))))
                }
                completion(notices)
            } catch {
                NSAlert.showAlert(window: window, message: "공지사항 글을 가져올 수 없습니다.")
            }
        }
    }
}
