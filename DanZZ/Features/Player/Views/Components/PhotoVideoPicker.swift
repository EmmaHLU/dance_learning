//
//  PhotoVideoPicker.swift
//  DanZZ
//
//  Created by Hong Lu on 28/11/2025.
//

import Foundation
import SwiftUI
import PhotosUI

struct PhotoVideoPicker: UIViewControllerRepresentable {
    @Binding var isPresented: Bool
    var completion: (URL?) -> Void

    func makeUIViewController(context: Context) -> PHPickerViewController {
        var configuration = PHPickerConfiguration()
        configuration.selectionLimit = 1
        configuration.filter = .videos

        let picker = PHPickerViewController(configuration: configuration)
        picker.delegate = context.coordinator
        return picker
    }

    func updateUIViewController(_ uiViewController: PHPickerViewController, context: Context) {}

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    class Coordinator: NSObject, PHPickerViewControllerDelegate {
        var parent: PhotoVideoPicker

        init(_ parent: PhotoVideoPicker) {
            self.parent = parent
        }

        func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
            parent.isPresented = false

            guard let itemProvider = results.first?.itemProvider,
                  itemProvider.hasItemConformingToTypeIdentifier(UTType.movie.identifier) else {
                parent.completion(nil)
                return
            }
            
            itemProvider.loadFileRepresentation(forTypeIdentifier: UTType.movie.identifier) { url, error in
                guard let url = url else {
                    self.parent.completion(nil)
                    return
                }
                
                let uniqueFileName = UUID().uuidString + ".MP4"
                let appDocumentsPath = FileManager.default.temporaryDirectory.appendingPathComponent(uniqueFileName)
                
                do {
                    if FileManager.default.fileExists(atPath: appDocumentsPath.path) {
                        try FileManager.default.removeItem(at: appDocumentsPath)
                    }
                    try FileManager.default.copyItem(at: url, to: appDocumentsPath)
                    
                    DispatchQueue.main.async {
                        self.parent.completion(appDocumentsPath)
                    }
                } catch {
                    print("Error copying file: \(error)")
                    DispatchQueue.main.async {
                        self.parent.completion(nil)
                    }
                }
            }
        }
    }
}
