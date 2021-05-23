//
//  ContentView.swift
//  calculator
//
//  Created by 王天伟 on 2021/5/23.
//

import SwiftUI

let viewBounds:CGRect = UIScreen.main.bounds
let screenWidth = viewBounds.width
let screenHeight = viewBounds.height

struct CalculatorBtn: View {
    @Binding var calcVal:String
    @Binding var calcValHistory:String
    @Binding var calcMethod:String
    @Binding var calcResult:String
    
    var text:String
    var value:Int?
    var isControlType:Bool
    var color:Color
    
    
    var body: some View{
        Button(action: {
            // 清除全部
            if(isControlType && text == "AC"){
                calcVal = "0"
                calcValHistory = ""
                calcMethod = ""
                calcResult = ""
                return
            }
            // 正数时输+/-会在最前面加入-
            if(isControlType && text == "+/-" && !calcVal.contains("-") && calcVal != "0"){
                calcVal = "-"+calcVal
                return
            }
            // 负数时输入+/-会去掉前面的-
            if(isControlType && text == "+/-" && calcVal.contains("-") && calcVal != "0"){
                calcVal.removeFirst()
                return
            }
            // 当前为0时输入+/-什么都不做
            if(isControlType && text == "+/-" && calcVal == "0"){
                return
            }
            // 输入运算符%时，将当前值/100
            if(isControlType && text == "%"){
                calcVal = "\((calcVal as NSString).floatValue/100)"
                return
            }
            // 输入运算符+时，将当前值、运算符保存至历史
            if(isControlType && text == "+"){
                calcMethod = "+"
                calcResult = calcVal
                calcValHistory += "\n" + calcVal  + "+"
                calcVal = "0"
                return
            }
            // 输入运算符-时，将当前值、运算符保存至历史
            if(isControlType && text == "-"){
                calcMethod = "-"
                calcResult = calcVal
                calcValHistory += "\n" + calcVal + "-"
                calcVal = "0"
                return
            }
            // 输入运算符x时，将当前值、运算符保存至历史
            if(isControlType && text == "x"){
                calcMethod = "x"
                calcResult = calcVal
                calcValHistory += "\n" + calcVal + "x"
                calcVal = "0"
                return
            }
            // 输入运算符÷时，将当前值、运算符保存至历史
            if(isControlType && text == "÷"){
                calcMethod = "÷"
                calcResult = calcVal
                calcValHistory += "\n" + calcVal + "÷"
                calcVal = "0"
                return
            }
            // 输入运算符=时，计算结果
            if(isControlType && text == "="){
                switch calcMethod {
                case "+":
                    calcMethod = ""
                    calcResult = "\((calcResult as NSString).floatValue + (calcVal as NSString).floatValue)"
                    calcValHistory += calcVal + "\n" + calcResult
                    calcVal = calcResult
                    break
                case "-":
                    calcMethod = ""
                    calcResult = "\((calcResult as NSString).floatValue - (calcVal as NSString).floatValue)"
                    calcValHistory += calcVal + "\n" + calcResult
                    calcVal = calcResult
                        break
                case "x":
                    calcMethod = ""
                    calcResult = "\((calcResult as NSString).floatValue * (calcVal as NSString).floatValue)"
                    calcValHistory += calcVal + "\n" + calcResult
                    calcVal = calcResult
                        break
                case "÷":
                    calcMethod = ""
                    calcResult = "\((calcResult as NSString).floatValue / (calcVal as NSString).floatValue)"
                    calcValHistory += calcVal + "\n" + calcResult
                    calcVal = calcResult
                        break
                default:
                    break
                }
                return
            }
            // 为0时输入数字会替换0
            if(calcVal == "0" && text != "."){
                calcVal = text
                return
            }
            // 为0时输入.会在0后追加.
            if(calcVal == "0" && text == "." && !calcVal.contains(".")){
                calcVal += text
                return
            }
            // 不存在.时正常追加.
            if(text == "." && !calcVal.contains(".")){
                calcVal += text
                return
            }
            // 正常输入，追加数字
            if(calcVal != "0" && text != "."){
                calcVal += text
                return
            }
            // 当存在.时输入.什么都不做
            if(calcVal.contains(".") && text=="."){
                return
            }
        }) {
            ZStack {
                Rectangle()
                    .accentColor(color)
                Text(text)
                    .font(.largeTitle)
                    .foregroundColor(Color.white)
            }
           
        }
    }
}

struct ContentView: View {
    
    var btnColorHeavy = Color(red: 0.282, green: 0.294, blue: 0.318, opacity: 0.8)
    var btnColorLight = Color(red: 0.408, green: 0.408, blue: 0.408, opacity: 0.8)
    var btnColorOrange = Color(red: 0.996, green: 0.549, blue: 0.055, opacity: 0.8)
    
    @State var calcVal:String = "0"
    @State var calcValHistory:String = ""
    @State var calcResult:String = ""
    @State var calcMethod:String = ""
    
    var body: some View {
        VStack(spacing: 0.5) {
            Spacer()
            TextEditor(text: $calcValHistory).padding(.all)
                    .frame(height: screenHeight/3).multilineTextAlignment(.trailing).foregroundColor(.white).font(.custom("Helvetica Neue", size: 30))
            TextField("", text: $calcVal).padding(.horizontal).frame(height: screenHeight/10).font(/*@START_MENU_TOKEN@*/.largeTitle/*@END_MENU_TOKEN@*/).multilineTextAlignment(.trailing).foregroundColor(/*@START_MENU_TOKEN@*/.white/*@END_MENU_TOKEN@*/)
            VStack(spacing: 0.5) {
                HStack(spacing: 0.5) {
                    CalculatorBtn(calcVal: $calcVal, calcValHistory: $calcValHistory, calcMethod: $calcMethod, calcResult: $calcResult, text: "AC", isControlType: true, color: btnColorHeavy)
                    CalculatorBtn(calcVal: $calcVal, calcValHistory: $calcValHistory, calcMethod: $calcMethod, calcResult: $calcResult, text: "+/-", isControlType: true, color: btnColorHeavy)
                    CalculatorBtn(calcVal: $calcVal, calcValHistory: $calcValHistory, calcMethod: $calcMethod, calcResult: $calcResult, text: "%", isControlType: true, color: btnColorHeavy)
                    CalculatorBtn(calcVal: $calcVal, calcValHistory: $calcValHistory, calcMethod: $calcMethod, calcResult: $calcResult, text: "÷", isControlType: true, color: btnColorOrange)
                }
            }
            VStack(spacing: 0.5) {
                HStack(spacing: 0.5) {
                    CalculatorBtn(calcVal: $calcVal, calcValHistory: $calcValHistory, calcMethod: $calcMethod, calcResult: $calcResult, text: "7", isControlType: false, color: btnColorLight)
                    CalculatorBtn(calcVal: $calcVal, calcValHistory: $calcValHistory, calcMethod: $calcMethod, calcResult: $calcResult, text: "8", isControlType: false, color: btnColorLight)
                    CalculatorBtn(calcVal: $calcVal, calcValHistory: $calcValHistory, calcMethod: $calcMethod, calcResult: $calcResult, text: "9", isControlType: false, color: btnColorLight)
                    CalculatorBtn(calcVal: $calcVal, calcValHistory: $calcValHistory, calcMethod: $calcMethod, calcResult: $calcResult, text: "x", isControlType: true, color: btnColorOrange)
                }
            }
            VStack(spacing: 0.5) {
                HStack(spacing: 0.5) {
                    CalculatorBtn(calcVal: $calcVal, calcValHistory: $calcValHistory, calcMethod: $calcMethod, calcResult: $calcResult, text: "4", isControlType: false, color: btnColorLight)
                    CalculatorBtn(calcVal: $calcVal, calcValHistory: $calcValHistory, calcMethod: $calcMethod, calcResult: $calcResult, text: "5", isControlType: false, color: btnColorLight)
                    CalculatorBtn(calcVal: $calcVal, calcValHistory: $calcValHistory, calcMethod: $calcMethod, calcResult: $calcResult, text: "6", isControlType: false, color: btnColorLight)
                    CalculatorBtn(calcVal: $calcVal, calcValHistory: $calcValHistory, calcMethod: $calcMethod, calcResult: $calcResult, text: "-", isControlType: true, color: btnColorOrange)
                }
            }
            VStack(spacing: 0.5) {
                HStack(spacing: 0.5) {
                    CalculatorBtn(calcVal: $calcVal, calcValHistory: $calcValHistory, calcMethod: $calcMethod, calcResult: $calcResult, text: "1", isControlType: false, color: btnColorLight)
                    CalculatorBtn(calcVal: $calcVal, calcValHistory: $calcValHistory, calcMethod: $calcMethod, calcResult: $calcResult, text: "2", isControlType: false, color: btnColorLight)
                    CalculatorBtn(calcVal: $calcVal, calcValHistory: $calcValHistory, calcMethod: $calcMethod, calcResult: $calcResult, text: "3", isControlType: false, color: btnColorLight)
                    CalculatorBtn(calcVal: $calcVal, calcValHistory: $calcValHistory, calcMethod: $calcMethod, calcResult: $calcResult, text: "+", isControlType: true, color: btnColorOrange)
                }
            }

            VStack(spacing: 0.5) {
                HStack(spacing: 0.5) {
                    CalculatorBtn(calcVal: $calcVal, calcValHistory: $calcValHistory, calcMethod: $calcMethod, calcResult: $calcResult, text: "0", isControlType: false, color: btnColorLight)
                        .frame(width: screenWidth/2)
                    CalculatorBtn(calcVal: $calcVal, calcValHistory: $calcValHistory, calcMethod: $calcMethod, calcResult: $calcResult, text: ".", isControlType: false, color: btnColorLight)
                        .frame(width: screenWidth/4-0.5)
                    CalculatorBtn(calcVal: $calcVal, calcValHistory: $calcValHistory, calcMethod: $calcMethod, calcResult: $calcResult, text: "=", isControlType: true, color: btnColorOrange)
                        .frame(width: screenWidth/4-0.5)
                }
            }
        }
        .padding(.bottom, 15.0)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
