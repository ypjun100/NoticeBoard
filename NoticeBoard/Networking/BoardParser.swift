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
                    var noticeType = 0
                    if try element.select(".seq").text() == "공지" {
                        if(pageIndex != 0) { continue }
                        noticeType = 1
                    }
                    
                    notices.append(Notice(noticeType: noticeType,
                                          noticeName: try element.select(".subject > a").text(),
                                              noticeURL: try element.select(".subject > a").attr("href"),
                                              noticeStatus: false))
                }
                callback(notices)
            } catch {
                print("crawl error")
            }
        }
    }
}
