//
//  ContentView.swift
//  Calculator
//
//  Created by Md Imam Hossain on 3/27/26.
//

import SwiftUI


enum CalcButton: String {
    case one = "1"
    case two = "2"
    case three = "3"
    case four = "4"
    case five = "5"
    case six = "6"
    case seven = "7"
    case eight = "8"
    case nine = "9"
    case zero = "0"
    case add = "+"
    case subtract = "−"
    case multiply = "×"
    case equal = "="
    case divide = "÷"
    case clear = "C"
    case bracket = "()"
    case percent = "%"
    case negative = "±"
    case decimal = "."
    
    var buttonColor: Color {
        switch self {
            case .zero, .one, .two, .three, .four, .five, .six, .seven, .eight, .nine, .decimal, .negative:
                return Color("NumericButtonColor")
            case .add, .subtract, .multiply, .divide:
                return Color("OperatorButtonColor")
            case .clear, .bracket, .percent:
                return Color("FunctionButtonColor")
            case .equal:
                return Color("EqualButtonColor")
        }
    }
    
    var textColor: Color {
        switch self {
            case .zero, .one, .two, .three, .four, .five, .six, .seven, .eight, .nine, .decimal, .negative:
                return Color("NumericButtonTextColor")
            case .add, .subtract, .multiply, .divide:
                return Color("OperatorButtonTextColor")
            case .clear, .bracket, .percent:
                return Color("FunctionButtonTextColor")
            case .equal:
                return Color("EqualButtonTextColor")
        }
    }
}



struct ContentView: View {
    
    @State var expression = "0"
    @State var result = "0"
    
    
    let buttons: [[CalcButton]] = [
        [.clear, .bracket, .percent, .divide],
        [.seven, .eight, .nine, .multiply],
        [.four, .five, .six, .subtract],
        [.one, .two, .three, .add],
        [.negative, .zero, .decimal,.equal]
    ]
    
    var body: some View {
        ZStack {
            Color("BackgroundColor")
                .edgesIgnoringSafeArea(.all)
            
            
            VStack {
                // Calculation Result to Show
                HStack {
                    Spacer()
                    Text(expression)
                        .font(.system(size: 48, weight: .regular, design: .default))
                        .foregroundColor(Color("CalculationResultTextColor"))
                }.padding(20)
                Spacer()
                HStack {
                    Spacer()
                    Text(result)
                        .font(.system(size: 36, weight: .regular, design: .default))
                        .foregroundColor(Color("CalculationResultTextColor"))
                }.padding(20)
                
  
                HStack {
                    
                    Button(action: {
                        
                    }) {
                        Image("HistoryIcon")
                            .renderingMode(.template)
                            .resizable()
                            .scaledToFit()
                            .foregroundColor(.gray)
                            .frame(width: 18, height: 18)
                    }
                    
                    Button(action: {
                        
                    }) {
                        Image("RulerIcon")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 24, height: 24)
                    }.padding(.horizontal, 10)
                    
                    Button(action: {
                        
                    }) {
                        Image("FxIcon")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 20, height: 20)
                    }
                    
                    Spacer()
                    
                    Button(action: {
                        
                    }) {
                        Image("ClearIcon")
                            .renderingMode(.template)
                            .resizable()
                            .scaledToFit()
                            .foregroundColor(Color("EqualButtonColor"))
                            .frame(width: 36, height: 36)
                    }
                    
                    
                    
                }.padding(.trailing, 15).padding(.leading, 20)
                
                Divider().padding(20)
                
                // Buttons
                ForEach(buttons, id: \.self) { row in
                    HStack {
                        ForEach(row, id: \.self) { button in
                            Button(action: {
                                self.buttonTapAction(button: button)
                            }) {
                                Text(button.rawValue)
                                    .font(.system(size: 30, weight: .regular, design: .default))
                                    .foregroundColor(button.textColor)
                                    .frame(width: self.buttonWidth(button: button), height: self.buttonHeight(button: button))
                                    .background(button.buttonColor)
                                    .cornerRadius(self.buttonRadius(button: button))
                            }
                        }
                    }
                }
            }
        }
    }
    
    func buttonWidth(button: CalcButton) -> CGFloat {
        return (UIScreen.main.bounds.width - (5*12)) / 4
    }
    
    func buttonHeight(button: CalcButton) -> CGFloat {
        return (UIScreen.main.bounds.width - (5*12)) / 4
    }
    
    func buttonRadius(button: CalcButton) -> CGFloat {
        return ((UIScreen.main.bounds.width - (5*12)) / 4)/2
    }
    
    func buttonTapAction(button: CalcButton) {
        if(button == .clear) {
            self.expression = "0"
            return
        }
        
        if(button == .equal) {
            self.result = calculate()
            return
        }
        
        let value = button.rawValue
        
        if(self.expression == "0") {
            expression = value
        } else {
            self.expression = "\(self.expression)\(value)"
        }
    }
    
    
    func calculate() -> String {
        let parts = self.expression.split(separator: "+")
        
        guard parts.count == 2,
              let first = Int(parts[0]),
              let second = Int(parts[1]) else {
            return "Error"
        }
        
        return String(first + second)
    }
    
}

#Preview {
    ContentView()
        .preferredColorScheme(.light)
}
