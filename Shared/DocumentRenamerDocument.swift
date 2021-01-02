//
//  DocumentRenamerDocument.swift
//  Shared
//
//  Created by Steven Hovater on 12/29/20.
//

import SwiftUI
import UniformTypeIdentifiers

extension UTType {
    static var exampleText: UTType {
        UTType(importedAs: "com.example.plain-text")
    }
}

struct DocumentRenamerDocument: FileDocument {
    var text: String

    init(text: String = "Hello, world!") {
        self.text = text
    }

    static var readableContentTypes: [UTType] { [.exampleText] }

    init(configuration: ReadConfiguration) throws {
        guard let data = configuration.file.regularFileContents,
              let string = String(data: data, encoding: .utf8)
        else {
            throw CocoaError(.fileReadCorruptFile)
        }
        text = string
    }
    
    func fileWrapper(configuration: WriteConfiguration) throws -> FileWrapper {
        let data = text.data(using: .utf8)!
        return .init(regularFileWithContents: data)
    }
}

class FileMover: NSObject {
    func moveFile(originalURL: URL, updatedURL:URL) -> Bool {
        let coordinator = NSFileCoordinator(filePresenter: nil)
        var writingError: NSError? = nil
        var success : Bool = true
        print("moving file")
        coordinator.coordinate(writingItemAt: originalURL, options: NSFileCoordinator.WritingOptions.forMoving, error: &writingError, byAccessor: { (coordinatedURL) in
            do {
                coordinator.item(at: originalURL, willMoveTo: coordinatedURL)
                try FileManager.default.moveItem(at: coordinatedURL, to: updatedURL)
                coordinator.item(at: originalURL, didMoveTo: coordinatedURL)

                success = true
                print("file moved")
                
            } catch {
                
                success = false
            }
        })
    return success
        
    }
}

