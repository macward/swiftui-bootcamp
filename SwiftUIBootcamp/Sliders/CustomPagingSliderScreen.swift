//
//  CustomPagingSliderView.swift
//  SwiftUIBootcamp
//
//  Created by Max Ward on 01/10/2023.
//

import SwiftUI

struct Item: Identifiable {
    private (set) var id: UUID = .init()
    var color: Color
    var title: String
    var subtitle: String
}

struct CustomPagingSliderScreen: View {
    
    @State private var items: [Item] = [
        .init(color: .red, title: "World Clock", subtitle: "View the time in multiple cities around the world"),
        .init(color: .blue, title: "City Digital", subtitle: "Add a clock for a city to check the time at the location"),
        .init(color: .green, title: "City Analogue", subtitle: "View the time in multiple cities around the world"),
        .init(color: .yellow, title: "Next Alarm", subtitle: "Display upcoming alarms.")
    ]
    
    var body: some View {
        
        NavigationStack {
            ScrollView {
                
                // Header
                
                if #available(iOS 17, *) {
                    PagingSliderView(data: $items) { $item in
                        RoundedRectangle(cornerRadius: 16)
                            .fill(item.color.gradient)
                            .frame(width: nil, height: 220)
                            
                    } titleContent: { $item in
                        VStack {
                            Text(item.title)
                                .font(.largeTitle.bold())
                            
                            Text(item.subtitle)
                                .foregroundStyle(.gray)
                                .multilineTextAlignment(.center)
                                .frame(height: 40)
                        }
                        .padding()
                    }
                    .safeAreaPadding([.horizontal, .top], 35)
                } else {
                    OnlyiOS17View()
                }
                
                if #available(iOS 17, *) {
                    VStack {
                        HStack {
                            Text("Vertical list")
                                .font(.title3)
                                .multilineTextAlignment(.leading)
                                .padding(.leading, 20)
                            Spacer()
                        }
                        ScrollView (.vertical) {
                            VStack {
                                ForEach (0...2, id: \.self) { _ in
                                    SocialMediaCardView()
                                        
                                }
                            }
                            .scrollTargetLayout()
                            .safeAreaPadding(.horizontal, 20)
                        }
                        .contentMargins(16, for: .scrollContent)
                        .scrollTargetBehavior(.viewAligned)
                    }
                    .padding(.top)
                }
                
                if #available(iOS 17, *) {
                    VStack {
                        HStack {
                            Text("Horizontal list")
                                .font(.title3)
                                .multilineTextAlignment(.leading)
                                .padding(.leading, 20)
                            Spacer()
                        }
                        ScrollView (.horizontal) {
                            HStack {
                                ForEach (0...2, id: \.self) { _ in
                                    SocialMediaCardView()
                                        .safeAreaPadding(.horizontal, 20)
                                        .containerRelativeFrame(.horizontal,
                                                                count: 1,
                                                                spacing: 16)
                                }
                            }
                            .scrollTargetLayout()
                            
                        }
                        .contentMargins(16, for: .scrollContent)
                        .scrollTargetBehavior(.viewAligned)
                    }
                }
            }
        }
    }
}

struct PagingSliderView<Content: View, TitleContent: View, Item: RandomAccessCollection>: View where Item: MutableCollection, Item.Element: Identifiable {
    
    @Binding var data: Item
    @ViewBuilder var content: (Binding<Item.Element>) -> Content
    @ViewBuilder var titleContent: (Binding<Item.Element>) -> TitleContent
    
    var body: some View {
        VStack {
            if #available(iOS 17, *) {
                ScrollView(.horizontal) {
                    HStack {
                        ForEach($data) { item in
                            VStack {
                                titleContent(item)
                                    .frame(maxWidth: .infinity)
                                    .visualEffect { content, geometryProxy in
                                        content.offset(x: scrollOffset(geometryProxy))
                                    }
                                content(item)
                            }
                            .containerRelativeFrame(.horizontal)
                        }
                    }
                    .scrollTargetLayout()
                }
                .scrollIndicators(.hidden)
                .scrollTargetBehavior(.viewAligned)
                
            } else {
                Text("iOS 17 only")
            }
        }
    }
    
    func scrollOffset(_ phase: GeometryProxy) -> CGFloat {
        if #available(iOS 17, *) {
            let titleScrollSpeed: CGFloat = 0.4
            let minX = phase.bounds(of: .scrollView)?.minX ?? 0
            return -minX * min(titleScrollSpeed, 1.0)
        } else {
            return 0.0
        }
    }
}

#Preview {
    CustomPagingSliderScreen()
}
