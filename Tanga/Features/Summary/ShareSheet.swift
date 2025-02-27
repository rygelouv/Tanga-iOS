//
//  ShareSheet.swift
//  Tanga
//
//  Created by Rygel Louv on 27/02/2025.
//

import SwiftUI

let baseWebUrl = "https://tanga-web-app--tanga-d571c.us-central1.hosted.app/summary-details/"

struct ShareSheet: UIViewControllerRepresentable {
    let shareSummaryId: String
    let shareImageURL: URL

    func makeUIViewController(context: Context) -> UIActivityViewController {
        let shareURL = URL(string: "\(baseWebUrl)\(shareSummaryId)")!
        let placeholderController = UIActivityViewController(activityItems: [shareURL], applicationActivities: nil)

        downloadImage { image in
            let items: [Any] = image != nil ? [shareURL, image!] : [shareURL]
            DispatchQueue.main.async {
                let controller = UIActivityViewController(activityItems: items, applicationActivities: nil)
                context.coordinator.present(controller)
            }
        }

        return placeholderController // Placeholder while downloading
    }

    func updateUIViewController(_ uiViewController: UIActivityViewController, context: Context) {}

    func downloadImage(completion: @escaping (UIImage?) -> Void) {
        URLSession.shared.dataTask(with: shareImageURL) { data, response, error in
            if let data = data, let image = UIImage(data: data) {
                completion(image)
            } else {
                print("Image download failed: \(error?.localizedDescription ?? "Unknown error")")
                completion(nil)
            }
        }.resume()
    }

    func makeCoordinator() -> Coordinator {
        return Coordinator()
    }

    class Coordinator {
        func present(_ controller: UIActivityViewController) {
            if let topVC = UIApplication.shared.windows.first?.rootViewController {
                topVC.present(controller, animated: true)
            }
        }
    }
}

