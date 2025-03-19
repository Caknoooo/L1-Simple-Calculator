//
//  ContentView.swift
//  SimpleCalculator
//
//  Created by M Naufal Badruttamam on 19/03/25.
//

import SwiftUI

struct ContentView: View {
    @State private var displayValue = "0"
    @State private var currentOperation: Operation? = nil
    @State private var storedValue: Double? = nil
    @State private var shouldResetDisplay = false
    
    enum Operation {
        case addition, subtraction, multiplication, division
    }
    
    var body: some View {
        VStack(spacing: 12) {
            Spacer()
            
            // Display
            Text(displayValue)
                .font(.system(size: 70))
                .fontWeight(.light)
                .padding(.horizontal, 20)
                .frame(maxWidth: .infinity, alignment: .trailing)
                .lineLimit(1)
                .minimumScaleFactor(0.5)
            
            // Calculator buttons
            VStack(spacing: 12) {
                HStack(spacing: 12) {
                    CalculatorButton(title: "AC", color: .gray) {
                        resetCalculator()
                    }
                    CalculatorButton(title: "+/-", color: .gray) {
                        negateValue()
                    }
                    CalculatorButton(title: "%", color: .gray) {
                        calculatePercentage()
                    }
                    CalculatorButton(title: "÷", color: .orange) {
                        performOperation(.division)
                    }
                }
                
                HStack(spacing: 12) {
                    CalculatorButton(title: "7") {
                        appendDigit("7")
                    }
                    CalculatorButton(title: "8") {
                        appendDigit("8")
                    }
                    CalculatorButton(title: "9") {
                        appendDigit("9")
                    }
                    CalculatorButton(title: "×", color: .orange) {
                        performOperation(.multiplication)
                    }
                }
                
                HStack(spacing: 12) {
                    CalculatorButton(title: "4") {
                        appendDigit("4")
                    }
                    CalculatorButton(title: "5") {
                        appendDigit("5")
                    }
                    CalculatorButton(title: "6") {
                        appendDigit("6")
                    }
                    CalculatorButton(title: "-", color: .orange) {
                        performOperation(.subtraction)
                    }
                }
                
                HStack(spacing: 12) {
                    CalculatorButton(title: "1") {
                        appendDigit("1")
                    }
                    CalculatorButton(title: "2") {
                        appendDigit("2")
                    }
                    CalculatorButton(title: "3") {
                        appendDigit("3")
                    }
                    CalculatorButton(title: "+", color: .orange) {
                        performOperation(.addition)
                    }
                }
                
                HStack(spacing: 12) {
                    CalculatorButton(title: "0", isWide: true) {
                        appendDigit("0")
                    }
                    CalculatorButton(title: ".") {
                        appendDecimal()
                    }
                    CalculatorButton(title: "=", color: .orange) {
                        calculateResult()
                    }
                }
            }
            .padding()
        }
        .background(Color.black)
    }
    
    // Calculator logic
    private func appendDigit(_ digit: String) {
        if shouldResetDisplay {
            displayValue = digit
            shouldResetDisplay = false
        } else {
            if displayValue == "0" {
                displayValue = digit
            } else {
                displayValue.append(digit)
            }
        }
    }
    
    private func appendDecimal() {
        if shouldResetDisplay {
            displayValue = "0."
            shouldResetDisplay = false
        } else if !displayValue.contains(".") {
            displayValue.append(".")
        }
    }
    
    private func resetCalculator() {
        displayValue = "0"
        currentOperation = nil
        storedValue = nil
        shouldResetDisplay = false
    }
    
    private func negateValue() {
        if let value = Double(displayValue), value != 0 {
            if value > 0 {
                displayValue = "-" + displayValue
            } else {
                displayValue.removeFirst()
            }
        }
    }
    
    private func calculatePercentage() {
        if let value = Double(displayValue) {
            displayValue = formatValue(value / 100)
        }
    }
    
    private func performOperation(_ operation: Operation) {
        if let value = Double(displayValue) {
            if let stored = storedValue, let currentOp = currentOperation {
                let result = calculate(stored, value, currentOp)
                displayValue = formatValue(result)
                storedValue = result
            } else {
                storedValue = value
            }
            currentOperation = operation
            shouldResetDisplay = true
        }
    }
    
    private func calculateResult() {
        if let value = Double(displayValue), let stored = storedValue, let operation = currentOperation {
            let result = calculate(stored, value, operation)
            displayValue = formatValue(result)
            storedValue = nil
            currentOperation = nil
            shouldResetDisplay = true
        }
    }
    
    private func calculate(_ first: Double, _ second: Double, _ operation: Operation) -> Double {
        switch operation {
        case .addition:
            return first + second
        case .subtraction:
            return first - second
        case .multiplication:
            return first * second
        case .division:
            return first / second
        }
    }
    
    private func formatValue(_ value: Double) -> String {
        if value.truncatingRemainder(dividingBy: 1) == 0 {
            return String(format: "%.0f", value)
        } else {
            return String(value)
        }
    }
}

struct CalculatorButton: View {
    var title: String
    var color: Color = .init(white: 0.2)
    var isWide: Bool = false
    var action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Text(title)
                .font(.title)
                .fontWeight(.semibold)
                .foregroundColor(.white)
                .frame(width: isWide ? 168 : 76, height: 76)
                .background(color)
                .cornerRadius(38)
        }
    }
}


#Preview(body: {
    ContentView()
})
