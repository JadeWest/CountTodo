//
//  TitleComponent.swift
//  CountTodo
//
//  Created by 서현규 on 2023/03/08.
//

import SwiftUI

struct TitleComponent: View {
    
    @ObservedObject var viewModel: DataController
    
    var entity: TodoEntity
    
    var body: some View {
        if let title = entity.title {
            Text("\(title)")
                .font(.title3)
                .fontWeight(.bold)
        }
    }
}

//struct TitleComponent_Previews: PreviewProvider {
//    static var previews: some View {
//        TitleComponent()
//    }
//}
