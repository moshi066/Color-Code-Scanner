//
//  MainScannerWindow.swift
//  ColorCodeScanner
//
//  Created by Moshiur Rahman on 6/14/23.
//

import SwiftUI

struct MainScannerWindow: View {
    @State var result: String = ""
    @State var shouldNavigate: Bool = false
    var body: some View {
        NavigationStack {
            VStack (spacing: 0) {
                VStack (spacing: 0){
                    Image("logo")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(height: 50)
                    
                    Text("Scan Color Code")
                        .padding(.bottom, 10)
                }
                .frame(minWidth: 0, maxWidth: .infinity)
                .background(.blue.opacity(0.15))
                
                ColorQRScanner(result: $result)
                
                NavigationLink(
                    destination: SuccessEventPage(result: $result),
                    isActive: $shouldNavigate
                ) {
                    EmptyView()
                }
            }
            .onChange(of: result) { newValue in
                shouldNavigate = !newValue.isEmpty
            }
            .navigationTitle("Scanner")
            .toolbar(.hidden)
            
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        MainScannerWindow()
    }
}
