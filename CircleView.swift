import SwiftUI

struct CircleView: View {
    @State var x: CGFloat
    @State var y: CGFloat
    var body: some View {
        Circle()
            .foregroundColor(.yellow)
            .frame(width: 25, height: 25)
            .offset(x: x, y: y)
    }
}
