//
//  TopSettingView.swift
//  Memocho
//
//  Created by Kohei Ikeda on 2021/09/17.
//

import SwiftUI

struct TopSettingView: View {
    @Binding var isPresented: Bool
    
    var body: some View {
        ZStack {
            Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
        }
    }
}

struct TopSettingView_Previews: PreviewProvider {
    static var previews: some View {
        TopSettingView(isPresented: Binding.constant(false))
    }
}
