//
//  SplashScreen.swift
//  ColorCodeScanner
//
//  Created by Moshiur Rahman on 6/16/23.
//

import SwiftUI

struct SplashScreen: View {
    var body: some View {
        Image("splash_screen_image")
            .resizable()
            .aspectRatio(contentMode: .fit)
    }
}

struct SplashScreen_Previews: PreviewProvider {
    static var previews: some View {
        SplashScreen()
    }
}
