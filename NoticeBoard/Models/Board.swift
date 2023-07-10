import Foundation

class Board: Codable {
    var name: String
    var url: String
    
    // 초기 게시판 데이터
    static var boards: [Board] = [Board(name: "대학공지", url: "https://home.sch.ac.kr/sch/06/010100.jsp"),
                                    Board(name: "SW중심대학공지", url: "https://home.sch.ac.kr/sw/07/010000.jsp")]
    
    init(name: String, url: String) {
        self.name = name
        self.url = url
    }
    
    // 게시판 추가
    static func addBoard(board: Board) {
        let encoder = JSONEncoder() // json 형식으로 변환하기 위한 인코더
        var encodedBoards: [Data] = []
        
        boards.append(board)
        for board in boards {
            if let encodedBoard = try? encoder.encode(board) {
                encodedBoards.append(encodedBoard)
            }
        }
        UserDefaults.standard.set(encodedBoards, forKey: "boards")
    }
    
    // 게시판 리스트 조회
    static func getBoards() -> [Board] {
        let decoder = JSONDecoder() // json 객체를 변환하기 위한 디코더
        
        // Board 데이터가 있는 경우
        if let encodedBoards = UserDefaults.standard.object(forKey: "boards") as? [Data] {
            for encodedBoard in encodedBoards {
                if let board = try? decoder.decode(Board.self, from: encodedBoard) {
                    boards.append(board)
                }
            }
        }
        
        return boards
    }
}
