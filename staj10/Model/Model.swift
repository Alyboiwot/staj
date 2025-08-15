
import Foundation

struct MatchResult: Codable {
    let name: String
    let matches: [Match]
}

struct Match: Codable {
    let round: String
    let date: String
    let time: String
    let team1: String
    let team2: String
    let score: Score?   // boş gelebilir, opsiyonel
}

struct Score: Codable {
    let team1Goals: Int?
    let team2Goals: Int?
}
