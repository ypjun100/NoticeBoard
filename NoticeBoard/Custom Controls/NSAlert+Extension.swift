import Cocoa

extension NSAlert {
    // yes or no alert 표시
    static func showQuestionAlert(window: NSWindow, message: String, text: String, completion: @escaping () -> Void) {
        let alert = NSAlert()
        
        alert.messageText = message
        alert.informativeText = text
        alert.addButton(withTitle: "확인")
        alert.addButton(withTitle: "취소")
        
        alert.beginSheetModal(for: window) { (response) in
            if response.rawValue == 1000 { // 확인 버튼을 누를 시 실행
                completion()
            }
        }
    }
    
    // alert 표시
    static func showAlert(window: NSWindow, message: String, completion: (() -> Void)? = nil) {
        let alert = NSAlert()
        alert.messageText = message
        alert.beginSheetModal(for: window) { (response) in
            if completion != nil {
                completion!()
            }
        }
    }
}
