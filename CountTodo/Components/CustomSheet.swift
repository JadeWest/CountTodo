//
//  CustomShhet.swift
//  CountTodo
//
//  Created by 서현규 on 2023/03/12.
//

import SwiftUI

struct CustomSheet: View {
    
    @Environment(\.dismiss) var dismiss
    
    @ObservedObject var viewModel: DataController
    
    @Binding var showAddTodo: Bool
    
    @State var textFieldText: String = ""
    @State var datePickerSelection: Date = Date()
    @State var dateInvalidAlert: Bool = false
    
    var body: some View {
        ZStack {
            VStack {
                VStack {
                    ZStack(alignment: .trailing) {
                        TextField("작업 추가", text: $textFieldText)
                            .font(.headline)
                            .padding(.leading)
                            .frame(height: 55)
                            .background(Color(uiColor: .secondarySystemFill))
                            .cornerRadius(10)
                        HStack {
                            if !textFieldText.isEmpty {
                                Button {
                                    textFieldText.removeAll()
                                } label: {
                                    Image(systemName: "xmark.circle.fill")
                                        .resizable()
                                        .foregroundColor(Color(uiColor: .tertiaryLabel))
                                        .frame(width: 20, height: 20)
                                }
                            }
                        }.padding(.trailing, 25)
                    }
                    
                    DatePicker("마감일",selection: $datePickerSelection, in: Date().addingTimeInterval(60)..., displayedComponents: [.date, .hourAndMinute])
                        .datePickerStyle(.compact)
                        .environment(\.locale, Locale(identifier: "ko_KR"))
                        .padding(.top, 10)
                    
                    Spacer()
                    
                    Button {
                        if datePickerSelection <= Date() {
                            dateInvalidAlert = true
                        } else {
                            viewModel.addEntity(title: textFieldText, deadline: datePickerSelection)
                            showAddTodo = false
                        }
                    } label: {
                        Text("완료")
                            .font(.headline)
                            .foregroundColor(.white)
                            .frame(height: 55)
                            .frame(maxWidth: .infinity)
                            .background(textIsValid() ? .blue : .gray)
                            .cornerRadius(10)
                    }
                    .disabled(!textIsValid())
                    .padding(.bottom, 15)
                    .alert(isPresented: $dateInvalidAlert) {
                        Alert(
                            title: Text("마감일이 유효하지 않습니다."),
                            message: Text("선택한 마감일이 현재시간 이전입니다. 다시 선택해주세요."),
                            dismissButton: .cancel(Text("확인")) {dateInvalidAlert = false})
                    }
                }
                .padding(.vertical)
                .padding(.horizontal)
            }
        }
    }
    
    func textIsValid() -> Bool {
        if !textFieldText.isEmpty {
            return true
        }
        return false
    }
    
    func invalidDateAlert() -> Bool {
        if datePickerSelection <= Date() {
            return true
        }
        return false
    }
}

//struct CustomShhet_Previews: PreviewProvider {
//    static var previews: some View {
//        CustomShhet()
//    }
//}
