//
//  DirectoryViewController.swift
//  kaganinaSHHUM
//
/*
import Foundation
import UIKit

final class DirectoryViewController: UIViewController, UIDocumentPickerDelegate {
    
    var chosenDirectoryURL: URL?
    
    func getDocumentsDirectory() -> URL {
        let documentPicker = UIDocumentPickerViewController(forOpeningContentTypes: [.folder])
        documentPicker.directoryURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first

        documentPicker.delegate = self

        UIApplication.shared.windows.first?.rootViewController?.present(documentPicker, animated: true)

        while chosenDirectoryURL == nil {
            RunLoop.current.run(mode: .default, before: Date(timeIntervalSinceNow: 0.1))
        }

        return chosenDirectoryURL!
    }
    
    func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
        if let url = urls.first?.deletingLastPathComponent() {
            chosenDirectoryURL = url
        }
    }
}*/
