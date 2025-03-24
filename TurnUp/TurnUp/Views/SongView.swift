//
//  SongView 2.swift
//  TurnUp
//
//  Created by Yordan Markov on 24.03.25.
//
 
import SwiftUI

public struct SongView: View {
    @StateObject private var viewModel = SongViewModel()

    public var body: some View {
        ZStack {
            Image("Background-light")
                .resizable()
                .scaledToFill()
                .ignoresSafeArea()

            Text(viewModel.currentTime)
                .foregroundColor(.black)
                .bold()
                .font(.system(size: 90, weight: .bold, design: .default))
                .padding(.top, -375)

            RoundedRectangle(cornerRadius: 25, style: .continuous)
                .fill(.ultraThinMaterial)
                .frame(width: 350, height: 500)
                .overlay(
                    RoundedRectangle(cornerRadius: 20, style: .continuous)
                        .stroke(Color.white.opacity(0.2), lineWidth: 1)
                )

            Image(viewModel.currentSong.imageName)
                .resizable()
                .frame(width: 270, height: 270)
                .cornerRadius(20)
                .padding(.top, -150)

            Text(viewModel.currentSong.artist)
                .foregroundColor(.black)
                .bold()
                .font(.system(size: 15, weight: .bold, design: .default))
                .padding(.top, 170)
            
            Text(viewModel.currentSong.name)
                .foregroundColor(.black)
                .bold()
                .font(.system(size: 48, weight: .bold, design: .default))
                .padding(.top, 260)

            
            CustomSlider()
                .environmentObject(viewModel)
                .padding(.top, 50)
        }
        
        .contentShape(Rectangle())
        .gesture(
            TapGesture().onEnded {
                viewModel.togglePlayPause()
            }
        )
        
        .gesture(
            DragGesture().onEnded { value in
                if value.translation.width < -50 {
                    viewModel.nextSong()
                } else if value.translation.width > 50 {
                    viewModel.previousSong()
                }
            }
        )
    }
}

#Preview {
    SongView()
}
