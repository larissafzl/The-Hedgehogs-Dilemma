//
//  IntroView.swift
//  
//
//  Created by Larissa Fazolin on 02/02/24.
//

import SwiftUI

class IntroState: ObservableObject {
    @Published var currentIndex: Int = 0
}

// MARK: - FirstIntroPart

struct FirstIntroPart: View {
    @Binding var currentIndex: Int

    init(currentIndex: Binding<Int>) {
        _currentIndex = currentIndex
        UINavigationBar.setAnimationsEnabled(false)
    }

    var body: some View {
        ZStack {
            LightBackground()
            ContentView(currentIndex: $currentIndex)
        }
        .navigationBarBackButtonHidden(true)
        .onAppear {
            // Check if the current sound is lightningSoundtrack
            if SoundManager.instance.currentSoundIs(.lightningSoundtrack) {
                // If the current sound is lightningSoundtrack, stop it and play the gameSoundtrack
                SoundManager.instance.stopCurrentSound()
                playGameSound(volume: 1)
            }
        }
    }

    func playGameSound(volume: Float) {
        SoundManager.instance.playSound(sound: .gameSoundtrack, volume: volume) { error in
            if let error = error {
                print("Error playing sound: \(error.localizedDescription)")
            } else {
                print("Sound played successfully")
            }
        }
    }
}




struct ContentView: View {
    @Binding var currentIndex: Int

    var body: some View {
        VStack(spacing: 32) {
            Spacer()
            GetCharacterImage(currentIndex: $currentIndex, imageName: content[currentIndex].imageName)
            TextBoxIntroView1(currentIndex: $currentIndex)
            Spacer()
        }
    }
}

// MARK: - SecondIntroPart

struct SecondIntroPart: View {
    @Binding var currentIndex: Int
    
    var body: some View {
        ZStack {
            RainyBackground()
            SecondContentView(currentIndex: $currentIndex)
        }
        .navigationBarBackButtonHidden(true)
    }
}

struct SecondContentView: View {
    @Binding var currentIndex: Int
    @State private var shake = false
    @State private var jumpUp = false
    @State private var didAppear = false

    var body: some View {
        VStack(spacing: 32) {
            Spacer()
            HStack(spacing: 32) {
                CharacterImage(imageName: "shockedHedge")
                    .rotationEffect(Angle(degrees: shake ? -2 : 2))
                    .onChange(of: didAppear) { _ in
                        withAnimation(Animation.easeInOut(duration: 0.05).repeatForever(autoreverses: true)) {
                            self.shake.toggle()
                        }
                    }
                    .onAppear {
                        didAppear = true
                    }
                
                BattleBalloon()
                
                CharacterImage(imageName: "hiOtter")
                    .offset(y: jumpUp ? -5 : 5)
                    .onChange(of: didAppear) { _ in
                        withAnimation(Animation.easeInOut(duration: 0.1).repeatForever(autoreverses: true)) {
                            self.jumpUp.toggle()
                        }
                    }
                    .onAppear {
                        didAppear = true
                        playBattleSound(volume: 0.5, numberOfLoops: -1)
                    }
            }
            TextBoxIntroView2(currentIndex: $currentIndex)
            Spacer()
        }
    }
    
    func playBattleSound(volume: Float, numberOfLoops: Int) {
        SoundManager.instance.playSound(sound: .battleSoundtrack, volume: volume, numberOfLoops: numberOfLoops) { error in
            if let error = error {
                print("Error playing sound: \(error.localizedDescription)")
            } else {
                print("Sound played successfully")
            }
        }
    }
}


// MARK: - HedgiesIntro

struct HedgiesIntro: View {
    @Binding var currentIndex: Int
    @State private var isActive: Bool = false
    @State private var shake = false

    var body: some View {
        ZStack {
            RainyBackground()

            Image("shockedHedge")
                .resizable()
                .scaledToFit()
                .frame(width: 300, height: 300)
                .rotationEffect(Angle(degrees: shake ? -0 : 0))
                .onAppear() {
                    withAnimation(Animation.easeInOut(duration: 0.08).repeatForever(autoreverses: true)) {
                        self.shake.toggle()
                    }
                    
                    playLightningSound(volume: 0.8)

                    DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                        currentIndex = (currentIndex + 1) % content.count
                        isActive = true
                    }
                }
                .navigationBarBackButtonHidden(true)
                .background(
                    NavigationLink(
                        destination: FirstIntroPart(currentIndex: $currentIndex),
                        isActive: $isActive
                    ) {
                        EmptyView()
                    }
                    .hidden()
                )
        }
    }

    func playLightningSound(volume: Float) {
        SoundManager.instance.playSound(sound: .lightningSoundtrack, volume: volume) { error in
            if let error = error {
                print("Error playing sound: \(error.localizedDescription)")
            } else {
                print("Sound played successfully")
            }
        }
    }
}

struct EnemysIntro: View {
    @Binding var currentIndex: Int
    @State private var isActive: Bool = false
    @State private var jumpUp = false
    @State private var didAppear = false
    
    var body: some View {
        ZStack {
            RainyBackground()
            
            VStack(spacing: 32) {
                Spacer()
                
                Image("hiOtter")
                    .resizable()
                    .scaledToFill()
                    .frame(width: 210, height: 195)
                    .offset(y: jumpUp ? -5 : 5)
                    .onChange(of: didAppear) { _ in                        withAnimation(Animation.easeInOut(duration: 0.1).repeatForever(autoreverses: true)) {
                            self.jumpUp.toggle()
                            
                            playLightningSound(volume: 0.8)
                            
                            DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                                currentIndex = (currentIndex + 1) % content.count
                                isActive = true
                            }
                        }
                    }
                    .onAppear {
                        didAppear = true
                    }
                
                TextBoxView()
                    .overlay(
                        HStack {
                            Text("Otty, the friendly friend").italic()
                            Text("has appeared!")
                        }
                        .font(Font.custom("GillSans", size: 20))
                    )
                Spacer()
            }
        }
        .navigationBarBackButtonHidden(true)
        .background(
            NavigationLink(
                destination: SecondIntroPart(currentIndex: $currentIndex),
                isActive: $isActive
            ) {
                EmptyView()
            }
            .hidden()
        )
    }
    
    func playLightningSound(volume: Float) {
        SoundManager.instance.playSound(sound: .lightningSoundtrack, volume: volume) { error in
            if let error = error {
                print("Error playing sound: \(error.localizedDescription)")
            } else {
                print("Sound played successfully")
            }
        }
    }
}
