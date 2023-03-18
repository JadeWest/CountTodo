//
//  ImportanceButton.swift
//  CountTodo
//
//  Created by 서현규 on 2023/03/08.
//

import SwiftUI

struct ImportanceButton: View {
    
    @ObservedObject var viewModel: DataController
    
    var entity: TodoEntity
    
    var body: some View {
        
        if entity.importance {
            Image(systemName: "star.fill")
                .resizable()
                .scaledToFit()
                .frame(width: 25, height: 25)
                .foregroundColor(.yellow)
                .transition(.scale.animation(.easeInOut(duration: 0.2)))
        } else {
            Image(systemName: "star")
                .resizable()
                .scaledToFit()
                .frame(width: 25, height: 25)
                .foregroundColor(.yellow)
                .transition(.scale.animation(.easeInOut(duration: 0.2)))
        }
    }
}
//
//struct ImportanceButton_Previews: PreviewProvider {
//    static var previews: some View {
//        ImportanceButton()
//    }
//}
