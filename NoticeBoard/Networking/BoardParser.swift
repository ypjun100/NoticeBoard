import Alamofire
import SwiftSoup

let NOTICES_PER_PAGE = 10

class BoardParser {
    static func parse(url: String, pageIndex: Int, callback: @escaping((_ notices: [Notice]) -> Void)) {
        AF.request(url + "?pager.offset=" + String(NOTICES_PER_PAGE * pageIndex)).responseString { (response) in
            guard let html = response.value else { return }

            do {
                let document: Document = try SwiftSoup.parse(html)
                let elements: Elements = try document.select("tbody > tr")
                
                var notices: [Notice] = []
                
                for element in elements {
                    let noticeId = try element.select(".seq").text()
                    
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
