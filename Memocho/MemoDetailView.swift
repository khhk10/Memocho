//
//  MemoDetailView.swift
//  Memocho
//
//  Created by Kohei Ikeda on 2021/08/27.
//

import SwiftUI

extension UIApplication {
    // キーボードを下げる
    func endEditing() {
        sendAction(
            #selector(UIResponder.resignFirstResponder),
            to: nil, from: nil, for: nil
        )
    }
}

// データを読み込み
func loadText(_ fileName: String) -> String? {
    // アンラップしてurlに代入
    guard let url = docURL(fileName) else {
        return nil
    }
    // URLから読み込み
    do {
        let textData = try String(contentsOf: url, encoding: .utf8)
        return textData
    } catch {
        return nil
    }
}

// データを保存
func saveText(_ textData:String, _ fileName:String) {
    // アンラップしてurlに代入
    guard let url = docURL(fileName) else {
        return
    }
    // ファイルパスへの保存
    do {
        let path = url.path
        try textData.write(toFile: path, atomically: true, encoding: .utf8)
    } catch {
        print(error)
    }
}

// 保存先のURLを生成
func docURL(_ fileName:String) -> URL? {
    let fileManager = FileManager.default
    do {
        // Documentsフォルダ
        let docsUrl = try fileManager.url(
            for: .documentDirectory,
            in: .userDomainMask,
            appropriateFor: nil,
            create: false
        )
        // URLを作る
        let url = docsUrl.appendingPathComponent(fileName)
        return url
    } catch {
        return nil
    }
}

struct MemoDetailView: View {
    @State var sentence: String
    /*
    @State var theText: String = """
    春はあけぼの。やうやう白くなり行く、山ぎは少しあかりて、紫だちたる雲の細くたなびきたる。
    冬はつとめて。雪の降りたるはいふべきにもあらず。
    """
    */
    
    var body: some View {
        TextEditor(text: $sentence)
            .lineSpacing(10)
            .border(Color.gray)
            .padding(.horizontal)
            .toolbar {
                // トップ左
                ToolbarItemGroup(placement: .navigationBarLeading) {
                    // 読み込みボタン
                    Button {
                        if let data = loadText("sample.txt") {
                            sentence = data
                        }
                    } label: {
                        Text("読み込み")
                    }
                    Spacer()
                    // 保存ボタン
                    Button {
                        UIApplication.shared.endEditing()
                        saveText(sentence, "sample.txt")
                    } label: {
                        Text("保存")
                    }
                }
                // トップ右
                ToolbarItem(placement: .navigationBarTrailing) {
                    Image(systemName: "ellipsis.circle")
                        .scaleEffect(1.5)
                }
                // ボトム
                ToolbarItemGroup(placement: .bottomBar) {
                    Image(systemName: "checkmark.circle")
                        .scaleEffect(1.5)
                    Spacer()
                    Image(systemName: "camera")
                        .scaleEffect(1.5)
                    Spacer()
                    Image(systemName: "pencil.tip.crop.circle")
                        .scaleEffect(1.5)
                    Spacer()
                    Image(systemName: "square.and.pencil")
                        .scaleEffect(1.5)
                }
            }
    }
}

struct MemoDetailView_Previews: PreviewProvider {
    static var previews: some View {
        MemoDetailView(sentence: "今日の晩御飯はカレーです")
    }
}
