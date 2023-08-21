import Cocoa

class BoardTableCell: NSTableCellView {
    @IBOutlet var boardName: NSTextField! // 게시판 이름
    
    public var boardId: Int! // 게시판 ID
    
    override func draw(_ dirtyRect: NSRect) {
        super.draw(dirtyRect)

        // Drawing code here.
    }
    
}
