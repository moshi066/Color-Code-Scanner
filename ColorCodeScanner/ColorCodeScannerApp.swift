//
//  ColorCodeScannerApp.swift
//  ColorCodeScanner
//
//  Created by Moshiur Rahman on 6/13/23.
//

import SwiftUI

@main
struct ColorCodeScannerApp: App {
    @State var isShowingSplash: Bool = true
    var body: some Scene {
        WindowGroup {
            if isShowingSplash {
                SplashScreen()
                    .onAppear {
                        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                            isShowingSplash = false
                        }
                    }
            } else {
                MainScannerWindow()
            }
        }
    }
}
