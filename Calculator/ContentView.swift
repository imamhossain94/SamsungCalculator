//
//  ContentView.swift
//  Calculator
//
//  Created by Md Imam Hossain on 3/27/26.
//

import SwiftUI
import JavaScriptCore


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
    
    @State var expression = ""
    @State var result = "0"
    @State private var isFinalResult = false
    @State private var showingNotImplemented = false
    @State private var featureName = ""
    
    let buttons: [[CalcButton]] = [
        [.clear, .bracket, .percent, .divide],
        [.seven, .eight, .nine, .multiply],
        [.four, .five, .six, .subtract],
        [.one, .two, .three, .add],
        [.negative, .zero, .decimal, .equal]
    ]
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                Color("BackgroundColor")
                    .edgesIgnoringSafeArea(.all)
                
                VStack(spacing: 0) {
                    // Calculation Area
                    VStack(alignment: .trailing, spacing: 8) {
                        Spacer(minLength: 50)
                        
                        // Expression
                        Text(expression.isEmpty ? " " : expression)
                            .font(.system(size: 28, weight: .regular))
                            .foregroundColor(Color("CalculationResultTextColor").opacity(0.7))
                            .lineLimit(2)
                            .multilineTextAlignment(.trailing)
                            .padding(.horizontal, 24)
                            .frame(maxWidth: .infinity, alignment: .trailing)
                        
                        Spacer()
                        
                        // Main Result
                        Text(result)
                            .font(.system(size: 60, weight: .medium))
                            .foregroundColor(Color("CalculationResultTextColor"))
                            .lineLimit(1)
                            .minimumScaleFactor(0.5)
                            .padding(.horizontal, 24)
                            .frame(maxWidth: .infinity, alignment: .trailing)
                    }
                    .frame(maxWidth: .infinity)
                    .frame(height: geometry.size.height * 0.35)
                    
                    // Toolbar Row
                    HStack {
                        Button(action: {
                            self.featureName = "History"
                            self.showingNotImplemented = true
                        }) {
                            Image("HistoryIcon")
                                .renderingMode(.template)
                                .resizable()
                                .scaledToFit()
                                .foregroundColor(Color("CalculationResultTextColor").opacity(0.6))
                                .frame(width: 20, height: 20)
                        }
                        
                        Button(action: {
                            self.featureName = "Unit Converter"
                            self.showingNotImplemented = true
                        }) {
                            Image("RulerIcon")
                                .renderingMode(.template)
                                .resizable()
                                .scaledToFit()
                                .foregroundColor(Color("CalculationResultTextColor").opacity(0.6))
                                .frame(width: 24, height: 24)
                        }
                        .padding(.horizontal, 20)
                        
                        Button(action: {
                            self.featureName = "Scientific Functions"
                            self.showingNotImplemented = true
                        }) {
                            Image("FxIcon")
                                .renderingMode(.template)
                                .resizable()
                                .scaledToFit()
                                .foregroundColor(Color("CalculationResultTextColor").opacity(0.6))
                                .frame(width: 22, height: 22)
                        }
                        
                        Spacer()
                        
                        Button(action: {
                            self.backspace()
                        }) {
                            Image("ClearIcon")
                                .renderingMode(.template)
                                .resizable()
                                .scaledToFit()
                                .foregroundColor(Color("EqualButtonColor"))
                                .frame(width: 38, height: 38)
                        }
                    }
                    .padding(.horizontal, 24)
                    .padding(.bottom, 12)
                    
                    Divider()
                        .background(Color.gray.opacity(0.2))
                        .padding(.horizontal, 20)
                        .padding(.bottom, 20)
                    
                    // Keypad
                    VStack(spacing: 12) {
                        ForEach(buttons, id: \.self) { row in
                            HStack(spacing: 12) {
                                ForEach(row, id: \.self) { button in
                                    Button(action: {
                                        self.buttonTapAction(button: button)
                                    }) {
                                        Text(button.rawValue)
                                            .font(.system(size: button == .equal ? 36 : 28, weight: .medium))
                                            .foregroundColor(button.textColor)
                                            .frame(width: self.buttonWidth(button: button, totalWidth: geometry.size.width), height: self.buttonHeight(button: button, totalWidth: geometry.size.width))
                                            .background(button.buttonColor)
                                            .clipShape(Circle())
                                    }
                                }
                            }
                        }
                    }
                    .padding(.bottom, 30)
                }
            }
            .alert("Feature Not Available", isPresented: $showingNotImplemented) {
                Button("OK", role: .cancel) { }
            } message: {
                Text("\(featureName) is not implemented yet. Stay tuned for future updates!")
            }
        }
    }
    
    private func buttonWidth(button: CalcButton, totalWidth: CGFloat) -> CGFloat {
        let spacing: CGFloat = 12
        let totalHorizontalPadding: CGFloat = 24 * 2
        let availableWidth = totalWidth - totalHorizontalPadding - (3 * spacing)
        return availableWidth / 4
    }
    
    private func buttonHeight(button: CalcButton, totalWidth: CGFloat) -> CGFloat {
        return self.buttonWidth(button: button, totalWidth: totalWidth)
    }
    
    func buttonTapAction(button: CalcButton) {
        if isFinalResult && button != .equal {
            if button.isOperator {
                // Continue with last result
                expression = result
            } else {
                // Start fresh
                expression = ""
                result = "0"
            }
            isFinalResult = false
        }
        
        switch button {
        case .clear:
            expression = ""
            result = "0"
        case .equal:
            if !expression.isEmpty {
                let calcResult = calculate(expression: expression)
                result = calcResult
                isFinalResult = true
            }
        case .negative:
            if expression.hasPrefix("-") {
                expression.removeFirst()
            } else {
                expression = "-" + expression
            }
            calculateRealTime()
        case .bracket:
            let openCount = expression.filter { $0 == "(" }.count
            let closeCount = expression.filter { $0 == ")" }.count
            
            if let last = expression.last {
                if "+−×÷(".contains(last) {
                    expression += "("
                } else if openCount > closeCount {
                    // Check if the character before the bracket is an operator or (
                    // We shouldn't add ) right after ( e.g. "()" is allowed but usually handled by user input
                    expression += ")"
                } else {
                    // Number or ), add implicit multiplication
                    expression += "×("
                }
            } else {
                expression += "("
            }
            calculateRealTime()
        default:
            expression += button.rawValue
            calculateRealTime()
        }
    }
    
    func backspace() {
        if !expression.isEmpty {
            expression.removeLast()
            calculateRealTime()
        }
    }
    
    private func calculateRealTime() {
        if expression.isEmpty {
            result = "0"
            return
        }
        
        // If it's just a number, no need to show it as a result yet in real-time
        if Double(expression) != nil {
            // Samsung usually doesn't show the result if it's just one number
            // but for this implementation we can keep it as is or hide it.
            // Let's hide the result if it's just a single number to match Samsung.
            result = "0"
            return
        }
        
        let calcResult = calculate(expression: expression)
        if calcResult != "Error" {
            result = calcResult
        }
    }
    
    func calculate(expression: String) -> String {
        guard !expression.isEmpty else { return "0" }
        
        // Transform percentages based on context (Samsung logic)
        let contextualized = contextualizePercentages(in: expression)
        
        var sanitized = contextualized
            .replacingOccurrences(of: "×", with: "*")
            .replacingOccurrences(of: "÷", with: "/")
            .replacingOccurrences(of: "−", with: "-")
            .replacingOccurrences(of: "%", with: "/100")
            // Handle regular operators if pasted
            .replacingOccurrences(of: "x", with: "*")
            .replacingOccurrences(of: ":", with: "/")
        
        // Remove trailing operators and characters that break evaluation
        while let last = sanitized.last, "+-*/(.".contains(last) {
            sanitized.removeLast()
        }
        
        if sanitized.isEmpty { return "0" }
        
        // Implicit Multiplication: Insert '*' where needed
        let patterns = [
            ("(\\d)\\(", "$1*("),
            ("\\)(\\d)", ")*$1"),
            ("\\)\\(", ")*("),
            ("(/100)\\(", "$1*(")
        ]
        
        for (pattern, replacement) in patterns {
            if let regex = try? NSRegularExpression(pattern: pattern) {
                let range = NSRange(location: 0, length: sanitized.utf16.count)
                sanitized = regex.stringByReplacingMatches(in: sanitized, options: [], range: range, withTemplate: replacement)
            }
        }

        // Balance brackets
        let openCount = sanitized.filter { $0 == "(" }.count
        let closeCount = sanitized.filter { $0 == ")" }.count
        if openCount > closeCount {
            for _ in 0..<(openCount - closeCount) {
                sanitized += ")"
            }
        }
        
        // Final cleanup
        while sanitized.contains("()") {
            sanitized = sanitized.replacingOccurrences(of: "()", with: "")
        }
        
        if sanitized.isEmpty { return "0" }
        
        let context = JSContext()
        let jsResult = context?.evaluateScript(sanitized)
        
        if let value = jsResult?.toDouble(), !value.isNaN && !value.isInfinite {
            let formatter = NumberFormatter()
            formatter.minimumFractionDigits = 0
            formatter.maximumFractionDigits = 8
            return formatter.string(from: NSNumber(value: value)) ?? "Error"
        }
        
        return "Error"
    }

    private func contextualizePercentages(in expression: String) -> String {
        var result = expression
        
        // Process each % from left to right
        while let percentIndex = result.firstIndex(of: "%") {
            let beforePercent = String(result[..<percentIndex])
            
            // Find expression B immediately preceding %
            guard let bInfo = findPrecedingExpression(in: beforePercent) else {
                result.replaceSubrange(percentIndex...percentIndex, with: "/100")
                continue
            }
            
            let bExpr = bInfo.expr
            let remaining = bInfo.remaining
            
            // Check for + or - operator before B
            if let lastOp = remaining.last, (lastOp == "+" || lastOp == "−" || lastOp == "-") {
                let aExpr = String(remaining.dropLast()).trimmingCharacters(in: .whitespaces)
                if !aExpr.isEmpty {
                    // Contextual replacement: A + B% -> A + (A * B / 100)
                    let replacement = "((\(aExpr)) * (\(bExpr)) / 100)"
                    // Replace from the end of aExpr operator position to % position
                    let startOfOp = remaining.index(before: remaining.endIndex)
                    let rangeToReplace = startOfOp...percentIndex
                    result.replaceSubrange(rangeToReplace, with: "\(lastOp)\(replacement)")
                } else {
                    result.replaceSubrange(percentIndex...percentIndex, with: "/100")
                }
            } else {
                result.replaceSubrange(percentIndex...percentIndex, with: "/100")
            }
        }
        
        return result
    }

    private func findPrecedingExpression(in s: String) -> (expr: String, remaining: String)? {
        guard !s.isEmpty else { return nil }
        
        if s.hasSuffix(")") {
            var count = 0
            var index = s.index(before: s.endIndex)
            while index >= s.startIndex {
                if s[index] == ")" { count += 1 }
                else if s[index] == "(" { count -= 1 }
                
                if count == 0 {
                    let expr = String(s[index...])
                    let remaining = String(s[..<index])
                    return (expr, remaining)
                }
                if index == s.startIndex { break }
                index = s.index(before: index)
            }
        } else {
            // Find preceding number or bracketed expression
            var index = s.index(before: s.endIndex)
            var foundDigit = false
            while index >= s.startIndex {
                let char = s[index]
                if char.isNumber || char == "." {
                    foundDigit = true
                } else {
                    if foundDigit {
                        let exprBound = s.index(after: index)
                        let expr = String(s[exprBound...])
                        let remaining = String(s[...index])
                        return (expr, remaining)
                    }
                    return nil
                }
                if index == s.startIndex {
                    return (s, "")
                }
                index = s.index(before: index)
            }
        }
        return nil
    }
}




extension CalcButton {
    var isOperator: Bool {
        switch self {
        case .add, .subtract, .multiply, .divide:
            return true
        default:
            return false
        }
    }
}

#Preview {
    ContentView()
        .preferredColorScheme(.light)
}
