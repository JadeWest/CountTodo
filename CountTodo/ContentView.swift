//
//  ContentView.swift
//  CountTodo
//
//  Created by 서현규 on 2023/03/07.
//

import SwiftUI
import CoreData

struct ContentView: View {
    @StateObject var viewModel = DataController.shared

    @State private var showAddTodo = false
    
    
    var body: some View {
        VStack {
            NavigationView {
                List {
                    ForEach(viewModel.workingEntities, id: \.self) { item in
                        NavigationLink {
                            TodoDetailView(viewModel: self.viewModel, showAddTodo: $showAddTodo, entity: item)
                        } label: {
                            HStack {
                                SuccessButton(viewModel: self.viewModel, entity: item)
                                
                                VStack(alignment: .leading, spacing: 5) {
                                    TitleComponent(viewModel: self.viewModel, entity: item)
                                    TimerTextComponent(viewModel: self.viewModel, entity: item)
                                        .onReceive(viewModel.milisecondTimer) { _ in
                                            viewModel.calculateDeadline(id: item.id, deadline: item.deadline, entity: item)
                                        }
                                }
                                .frame(maxWidth: .infinity, alignment: .leading)
                                
                                ImportanceButton(viewModel: self.viewModel, entity: item)
                                    .onTapGesture {
                                        withAnimation(.linear) {
                                            item.importance.toggle()
                                            viewModel.save()
                                        }
                                    }
                            }
                        }
                    }
                    .onDelete(perform: viewModel.deleteEntity)
                }
                .navigationTitle("Todo")
                .toolbar(content: {
                    ToolbarItemGroup(placement: .navigationBarTrailing) {
                        Button(action: {
                            withAnimation(.easeInOut) {
                                showAddTodo.toggle()
                            }
                        }, label: {
                            if showAddTodo {
                                Text("취소")
                                    .foregroundColor(.blue)
                            } else {
                                Text("추가")
                                    .foregroundColor(.blue)
                            }
                        })
                    }
                })
                .onAppear {
                    viewModel.milisecondTimer = Timer.publish(every: 0.1, on: .current, in: .common).autoconnect()
                }
            }// NavigationView End
        }
        .onAppear()
        // ZStack End
        if showAddTodo {
            CustomSheet(viewModel: viewModel, showAddTodo: $showAddTodo)
                .frame(height: UIScreen.main.bounds.size.height * 0.3)
                .edgesIgnoringSafeArea([.bottom])
                .transition(.move(edge: .bottom))
                .animation(.easeInOut, value: showAddTodo)
                .onAppear {
                    viewModel.milisecondTimer.upstream.connect().cancel()
                }
                .onDisappear {
                    viewModel.milisecondTimer = Timer.publish(every: 0.1, on: .current, in: .common).autoconnect()
                }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
