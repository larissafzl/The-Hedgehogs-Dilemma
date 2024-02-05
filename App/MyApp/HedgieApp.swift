
import SwiftUI

@main
struct HedgieApp: App {
    @StateObject private var characterDataViewModel = CharacterDataViewModel()
    @StateObject private var skillDataViewModel = SkillDataViewModel()
    @State private var currentIndex = 0
    
    var body: some Scene {
        WindowGroup {
            NavigationView {
                InitialMenu(currentIndex: $currentIndex)
                    .onAppear {
                        // Print initial value when the view appears
                        print("Initial Index: \(currentIndex)")
                    }
                    .onChange(of: currentIndex) { newIndex in
                        // Print whenever currentIndex changes
                        print("Current Index: \(newIndex)")
                    }
            }
            .environmentObject(characterDataViewModel)
            .environmentObject(skillDataViewModel)
        }
    }
}
