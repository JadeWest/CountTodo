//
//  SplashScreen.swift
//  CountTodo
//
//  Created by 서현규 on 2023/03/12.
//

import SwiftUI

struct SplashScreen: View {
    
    @State var isActive: Bool = false
    @State var showAnimation: Bool = false
    @State var showSplash: Bool = true
    @State var showCheckAnimation = false
    @State var scale = 1.0
    @State var maxGuage = 0.0
    
    var body: some View {
        if isActive {
            ContentView()
        } else {
            VStack {
                ZStack {
                    ZStack {
                        Circle()
                            .fill(.clear)
                            .frame(width: 150, height: 150)
                            .overlay(
                                Circle()
                                    .stroke(
                                        Color(.secondarySystemBackground)
                                        , lineWidth: 20
                                    )
                            )
                        
                        Circle()
                            .fill(.clear)
                            .frame(width: 150, height: 150)
                            .overlay(
                                Circle()
                                    .trim(from: 0, to: maxGuage)
                                    .stroke(
                                        style: StrokeStyle(
                                            lineWidth: 10,
                                            lineCap: .round,
                                            lineJoin: .round
                                        )
                                    )
                                    .foregroundColor(.green)
                                    .animation(.easeIn(duration: 0.5), value: showAnimation)
                            )
                            .rotationEffect(Angle(degrees: -90))
                        
                        
                        Image("checkmark")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 150, height: 150)
                            .foregroundColor(.green)
                    }
                    
                    
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(Color(uiColor: UIColor(named: "SplashScreenBackground") ?? .white))
                .edgesIgnoringSafeArea(.all)
            }
            .onAppear {
                DispatchQueue.main.asyncAfter(deadline: .now()+0.3) {
                    showAnimation.toggle()
                    maxGuage = 0.68
                }
                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                    isActive.toggle()
                }
            }
        }
    }
}

struct SplashScreen_Previews: PreviewProvider {
    static var previews: some View {
        SplashScreen()
    }
}
