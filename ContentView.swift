import SwiftUI


struct ContentView: View {
    @State var num = -1
    @State var chipChoose = 0
    @State var wheelAngle = 0
    @State var isOn = false
    @State var enoughMoney = true
    @State var chips = [Chip]()
    @State var chipsTemp = [Chip]()
    @State var money = 100
    @State var payment = 0
    @State var RiseOrLose = 0
    @State var paymentTemp = 0
    @State var highScore = 100
    @State var color : Color = .white
    let chipPicName = [1, 5, 10, 25, 50, 100]
    let rouletteNum = [34,17,25,2,21,4,19,15,32,0,26,3,35,12,28,7,29,18,22,9,31,14,20,1,33,16,24,5,10,23,8,30,11,36,13,27,6]
    let moneyFormatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        return formatter
    }()
    
    func getNum(angle: Int) -> Int {
        return  rouletteNum[Int(Double(angle % 360) / (360.0 / 37.0))]
    }
    func checkSpinReaults(num: Int) {
        if payment != 0 { RiseOrLose = -1 }
        for chip in chips {
            if chip.num.contains(num) {
                RiseOrLose = 1
                money += chip.value*(36/chip.num.count)
                if money > highScore {highScore = money}
            }
        }
        chips = []
        payment = 0
    }
    
    var body: some View {
        VStack {
            HStack {
                if enoughMoney {
                    Text("Money: \(NSNumber(value: money), formatter: moneyFormatter)")
                        .font(.headline)
                }else{
                    Text("Money: \(NSNumber(value: money), formatter: moneyFormatter)")
                        .font(.headline)
                        .foregroundColor(color)
                        .onAppear {
                            withAnimation(Animation.easeInOut(duration: 0.5).repeatForever()) {
                                color = Color.red
                            }
                        }
                        .onDisappear {
                            withAnimation {
                                color = Color.black
                            }
                        }
                }
                Spacer()
                Text("Payment: \(NSNumber(value: payment), formatter: moneyFormatter)")
                    .font(.headline)
                Spacer()
                Text("High Score: \(NSNumber(value: highScore))")
                    .font(.headline)
            }
            .padding()
            .background(.blue)
            
            if UIScreen.main.bounds.width > UIScreen.main.bounds.height {
                HStack(spacing: 30) {
                    RouletteView(num: $num, money: $money, payment: $payment, wheelAngle: $wheelAngle, chipChoose: $chipChoose, RiseOrLose: $RiseOrLose, isOn: $isOn, chips: $chips)
                }
                HStack {
                    Spacer()
                    Text("RESTART")
                        .foregroundColor(.white)
                        .font(.headline)
                        .frame(width: 100, height: 100, alignment: .center)
                        .background(Color.gray)
                        .cornerRadius(10)
                        .overlay(RoundedRectangle(cornerRadius: 10).stroke(Color.red, lineWidth: 4))
                        .contentShape(Rectangle())
                        .onTapGesture {
                            num = -1
                            money = 100
                            payment = 0
                            RiseOrLose = 0
                            chips = []
                            isOn = false
                            enoughMoney = true
                        }
                    Spacer()
                    ForEach((0...5), id: \.self){ i in
                        Image("Chip\(chipPicName[i])")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 100, height: 100, alignment: .center)
                            .shadow(color: .black, radius: isOn && chipChoose == chipPicName[i] ? 10 : 0, x: 0.0, y: 0.0)
                            .onTapGesture {
                                if money < chipPicName[i] {
                                    enoughMoney = false
                                    DispatchQueue.main.asyncAfter(deadline: .now() + 2.5){
                                        enoughMoney = true
                                    }
                                }else{
                                    isOn.toggle()
                                    chipChoose = chipPicName[i]
                                }
                            }
                    }
                    Spacer()
                    HStack {
                        Text("REBET")
                            .foregroundColor(.white)
                            .font(.headline)
                            .frame(width: 100, height: 100, alignment: .center)
                            .background(Color.blue)
                            .cornerRadius(10)
                            .overlay(RoundedRectangle(cornerRadius: 10).stroke(Color.yellow, lineWidth: 4))
                            .contentShape(Rectangle())
                            .onTapGesture {
                                if money < paymentTemp - payment {
                                    enoughMoney = false
                                    DispatchQueue.main.asyncAfter(deadline: .now() + 2.5){
                                        enoughMoney = true
                                    }    
                                }else{
                                    money += payment - paymentTemp
                                    payment = paymentTemp
                                    chips = chipsTemp
                                }
                            }
                        Text("CLEAR\nBETS")
                            .foregroundColor(.white)
                            .font(.headline)
                            .frame(width: 100, height: 100, alignment: .center)
                            .background(Color.purple)
                            .cornerRadius(10)
                            .overlay(RoundedRectangle(cornerRadius: 10).stroke(Color.yellow, lineWidth: 4))
                            .contentShape(Rectangle())
                            .onTapGesture {
                                money += payment
                                payment = 0
                                chips = []
                            }
                        Text("SPIN")
                            .foregroundColor(.white)
                            .font(.headline)
                            .frame(width: 100, height: 100, alignment: .center)
                            .background(Color.green)
                            .cornerRadius(10)
                            .overlay(RoundedRectangle(cornerRadius: 10).stroke(Color.yellow, lineWidth: 4))
                            .contentShape(Rectangle())
                            .onTapGesture {
                                RiseOrLose = 0
                                wheelAngle += Int.random(in: 1080...1440)
                                paymentTemp = payment
                                chipsTemp = chips
                                DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) {
                                    num = getNum(angle: wheelAngle)
                                    checkSpinReaults(num: num)
                                }
                            }
                    }
                    Spacer()
                }
            }else{
                RouletteView(num: $num, money: $money, payment: $payment, wheelAngle: $wheelAngle, chipChoose: $chipChoose, RiseOrLose: $RiseOrLose, isOn: $isOn, chips: $chips)
                HStack {
                    ForEach((0...5), id: \.self){ i in
                        Image("Chip\(chipPicName[i])")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 100, height: 100, alignment: .center)
                            .shadow(color: .black, radius: isOn && chipChoose == chipPicName[i] ? 10 : 0, x: 0.0, y: 0.0)
                            .onTapGesture {
                                if money < chipPicName[i] {
                                    enoughMoney = false
                                    DispatchQueue.main.asyncAfter(deadline: .now() + 2.5){
                                        enoughMoney = true
                                    }
                                }else{
                                    isOn.toggle()
                                    chipChoose = chipPicName[i]
                                }
                            }
                    }
                }
                HStack {
                    Spacer()
                    Text("RESTART")
                        .foregroundColor(.white)
                        .font(.headline)
                        .frame(width: 100, height: 100, alignment: .center)
                        .background(Color.gray)
                        .cornerRadius(10)
                        .overlay(RoundedRectangle(cornerRadius: 10).stroke(Color.red, lineWidth: 4))
                        .contentShape(Rectangle())
                        .onTapGesture {
                            num = -1
                            money = 100
                            payment = 0
                            RiseOrLose = 0
                            chips = []
                            isOn = false
                            enoughMoney = true
                        }
                    Spacer()
                    Text("REBET")
                        .foregroundColor(.white)
                        .font(.headline)
                        .frame(width: 100, height: 100, alignment: .center)
                        .background(Color.blue)
                        .cornerRadius(10)
                        .overlay(RoundedRectangle(cornerRadius: 10).stroke(Color.yellow, lineWidth: 4))
                        .contentShape(Rectangle())
                        .onTapGesture {
                            if money < paymentTemp - payment {
                                enoughMoney = false
                                DispatchQueue.main.asyncAfter(deadline: .now() + 2.5){
                                    enoughMoney = true
                                }    
                            }else{
                                money += payment - paymentTemp
                                payment = paymentTemp
                                chips = chipsTemp
                            }
                        }
                    Text("CLEAR\nBETS")
                        .foregroundColor(.white)
                        .font(.headline)
                        .frame(width: 100, height: 100, alignment: .center)
                        .background(Color.purple)
                        .cornerRadius(10)
                        .overlay(RoundedRectangle(cornerRadius: 10).stroke(Color.yellow, lineWidth: 4))
                        .contentShape(Rectangle())
                        .onTapGesture {
                            money += payment
                            payment = 0
                            chips = []
                        }
                    Text("SPIN")
                        .foregroundColor(.white)
                        .font(.headline)
                        .frame(width: 100, height: 100, alignment: .center)
                        .background(Color.green)
                        .cornerRadius(10)
                        .overlay(RoundedRectangle(cornerRadius: 10).stroke(Color.yellow, lineWidth: 4))
                        .contentShape(Rectangle())
                        .onTapGesture {
                            RiseOrLose = 0
                            wheelAngle += Int.random(in: 1080...1440)
                            paymentTemp = payment
                            chipsTemp = chips
                            DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) {
                                num = getNum(angle: wheelAngle)
                                checkSpinReaults(num: num)
                            }
                        }
                    Spacer()
                }
            }
        }.background(.brown)
    }
}
