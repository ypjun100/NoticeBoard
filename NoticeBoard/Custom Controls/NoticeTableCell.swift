import Cocoa

class NoticeTableCell: NSTableCellView {
    @IBOutlet var noticeType: NSTextField! // 게시글이 일반글인지 공지사항 글인지 분류하는 텍스트
    @IBOutlet var noticeTitle: NSTextField! // 게시글 제목
    
    override func draw(_ dirtyRect: NSRect) {
        super.draw(dirtyRect)

        // Drawing code here.
    }
    
}
