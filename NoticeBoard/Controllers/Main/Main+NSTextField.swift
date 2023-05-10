import Cocoa

extension MainController: NSControlTextEditingDelegate {
    // NSControlTextEditingDelegate::
    // 텍스트뷰에서 사용자의 키보드 입력 감지
    // 만약 현재 Delegate에서 키를 처리하면 true, 그렇지 않으면 false
    func control(_ control: NSControl, textView: NSTextView, doCommandBy commandSelector: Selector) -> Bool {
        if (commandSelector == #selector(NSResponder.insertNewline(_:))) { // 엔터키 감지
            if (searchField.stringValue != "") { // 텍스트 필드에 무언가 입력되었을 때만 실행
                currentSearchKeyword = searchField.stringValue
                clearBoardData()
                updateBoardData()
            }
            return true
        }
        return false
    }
}
