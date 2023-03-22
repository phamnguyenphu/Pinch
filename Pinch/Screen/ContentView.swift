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
    @State private var imageOffset: CGSize = .zero
    @State private var isDrawerOpen: Bool = false
    @State private var endDragOffset: CGSize = .zero
    
    let pages: [Page] = pagesData
    @State private var pageIndex: Int = 0
    
    // MARK: - FUNCTION
    
    func resetImageState() {
        return withAnimation(.spring()) {
            imageScale = 1
            imageOffset = .zero
            endDragOffset = .zero
        }
    }
    
    func currentPage() -> String {
        return pages[pageIndex].imageName
    }
    
    // MARK: - CONTENT
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color.clear
                
                // MARK: - PAGE IMAGE
                
                Image(currentPage())
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .cornerRadius(10)
                    .padding()
                    .shadow(color: .black.opacity(0.4), radius: 12, x: 2, y: 2)
                    .opacity(isAnimating ? 1 : 0)
                    .offset(x: imageOffset.width, y: imageOffset.height)
                    .scaleEffect(imageScale)
                
                    // MARK: - 1. TAP GESTURE
                
                    .onTapGesture(count: 2) {
                        if imageScale == 1 {
                            withAnimation(.spring()) {
                                imageScale = 5
                            }
                        }
                        else {
                            resetImageState()
                        }
                    }
                
                    // MARK: - 2. DRAG GESTURE
                
                    .gesture(
                        DragGesture()
                            .onChanged { value in
                                withAnimation(.linear(duration: 1)) {
                                    // imageOffset = value.translation
                                    imageOffset = CGSize(width: value.translation.width / 1.05 + endDragOffset.width, height: value.translation.height / 1.05 + endDragOffset.height)
                                }
                            }
                            .onEnded { value in
                                if imageScale <= 1 {
                                    resetImageState()
                                }
                                else {
                                    endDragOffset = CGSize(width: value.translation.width / 1.05 + endDragOffset.width, height: value.translation.height / 1.05 + endDragOffset.height)
                                }
                            }
                    )
                
                    // MARK: - 3. MAGNIFICATION GESTURE
                
                    .gesture(
                        MagnificationGesture()
                            .onChanged { value in
                                withAnimation(.linear(duration: 1)) {
                                    if imageScale >= 1, imageScale <= 5, value <= 5.1 {
                                        imageScale = value
                                    }
                                    else if imageScale > 5 {
                                        imageScale = 5
                                    }
                                }
                            }
                            .onEnded { _ in
                                if imageScale <= 1 {
                                    resetImageState()
                                }
                                else if imageScale > 5 {
                                    imageScale = 5
                                }
                            }
                    )
            } //: Zstack
            
            // MARK: INFO PANEL
            
            .overlay(
                InfoPanelView(scale: imageScale, offset: imageOffset)
                    .padding(.horizontal)
                    .padding(.top, 30),
                alignment: .top
            )
            
            // MARK: CONTROLS
            
            .overlay(
                Group {
                    HStack {
                        // MARK: SCALE DOWN
                        
                        Button {
                            withAnimation(.spring()) {
                                if imageScale > 1 {
                                    imageScale -= 1
                                    if imageScale <= 1 {
                                        resetImageState()
                                    }
                                }
                            }
                        } label: {
                            ControlImageView(icon: "minus.magnifyingglass")
                        }
                        
                        // MARK: RESET
                        
                        Button {
                            resetImageState()
                        } label: {
                            ControlImageView(icon: "arrow.up.left.and.down.right.magnifyingglass")
                        }
                        
                        // MARK: SCALE UP
                        
                        Button {
                            withAnimation(.spring()) {
                                if imageScale < 5 {
                                    imageScale += 1
                                    
                                    if imageScale > 5 {
                                        imageScale = 5
                                    }
                                }
                            }
                        } label: {
                            ControlImageView(icon: "plus.magnifyingglass")
                        }
                    }
                    .padding(EdgeInsets(top: 12, leading: 20, bottom: 12, trailing: 20))
                    .background(.ultraThinMaterial)
                    .cornerRadius(12)
                    .opacity(isAnimating ? 1 : 0)
                }
                .padding(.bottom, 30),
                
                alignment: .bottom
            )
            
            // MARK: DRAWER
            
            .overlay(
                HStack {
                    // MARK: - DRAWER HANDLE
                    
                    Image(systemName: isDrawerOpen ? "chevron.compact.right" : "chevron.compact.left")
                        .resizable()
                        .scaledToFit()
                        .frame(height: 40)
                        .padding(8)
                        .foregroundColor(.secondary)
                        .onTapGesture {
                            withAnimation(.easeOut) {
                                isDrawerOpen.toggle()
                            }
                        }
                    
                    // MARK: - THUMBNAILS
                    
                    Spacer()
                    
                    ForEach(pages) { page in
                        Image(page.thumbnailsName)
                            .resizable()
                            .scaledToFit()
                            .frame(width: 80)
                            .cornerRadius(8)
                            .shadow(radius: 4)
                            .opacity(isDrawerOpen ? 1 : 0)
                            .animation(.easeOut(duration: 0.5), value: isDrawerOpen)
                            .onTapGesture {
                                withAnimation(.linear(duration: 0.5)) {
                                    pageIndex = page.id
                                    resetImageState()
                                    isDrawerOpen.toggle()
                                }
                            }
                    }
                    Spacer()
                }
                .padding(EdgeInsets(top: 16, leading: 8, bottom: 16, trailing: 8))
                .background(.ultraThinMaterial)
                .cornerRadius(12)
                .opacity(isAnimating ? 1 : 0)
                .frame(width: 260)
                .padding(.top, UIScreen.main.bounds.height / 12)
                .offset(x: isDrawerOpen ? 20 : 215),
                alignment: .topTrailing
            )
            
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
