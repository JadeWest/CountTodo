//
//  CircleTimer.swift
//  CountTodo
//
//  Created by 서현규 on 2023/03/08.
//

import SwiftUI

struct CircleTimer: View {
    
    @ObservedObject var viewModel: DataController
    
    var entity: TodoEntity
    
    @State var countInterval: CGFloat = 0.0
    @State var counter = 0.0
    
    var body: some View {
        ZStack {
            if entity.success || entity.fail {
                Circle()
                    .fill(.clear)
                    .frame(width: 250, height: 250)
                    .overlay(
                        Circle()
                            .stroke(
                                .secondary,
                                lineWidth: 25
                            )
                    )
                TimerTextComponent(viewModel: self.viewModel, entity: self.entity)
                    .frame(width: 150, height: 150)
            } else {
                Circle()
                    .fill(.clear)
                    .frame(width: 250, height: 250)
                    .overlay(
                        Circle()
                            .stroke(
                                .secondary
                                , lineWidth: 25
                            )
                    )
                
                Circle()
                    .fill(.clear)
                    .frame(width: 250, height: 250)
                    .overlay(
                        Circle()
                            .trim(from: 0, to: progress())
                            .stroke(
                                style: StrokeStyle(
                                    lineWidth: 15,
                                    lineCap: .round,
                                    lineJoin: .round
                                )
                            )
                            .foregroundColor(.green)
                            .animation(.easeInOut, value: progress())
                            
                    )
                    .rotationEffect(Angle(degrees: -90))
                if entity.success {
                    Image(systemName: "checkmark")
                        .resizable()
                        .scaledToFit()
                        .foregroundColor(.blue)
                        .frame(width: 50, height: 50)
                    TimerTextComponent(viewModel: self.viewModel, entity: self.entity)
                        .frame(width: 150, height: 150)
                } else if entity.fail {
                    Image(systemName: "xmark")
                        .resizable()
                        .scaledToFit()
                        .foregroundColor(.blue)
                        .frame(width: 50, height: 50)
                    TimerTextComponent(viewModel: self.viewModel, entity: self.entity)
                        .frame(width: 150, height: 150)
                } else {
                    TimerTextComponent(viewModel: self.viewModel, entity: self.entity)
                        .frame(width: 150, height: 150)
                }
            }
        }
        .onReceive(viewModel.milisecondTimer) { time in
            guard let deadline = entity.deadline else {return}
            self.countInterval = deadline.timeIntervalSince(time)
            if (self.countInterval < self.getTotalInterval()) {
                self.countInterval -= 1
            } else {
                self.countInterval = 0
            }
        }
    }
    
    func progress() -> CGFloat {
        return (CGFloat(countInterval) / CGFloat(getTotalInterval()))
    }
    
    func getTotalInterval() -> CGFloat {
        guard let createdAt = entity.createdAt, let deadline = entity.deadline else {return 0.0}
        return CGFloat(deadline.timeIntervalSince(createdAt))
    }
}

//struct CircleTimer_Previews: PreviewProvider {
//    static var previews: some View {
//        CircleTimer()
//    }
//}
