//
//  SuccessEventPage.swift
//  ColorCodeScanner
//
//  Created by Moshiur Rahman on 6/14/23.
//

import SwiftUI
import UIKit

struct SuccessEventPage: View {
    @Binding var result: String
    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                Text(result)
                    .multilineTextAlignment(.leading)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(10)
                
                Spacer()
                Button("Copy to clipboard") {
                    UIPasteboard.general.string = result
                }
            }
            .onDisappear {
                result = ""
            }
            .navigationTitle("Result")
            .navigationBarTitleDisplayMode(.inline)
            .toolbarBackground(.blue.opacity(0.15), for: .navigationBar)
            .toolbarBackground(.visible, for: .navigationBar)
            .toolbar {
                ToolbarItem(placement: .automatic) {
                    HStack {
                        Image("logo")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(height: 40)
                    }
                    
                }
            }
        }
    }
}

struct SuccessEventPage_Previews: PreviewProvider {
    static var previews: some View {
        SuccessEventPage(result: .constant("Data"))
    }
}
