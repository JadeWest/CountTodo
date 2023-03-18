//
//  SuccessButton.swift
//  CountTodo
//
//  Created by 서현규 on 2023/03/08.
//

import SwiftUI

struct SuccessButton: View {
    
    @ObservedObject var viewModel: DataController
    
    var entity: TodoEntity
    
    var body: some View {
        
        if entity.success {
            Image(systemName: "checkmark.circle.fill")
                .resizable()
                .scaledToFit()
                .frame(width: 30, height: 30)
                .foregroundColor(.blue)
                .transition(.scale.animation(.easeInOut(duration: 0.2)))
                .onTapGesture {
                    withAnimation(.linear) {
                        entity.success.toggle()
                        viewModel.save()
                    }
                }
                
        } else if entity.fail {
            Image(systemName: "xmark.circle.fill")
                .resizable()
                .scaledToFit()
                .frame(width: 30, height: 30)
                .foregroundColor(.gray)
        } else {
            Image(systemName: "circle")
                .resizable()
                .scaledToFit()
                .frame(width: 30, height: 30)
                .foregroundColor(.blue)
                .transition(.scale.animation(.easeInOut(duration: 0.2)))
                .onTapGesture {
                    withAnimation(.linear) {
                        entity.success.toggle()
                        viewModel.save()
                    }
                }
        }
    }
}
//
//struct SuccessButton_Previews: PreviewProvider {
//    static var previews: some View {
//        SuccessButton()
//    }
//}
