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
                    let noticeType = try element.select(".seq").text() // 게시글 종류 (공지 or 게시글 번호)
                    if (noticeType == "") { continue } // 게시글 종류 파악이 안될 경우 건너뜀
                    
                    let noticeTitle = try element.select(".subject > a")
                    
                    guard let noticeId = extractParamFromUrl(url: try noticeTitle.attr("href"), key: "article_no") else { continue }
                    
                    if(searchKeyword != "" && noticeType == "공지") { continue } // 검색하고 있을 때는 공지글을 제외
                    if(pageIndex != 0 && noticeType == "공지") { continue } // 게시판의 첫 페이지에서만 공지글을 가져옴
                    
                    // 신규 글인지 확인
                    var noticeTitleText = try noticeTitle.text() // 게시글 제목 텍스트가 저장될 변수
                    if (!(try noticeTitle.select(".new").isEmpty())) {
                        try noticeTitle.select(".new").remove()
                        noticeTitleText = "Ⓝ " + (try! noticeTitle.text()) // 제목 앞에 이모티콘 삽입
                    }
                    
                    let noticeDate = try element.select(".date").text().components(separatedBy: " ")[1]
                    
                    notices.append(Notice(id: noticeType == "공지" ? "-1" : noticeId,
                                          type: noticeType == "공지" ? 0 : 1,
                                          title: noticeTitleText,
                                          date: noticeDate,
                                          url: url + String(try noticeTitle.attr("href"))))
                }
                completion(notices)
            } catch {
                NSAlert.showAlert(window: window, message: "공지사항 글을 가져올 수 없습니다.")
            }
        }
    }
    
    /**
     올바른 게시판인지 확인하여 불린형으로 반환합니다.
     - Parameter url: 게시판 URL
     */
    static func checkBoardAvailablity(url: String, completion: @escaping(_ availablity: Bool, _ errorMessage: String) -> Void) {
        AF.request(url).responseString { (response) in
            guard let html = response.value else {
                completion(false, "잘못된 URL 주소입니다.")
                return
            }
            
            do {
                let document: Document = try SwiftSoup.parse(html)
                let elements: Elements = try document.select("tbody > tr") // 게시글 노드 배열
                guard let element = elements.first() else {
                    completion(false, "올바르지 않은 게시판입니다.")
                    return
                }
                _ = try element.select(".subject > a") // 게시판 내용 가져오기
                
                completion(true, "") // 올바른 게시판
            } catch {
                completion(false, "올바르지 않은 게시판입니다.") // 올바르지 않은 게시판
            }
        }
    }
    
    /**
     URL 내에서 파라미터 값을 추출합니다.
     - Parameter url: URL 주소
     - Parameter key: 값을 추출할 파라미터 이름
     */
    static func extractParamFromUrl(url: String, key: String) -> String? {
        for param in url.split(separator: "&") {
            if (param.starts(with: key)) {
                return String(param.split(separator: "=").last!)
            }
        }
        return nil
    }
}
