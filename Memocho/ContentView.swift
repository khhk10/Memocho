//
//  ContentView.swift
//  Memocho
//
//  Created by Kohei Ikeda on 2021/08/27.
//

import SwiftUI
import CoreData
import PartialSheet

// メモデータの構造体
struct memoData: Identifiable {
    var id = UUID()
    var title: String
    var sentence: String
}

struct CreateView: View {
    // ManagedObjectContextの取得
    @Environment(\.managedObjectContext) private var createViewContext
    
    @Binding var isPresented: Bool // アクションシートの表示/非表示
    @State var theText = """
    新しいメモ
    """
    
    var body: some View {
        NavigationView {
            TextEditor(text: $theText)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .border(Color.gray)
                .padding()
                .toolbar {
                    ToolbarItemGroup(placement: .navigationBarTrailing, content: {
                        // 完了ボタン
                        Button {
                            print("createViewContext: \(createViewContext)")
                            
                            // CoreDataにセーブする
                            let newItem = Item(context: self.createViewContext)
                            newItem.text = self.theText
                            do {
                                try createViewContext.save()
                            } catch {
                                let nsError = error as NSError
                                fatalError("unresolved error \(nsError), \(nsError.userInfo)")
                            }
                        } label: {
                            Text("完了")
                        }
                    })
                }
        }
    }
}

struct ContentView: View {
    // @State var isShow: Bool = false // アクションシート用
    @State var isSheetShow: Bool = false
    
    // ハーフモーダルビュー
    @EnvironmentObject var partialSheetManager: PartialSheetManager
    
    // ManagedObjectContextの取得
    @Environment(\.managedObjectContext) private var viewContext
    
    // データベースからデータ取得
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Item.objectID, ascending: true)],
        animation: .default)
    private var items: FetchedResults<Item>
    
    let memoList = [
        memoData(title: "晩御飯", sentence: "今日の晩御飯はカレーです"),
        memoData(title: "買い物", sentence: "スーパーで買い物は、人参とキャベツです"),
        memoData(title: "やること", sentence: "今日やることは掃除と洗濯です")
    ]
    
    // データベースに追加
    private func addItems() {
        // CoreDataにセーブする
        let newItem = Item(context: viewContext)
        newItem.text = "新規のメモ - 今日"
        
        do {
            try viewContext.save()
        } catch {
            let nsError = error as NSError
            fatalError("unresolved error \(nsError), \(nsError.userInfo)")
        }
    }
    
    // データベースから削除
    private func deleteItems(offsets: IndexSet) {
        withAnimation {
            // レコードの削除
            // offsetsには削除対象のインデックスが入っている
            // forEachで削除対象を一つずつデリート
            offsets.map { items[$0] }.forEach(viewContext.delete)
            print("レコード削除, offsets: \(offsets)")
            
            do {
                try viewContext.save()
            } catch {
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            }
        }
    }
    
    // 変更内容を保存
    func saveChange() {
        do {
            try viewContext.save()
        } catch {
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
        }
    }
    
    var body: some View {
        NavigationView {
            List {
                ForEach(items) { item in
                    NavigationLink(destination: SubView(item: item).onDisappear {
                        // SubViewから戻ってきた時に、変更内容を保存
                        saveChange()
                    }) {
                        Text("\(item.text)")
                    }
                }
                .onDelete(perform: deleteItems)
            }
            .navigationBarTitle("メモ")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        isSheetShow = true
                        // ハーフモーダルビューを表示
                        self.partialSheetManager.showPartialSheet({
                            // 閉じた時の処理
                            print("partial sheet 閉じた")
                        }) {
                            VStack {
                                // ヘッダー
                                HStack {
                                    Image(systemName: "folder.fill")
                                        .foregroundColor(.yellow)
                                        .scaleEffect(2.0)
                                        .padding(.horizontal)
                                    Text("メモ").font(.headline)
                                    Spacer()
                                    // 閉じるボタン
                                    Button {
                                        // 閉じる
                                        self.partialSheetManager.closePartialSheet()
                                    } label: {
                                        Image(systemName: "xmark.circle")
                                            .foregroundColor(.gray)
                                            .scaleEffect(1.5)
                                            .padding(.trailing)
                                    }
                                }
                                .padding()
                                // リスト
                                List {
                                    Section(content: {
                                        HStack {
                                            Text("ギャラリー表示")
                                            Spacer()
                                            Image(systemName: "square.grid.2x2")
                                                .scaleEffect(1.2)
                                        }
                                    })
                                    Section(content: {
                                        HStack {
                                            Text("メモを選択")
                                            Spacer()
                                            Image(systemName: "rectangle.badge.checkmark")
                                                .scaleEffect(1.2)
                                        }
                                        HStack {
                                            Text("メモの表示順序（デフォルト）")
                                            Spacer()
                                            Image(systemName: "arrow.up.arrow.down")
                                                .scaleEffect(1.2)
                                        }
                                        HStack {
                                            Text("添付ファイルを表示")
                                            Spacer()
                                            Image(systemName: "paperclip")
                                                .scaleEffect(1.2)
                                        }
                                    })
                                }
                                .listStyle(InsetGroupedListStyle())
                                .frame(height: 400)
                            }
                            
                        }
                    
                    } label: {
                        Image(systemName: "ellipsis.circle")
                            .scaleEffect(1.5)
                    }
                    /*
                    .sheet(isPresented: $isSheetShow, content: {
                        // ハーフビューを表示
                        TopSettingView(isPresented: $isSheetShow)
                    })
                    */
                }
                
                ToolbarItemGroup(placement: .bottomBar) {
                    // 件数表示
                    Text("\(items.count)件のメモ")
                        .frame(width: 225, alignment: .trailing)
                    Spacer()
                    
                    // 新規作成ボタン
                    
                    Button {
                        // データベースに追加
                        addItems()
                    } label: {
                        // Text("新規作成")
                        Image(systemName: "square.and.pencil")
                            .scaleEffect(1.5)
                    }
                }
            }
        } // Navigation View
        .addPartialSheet()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        // CreateView(isPresented: <#T##Bool#>)
        ContentView()
    }
}
