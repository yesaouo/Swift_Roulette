import SwiftUI

struct Chip: Hashable {
    let id = UUID()
    let num : [Int]
    let value : Int
    let x: CGFloat
    let y: CGFloat
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
        hasher.combine(num)
        hasher.combine(value)
        hasher.combine(x)
        hasher.combine(y)
    }
    
    static func == (lhs: Chip, rhs: Chip) -> Bool {
        return lhs.id == rhs.id && lhs.num == rhs.num && lhs.value == rhs.value && lhs.x == rhs.x && lhs.y == rhs.y
    }
}
