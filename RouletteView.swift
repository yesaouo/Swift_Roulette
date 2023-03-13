import SwiftUI

struct RouletteView: View {
    let TwoToOne = [[3,6,9,12,15,18,21,24,27,30,33,36],
                    [2,5,8,11,14,17,20,23,26,29,32,35],
                    [1,4,7,10,13,16,19,22,25,28,31,34]]
    let StNdRd = [[ 1, 2, 3, 4, 5, 6, 7, 8, 9,10,11,12],
                  [13,14,15,16,17,18,19,20,21,22,23,24],
                  [25,26,27,28,29,30,31,32,33,34,35,36]]
    let ThirtySix = [[ 1, 2, 3, 4, 5, 6, 7, 8, 9,10,11,12,13,14,15,16,17,18],
                     [19,20,21,22,23,24,25,26,27,28,29,30,31,32,33,34,35,36]]
    let Even = [1,3,5,7,9,11,13,15,17,19,21,23,25,27,29,31,33,35]
    let Odd = [2,4,6,8,10,12,14,16,18,20,22,24,26,28,30,32,34,36]
    let redBlock = [1,3,5,7,9,12,14,16,18,19,21,23,25,27,30,32,34,36]
    let blackBlock = [2,4,6,8,10,11,13,15,17,20,22,24,26,28,29,31,33,35]
    
    @Binding var num : Int
    @Binding var money : Int
    @Binding var payment : Int
    @Binding var wheelAngle : Int
    @Binding var chipChoose : Int
    @Binding var RiseOrLose : Int
    @Binding var isOn : Bool
    @Binding var chips : [Chip]
    
    func putChip(num: [Int], x: Int, y: Int, xScope: Int, yScope: Int) {
        isOn.toggle()
        chips.append(Chip(num: num, value: chipChoose, x: CGFloat(x+Int.random(in: -xScope...xScope)), y: CGFloat(y+Int.random(in: -yScope...yScope))))
        payment += chipChoose
        money -= chipChoose
    }
    
    var body: some View {
        HStack {
            Image("Roulette")
                .resizable()
                .scaledToFit()
                .frame(minWidth: 100, maxWidth: .infinity, minHeight: 100, maxHeight: .infinity)
                .rotationEffect(.degrees(Double(wheelAngle-7)), anchor: .center)
                .animation(.easeInOut(duration: 2), value: wheelAngle)
            Triangle()
                .fill(.yellow)
                .frame(width: 25, height: 35, alignment: .center)
                .rotationEffect(.degrees(270.0), anchor: .center)
        }
        ZStack {
            VStack(spacing: 0) {
                HStack(spacing: 0) {
                    TextView(mode: 1, text: "0")
                        .background(num == 0 ? .yellow : .green)
                        .onTapGesture { if isOn { putChip(num: [0], x: -325, y: -50, xScope: 8, yScope: 48) } }
                    VStack(spacing: 0) {
                        ForEach((0...2), id: \.self){ i in
                            HStack(spacing: 0) {
                                ForEach((1...12), id: \.self){ j in
                                    TextView(mode: 2, text: "\(j*3-i)")
                                        .background(num == j*3-i ? .yellow : redBlock.contains(j*3-i) ? .red : .black)
                                        .onTapGesture { if isOn { putChip(num: [j*3-i], x: -325+j*50, y: -120+i*70, xScope: 8, yScope: 8) } }
                                }
                            }
                        }
                    }
                    VStack(spacing: 0) {
                        ForEach((0...2), id: \.self){ i in
                            TextView(mode: 3, text: "2to1")
                                .onTapGesture { if isOn { putChip(num: TwoToOne[i], x: 325, y: -120+i*70, xScope: 8, yScope: 8) } }
                        }
                    }
                }
                HStack(spacing: 0) {
                    ForEach((0...2), id: \.self){ i in
                        let s = ["st","nd","rd"]
                        TextView(mode: 4, text: "\(i+1)\(s[i]) 12")
                            .onTapGesture { if isOn { putChip(num: StNdRd[i], x: -200+i*200, y: 80, xScope: 60, yScope: 10) } }
                    }
                }
                HStack(spacing: 0) {
                    TextView(mode: 5, text: "1 - 18")
                        .onTapGesture { if isOn { putChip(num: ThirtySix[0], x: -250, y: 130, xScope: 30, yScope: 10) } }
                    TextView(mode: 5, text: "Even")
                        .onTapGesture { if isOn { putChip(num: Even, x: -150, y: 130, xScope: 30, yScope: 10) } }
                    TextView(mode: 5, text: "Red")
                        .background(.red)
                        .onTapGesture { if isOn { putChip(num: redBlock, x: -50, y: 130, xScope: 30, yScope: 10) } }
                    TextView(mode: 5, text: "Black")
                        .background(.black)
                        .onTapGesture { if isOn { putChip(num: blackBlock, x: 50, y: 130, xScope: 30, yScope: 10) } }
                    TextView(mode: 5, text: "Odd")
                        .onTapGesture { if isOn { putChip(num: Odd, x: 150, y: 130, xScope: 30, yScope: 10) } }
                    TextView(mode: 5, text: "19 - 36")
                        .onTapGesture { if isOn { putChip(num: ThirtySix[1], x: 250, y: 130, xScope: 30, yScope: 10) } }
                }
            }
            ZStack {
                ForEach(chips, id: \.self){ chip in
                    Image("Chip\(chip.value)")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 25, height: 25, alignment: .center)
                        .offset(x: chip.x, y: chip.y)
                }
                if isOn {
                    ForEach((-5...6), id: \.self){ i in
                        let x = i * 50 - 25
                        let num = 3 * (i + 5) + 1
                        CircleView(x: CGFloat(x), y: 55)
                            .onTapGesture { putChip(num: [num,num+1,num+2], x: x, y: 55, xScope: 8, yScope: 8) }
                        CircleView(x: CGFloat(x), y: -15)
                            .onTapGesture { putChip(num: [num,num+1], x: x, y: -15, xScope: 8, yScope: 8) }
                        CircleView(x: CGFloat(x), y: -85)
                            .onTapGesture { putChip(num: [num+1,num+2], x: x, y: -85, xScope: 8, yScope: 8) }
                    }
                    ForEach((-5...5), id: \.self){ i in
                        let x = i * 50
                        let num = 3 * (i + 5) + 1
                        CircleView(x: CGFloat(x), y: 20)
                            .onTapGesture { putChip(num: [num,num+3], x: x, y: 20, xScope: 8, yScope: 8) }
                        CircleView(x: CGFloat(x), y: -50)
                            .onTapGesture { putChip(num: [num+1,num+4], x: x, y: -50, xScope: 8, yScope: 8) }
                        CircleView(x: CGFloat(x), y: -120)
                            .onTapGesture { putChip(num: [num+2,num+5], x: x, y: -120, xScope: 8, yScope: 8) }
                        CircleView(x: CGFloat(x), y: 55)
                            .onTapGesture { putChip(num: [num,num+1,num+2,num+3,num+4,num+5], x: x, y: 55, xScope: 8, yScope: 8) }
                        CircleView(x: CGFloat(x), y: -15)
                            .onTapGesture { putChip(num: [num,num+1,num+3,num+4], x: x, y: -15, xScope: 8, yScope: 8) }
                        CircleView(x: CGFloat(x), y: -85)
                            .onTapGesture { putChip(num: [num,num+1,num+3,num+4], x: x, y: -85, xScope: 8, yScope: 8) }
                    }
                }
            }
            Image("Rise")
                .resizable()
                .frame(width: 100, height: 100)
                .offset(x: 280, y: -220)
                .opacity(RiseOrLose == 1 ? 1 : 0)
            Image("Lose")
                .resizable()
                .frame(width: 100, height: 100)
                .offset(x: 280, y: -220)
                .opacity(RiseOrLose == -1 ? 1 : 0)
        }            
    }
}
