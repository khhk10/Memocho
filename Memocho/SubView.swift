//
//  SubView.swift
//  Memocho
//
//  Created by Kohei Ikeda on 2021/09/14.
//

import SwiftUI
import PartialSheet

struct SubView: View {
    @ObservedObject var item: Item
    // @Binding var text: String
    
    @EnvironmentObject var partialSheetManager: PartialSheetManager
    
    var body: some View {
        NavigationView {
            // Text(item.text)
            // Text("\(item.objectID)")
            TextEditor(text: $item.text)
                .padding()
        }
        .toolbar {
            ToolbarItemGroup(placement: .navigationBarTrailing) {
                // 設定ボタン
                Button {
                    self.partialSheetManager.showPartialSheet({
                        // 閉じた時の処理
                        print("partial sheet 閉じた in SubView")
                    }) {
                        VStack {
                            HStack {
                                Rectangle()
                                    .fill(Color.blue)
                                    .frame(width: 80, height: 80)
                                    .cornerRadius(5.0)
                                
                                Spacer()
                                Rectangle()
                                    .fill(Color.blue)
                                    .frame(width: 80, height: 80)
                                    .cornerRadius(5.0)
                                
                                VStack {
                                    Image(systemName: "doc.text.viewfinder")
                                    Text("スキャン")
                                }
                                .background(Color.white)
                                .frame(width: 80, height: 80)
                                .cornerRadius(2.0)
                                Spacer()
                                VStack {
                                    Image(systemName: "pin.fill")
                                    Text("ピンで固定")
                                }
                                .frame(width: 60, height: 60)
                                Spacer()
                                VStack {
                                    Image(systemName: "lock.fill")
                                    Text("ロック")
                                }
                                .frame(width: 60, height: 60)
                                Spacer()
                                VStack {
                                    Image(systemName: "trash.fill")
                                    Text("削除")
                                }
                                .frame(width: 60, height: 60)
                            }
                            .background(Color.gray)
                            .frame(height: 100)
                            
                            List {
                                Section {
                                    Text("コピーを送信")
                                }
                                Section {
                                    Text("メモを検索")
                                    Text("メモを移動")
                                    Text("罫線と方眼")
                                }
                            }
                        }
                        .listStyle(InsetGroupedListStyle())
                        .frame(height: 500)
                    }
                } label: {
                    Image(systemName: "ellipsis.circle")
                }
                // 完了ボタン
                Button {
                } label: {
                    Text("完了")
                }
            }
            ToolbarItemGroup(placement: .bottomBar) {
                // リストボタン
                Button {
                } label: {
                    Image(systemName: "checkmark.circle")
                }
                Spacer()
                // カメラボタン
                Button {
                } label: {
                    Image(systemName: "camera")
                }
                Spacer()
                // ペンボタン
                Button {
                } label: {
                    Image(systemName: "pencil.tip.crop.circle")
                }
                Spacer()
                // 新規作成ボタン
                Button {
                } label: {
                    Image(systemName: "square.and.pencil")
                }
                
            }
        }
    }
}

struct SubView_Previews: PreviewProvider {
    static var previews: some View {
        SubView(item: Item())
    }
}
