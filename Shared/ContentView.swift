//
//  ContentView.swift
//  Shared
//
//  Created by Steven Hovater on 12/29/20.
//

import SwiftUI

struct ContentView: View {
    @Binding var document: DocumentRenamerDocument
    @State var showingFilename = true
    @State var filename = "string"
    @State var fileurl: URL
    
    var body: some View {
        VStack{
            if showingFilename{
                HStack{
                TextField("Title", text: $filename).animation(.easeIn)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .multilineTextAlignment(.center)
                
                    Button(action: { changeFilename()
                        
                    }) {
                        Text("Rename")
                    }
                }.padding()
                
             Divider()
            }
            TextEditor(text: $document.text).frame(minHeight:50, maxHeight: 50)
            Spacer()
        }.navigationBarItems(trailing:
                                Button(action: {
                                                    self.showingFilename.toggle()
                                                }) {
                                    Image( systemName: showingFilename ? "pencil.slash" :  "square.and.pencil" ).accentColor(showingFilename ? .red : .blue)
                                                }
                            )
        .navigationBarTitle(filename)
                            
        .animation(.easeInOut(duration: 0.5))
    }
    func changeFilename(){
    
        let target  = getTargetURL()
        var rv = URLResourceValues()
        let newFileName = target.deletingPathExtension().lastPathComponent
        rv.name = newFileName
        
//        let mover = FileMover()
//        let moved = mover.moveFile(originalURL: fileurl, updatedURL: target)
//        print("moved?\(moved)")
        do {
            if fileurl.startAccessingSecurityScopedResource(){
                //try fileurl.setResourceValues(rv)
                try FileManager.default.copyItem(at: fileurl, to: target)
                fileurl.stopAccessingSecurityScopedResource()
            }
        } catch {
            print("Error:\(error)")
        }
    }
    func getTargetURL() -> URL {
        let baseURL  =  self.fileurl.deletingLastPathComponent()
        
        print("filename: \(self.filename)")
        print("fileURL: \(self.fileurl)")
        print("BaseURL: \(baseURL)")
        var target = URL(fileURLWithPath: baseURL.path + "/\(filename).exampletext")

        var nameSuffix = 1
        
        while (target as NSURL).checkPromisedItemIsReachableAndReturnError(nil) {
            
            target = URL(fileURLWithPath: baseURL.path + "/\(filename)-\(nameSuffix).exampletext")
            print("Checking: \(target)")
            nameSuffix += 1
       }
        print("Available Target: \(target)")

        return target
    }
    
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(document: .constant(DocumentRenamerDocument()), fileurl: URL(string: "Filename.plain-text")!)
    }
}
