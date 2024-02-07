import Foundation

class Board: Codable {
    var id: Int
    var name: String
    var url: String
    
    // 초기 게시판 데이터
    private static let initialBoards: [Board] = [Board(name: "대학공지", url: "https://home.sch.ac.kr/sch/06/010100.jsp")]
    
    
    init(id: Int = 0, name: String, url: String) {
        self.id = id
        self.name = name
        self.url = url
    }
    
    // 전체 게시판 조회
    static func getBoards() -> [Board] {
        var boards: [Board] = initialBoards
        boards.append(contentsOf: getCustomBoards())
        return boards
    }
    
    // 사용자 게시판 조회
    // excludeIndex : 해당 인덱스를 제외하고 출력
    static func getCustomBoards(excludeIndex: Int = 0) -> [Board] {
        var userBoards: [Board] = [] // 사용자 추가 게시판
        let decoder = JSONDecoder() // json 객체를 변환하기 위한 디코더
        
        // Board 데이터가 있는 경우
        var index = 0
        if let encodedBoards = UserDefaults.standard.object(forKey: "custom_boards") as? [Data] {
            for encodedBoard in encodedBoards {
                index += 1
                if let board = try? decoder.decode(Board.self, from: encodedBoard) {
                    if excludeIndex != 0 && board.id == excludeIndex { continue }
                    userBoards.append(board)
                }
            }
        }
        
        return userBoards
    }
    
    // 사용자 게시판 추가
    static func addCustomBoard(board: Board) {
        var customBoards: [Board] = getCustomBoards() // 사용자 추가 게시판
        let encoder = JSONEncoder() // json 형식으로 변환하기 위한 인코더
        var encodedBoards: [Data] = []
        
        customBoards.append(board)
        for board in customBoards {
            if let encodedBoard = try? encoder.encode(board) {
                encodedBoards.append(encodedBoard)
            }
        }
        UserDefaults.standard.set(encodedBoards, forKey: "custom_boards")
    }
    
    // 사용자 게시판 삭제
    static func removeCustomBoard(boardId: Int) {
        let customBoards: [Board] = getCustomBoards(excludeIndex: boardId) // 사용자 추가 게시판
        let encoder = JSONEncoder() // json 형식으로 변환하기 위한 인코더
        var encodedBoards: [Data] = []
        
        for board in customBoards {
            if let encodedBoard = try? encoder.encode(board) {
                encodedBoards.append(encodedBoard)
            }
        }
        UserDefaults.standard.set(encodedBoards, forKey: "custom_boards")
    }
    
    static func clearBoardData() {
        UserDefaults.standard.set("", forKey: "custom_boards")
    }
}
