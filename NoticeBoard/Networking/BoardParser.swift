import Alamofire
import SwiftSoup

let NOTICES_PER_PAGE = 10

class BoardParser {
    static func parse(url: String, searchKeyword: String, pageIndex: Int, callback: @escaping((_ notices: [Notice]) -> Void)) {
        guard let encodedSearchKeyword = searchKeyword.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) else { return }
        
        AF.request(url +
                   "?search%3Asearch_key%3Asearch=article_title&search%3Asearch_val%3Asearch=" + encodedSearchKeyword + // 검색 키워드
                   "&pager.offset=" + String(NOTICES_PER_PAGE * pageIndex) // 게시판 인덱스
        ).responseString { (response) in
            guard let html = response.value else { return }
            
            do {
                let document: Document = try SwiftSoup.parse(html)
                let elements: Elements = try document.select("tbody > tr")
                
                var notices: [Notice] = []
                
                for element in elements {
                    let noticeId = try element.select(".seq").text()
                    
                    if (noticeId == "") { continue } // noticeId가 존재하지 않으면 건너뜀 (더 이상 게시글이 없는 경우도 해당)
                    if(searchKeyword != "" && noticeId == "공지") { continue } // 검색하고 있을 때는 공지글을 제외
                    if(pageIndex != 0 && noticeId == "공지") { continue } // 게시판의 첫 페이지에서만 공지글을 가져옴
                    
                    notices.append(Notice(id: noticeId == "공지" ? -1 : Int(noticeId)!,
                                          type: noticeId == "공지" ? 0 : 1,
                                          title: try element.select(".subject > a").text(),
                                          url: try element.select(".subject > a").attr("href")))
                }
                callback(notices)
            } catch {
                print(error)
            }
        }
    }
}
