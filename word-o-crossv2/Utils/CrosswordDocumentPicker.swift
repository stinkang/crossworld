//
//  DocumentPicker.swift
//  word-o-crossv2
//
//  Created by Austin Kang on 11/23/21.
//

import Foundation
import MobileCoreServices
import SwiftUI
import UniformTypeIdentifiers

struct CrosswordDocumentPicker: UIViewControllerRepresentable {
    
    @Binding var crossword: Crossword
    //@Binding var shouldSendCrosswordData: Bool
    
    func makeCoordinator() -> CrosswordDocumentPickerCoordinator {
        return CrosswordDocumentPickerCoordinator(crossword: $crossword/*, shouldSendCrosswordData: $shouldSendCrosswordData*/)
    }
    
    func makeUIViewController(context: UIViewControllerRepresentableContext<CrosswordDocumentPicker>) ->
    UIDocumentPickerViewController {
        let controller: UIDocumentPickerViewController
        
        if #available(iOS 14, *) {
            controller = UIDocumentPickerViewController(forOpeningContentTypes: [.json], asCopy: true)
        } else {
            controller = UIDocumentPickerViewController(documentTypes: [String(kUTTypeText)], in: .import)
        }
        controller.delegate = context.coordinator
        return controller
    }
    
    func updateUIViewController(_ uiViewController: UIDocumentPickerViewController, context: UIViewControllerRepresentableContext<CrosswordDocumentPicker>) {}
}

class CrosswordDocumentPickerCoordinator: NSObject, UIDocumentPickerDelegate, UINavigationControllerDelegate {
    
    @Binding var crossword: Crossword
    //@Binding var shouldSendCrosswordData: Bool
    
    init(crossword: Binding<Crossword>/*, shouldSendCrosswordData: Binding<Bool>*/) {
        _crossword = crossword
        //_shouldSendCrosswordData = shouldSendCrosswordData
    }
    
    func decodeCrossword(url: URL) -> Crossword? {
        do {
            let fileContent = try String(contentsOf: url, encoding: .utf8)
            print(fileContent)
            let data = try Data(contentsOf: url)
            guard let decodedCrossword = try? JSONDecoder().decode(Crossword.self, from: data) else {
                fatalError("Can't decode crossword")
            }

            return decodedCrossword
        } catch let error {
            print(error.localizedDescription)
        }

        return nil
    }
    
    func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
        crossword = decodeCrossword(url: urls[0])!
        //shouldSendCrosswordData = true
    }

    func documentPickerWasCancelled(_ controller: UIDocumentPickerViewController) {
        print("cancel")
    }
}
