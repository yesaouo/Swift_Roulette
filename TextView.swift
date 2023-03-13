import SwiftUI

struct TextView: View {
    @State var mode: Int
    @State var text: String
    var body: some View {
        if (mode == 1) || (mode == 2) || (mode == 3) {
            Text(text)
                .rotationEffect(.degrees(270), anchor: .center)
                .font(mode == 3 ? .body : .largeTitle)
                .frame(width: 50, height: mode == 1 ? 210 : 70, alignment: .center)
                .border(.white, width: 1)
                .foregroundColor(.white)
                .contentShape(Rectangle())
        }else if (mode == 4) || (mode == 5){
            Text(text)
                .font(mode == 4 ? .largeTitle : .title)
                .frame(width: mode == 4 ? 200 : 100, height: 50, alignment: .center)
                .border(.white, width: 1)
                .foregroundColor(.white)
                .contentShape(Rectangle())
        }
    }
}
