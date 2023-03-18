//
//  TimerTextComponent.swift
//  CountTodo
//
//  Created by 서현규 on 2023/03/08.
//

import SwiftUI

struct TimerTextComponent: View {
    
    @ObservedObject var viewModel: DataController
    
    var entity: TodoEntity
    var timerText: String = ""
    
    var body: some View {
        VStack {
            if entity.success {
                Text("성공!")
                    .font(.callout)
                    .fontWeight(.bold)
                    .foregroundColor(.blue)
            } else if entity.fail {
                Text("시간이 초과되었습니다.")
                    .font(.callout)
                    .fontWeight(.bold)
                    .foregroundColor(.red)
                    .lineLimit(2)
            } else {
                Text(viewModel.getCountdownString(id: entity.id))
                    .font(.callout)
                    .fontWeight(.bold)
            }
        }
    }
}
//
//struct TimerTextComponent_Previews: PreviewProvider {
//    static var previews: some View {
//        TimerTextComponent()
//    }
//}
