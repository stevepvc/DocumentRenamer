//
//  DocumentRenamerApp.swift
//  Shared
//
//  Created by Steven Hovater on 12/29/20.
//

import SwiftUI

@main
struct DocumentRenamerApp: App {
    var body: some Scene {
        DocumentGroup(newDocument: DocumentRenamerDocument()) { file in
            
            let fileURL = file.fileURL!
            let filename = fileURL.deletingPathExtension().lastPathComponent
            ContentView(document: file.$document, showingFilename: false, filename: filename, fileurl: fileURL)
        }
    }
}
