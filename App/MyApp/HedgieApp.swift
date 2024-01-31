
import SwiftUI

@main
struct HedgieApp: App {
    @StateObject private var characterDataViewModel = CharacterDataViewModel()
    @StateObject private var skillDataViewModel = SkillDataViewModel()
    
    var body: some Scene {
        WindowGroup {
            NavigationView {
                IntroView1()
            }
            .environmentObject(characterDataViewModel)
            .environmentObject(skillDataViewModel)
        }
    }
}
