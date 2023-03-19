//
//  ContentView.swift
//  Pinch
//
//  Created by Pham Nguyen Phu on 19/03/2023.
//

import SwiftUI

struct ContentView: View {
    // MARK: - PROPERTY

    @State private var isAnimating: Bool = false
    @State private var imageScale: CGFloat = 1

    // MARK: - FUNCTION

    // MARK: - CONTENT

    var body: some View {
        NavigationStack {
            ZStack {
                // MARK: - PAGE IMAGE

                Image("magazine-front-cover")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .cornerRadius(10)
                    .padding()
                    .shadow(color: .black.opacity(0.4), radius: 12, x: 2, y: 2)
                    .opacity(isAnimating ? 1 : 0)
                    .scaleEffect(imageScale)

                    // MARK: - 1. TAP GESTURE

                    .onTapGesture(count: 2) {
                        if imageScale == 1 {
                            withAnimation(.spring()) {
                                imageScale = 3
                            }
                        }
                        else {
                            withAnimation(.spring()) {
                                imageScale = 1
                            }
                        }
                    }
            } //: Zstack
            .navigationTitle("Pinch & Zoom")
            .navigationBarTitleDisplayMode(.inline)
            .onAppear {
                withAnimation(.linear(duration: 1)) {
                    isAnimating = true
                }
            }
        } //: NavigationStack
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
