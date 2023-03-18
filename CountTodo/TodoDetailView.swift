//
//  TodoDetailView.swift
//  CountTodo
//
//  Created by 서현규 on 2023/03/08.
//

import SwiftUI

struct TodoDetailView: View {
    
    @ObservedObject var viewModel: DataController
    
    @Binding var showAddTodo: Bool
    
    var entity: TodoEntity
    @State private var textFieldText: String = ""
    @State private var textFieldEmptyAlert: Bool = false
    @FocusState private var titleFieldIsFocused: Bool
    
    var body: some View {
        VStack {
            
            Divider()
            
            HStack {
                SuccessButton(viewModel: self.viewModel, entity: entity)
                
                TextField("작업명", text: $textFieldText)
                    .font(.title3)
                    .padding(.horizontal)
                    .frame(height: 55)
                    .foregroundColor(.blue)
                    .background(.clear)
                    .cornerRadius(10)
                    .focused($titleFieldIsFocused)
                    .onSubmit {
                        if textFieldText.isEmpty {
                            textFieldEmptyAlert = true
                        }
                        viewModel.updateEntity(entity: entity, title: textFieldText)
                    }
                    .alert(isPresented: $textFieldEmptyAlert) {
                        Alert(
                            title: Text("작업명 비어있습니다."),
                            message: Text("작업명이 비어있습니다. 제목을 입력해주세요."),
                            dismissButton: .cancel(Text("OK")) {textFieldEmptyAlert = false})
                    }
                    .onAppear {
                        if let title = entity.title {
                            self.textFieldText = title
                        }
                    }
                    
                ImportanceButton(viewModel: self.viewModel, entity: entity)
                    .onTapGesture {
                        entity.importance.toggle()
                        viewModel.save()
                    }
            }
            .padding(.horizontal)
            
            Divider()
            
            CircleTimer(viewModel: self.viewModel, entity: entity)
                .padding(.vertical, 50)
                .onReceive(viewModel.milisecondTimer) { time in
                    viewModel.calculateDeadline(id: entity.id, deadline: entity.deadline, entity: entity)
                }
            
            Divider()
            
            if let deadline = entity.deadline {
                Text("\(viewModel.dateFormatter.string(from: deadline))까지")
                    .font(.headline)
                    .fontWeight(.bold)
                    .foregroundColor(.gray)
            } else {
                Text("마감일을 찾을 수 없습니다.")
                    .font(.headline)
                    .fontWeight(.bold)
                    .foregroundColor(.gray)
            }
            
            Divider()
        }
        .padding(.horizontal)
        .toolbar {
            Button("완료") {
                if textFieldText.isEmpty {
                    textFieldEmptyAlert = true
                }
                viewModel.updateEntity(entity: entity, title: textFieldText)
            }.opacity(titleFieldIsFocused ? 1.0 : 0.0)
        }
        .onAppear {
            viewModel.milisecondTimer = Timer.publish(every: 0.1, on: .current, in: .common).autoconnect()
            showAddTodo = false
        }
        Spacer()
    }
}

//struct TodoDetailView_Previews: PreviewProvider {
//    static var previews: some View {
//        TodoDetailView()
//    }
//}
