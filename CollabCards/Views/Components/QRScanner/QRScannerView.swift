//
//  QRScannerView.swift
//  CollabCards
//
//  Created by FFK on 31.07.2024.
//

import SwiftUI
import AVFoundation
import FirebaseCrashlytics

struct QRScannerView: UIViewControllerRepresentable {
    // MARK: - Properties
    
    @Binding var scannedCode: String
    @Environment(\.presentationMode) var presentationMode
    
    // MARK: - Coordinator
    
    class Coordinator: NSObject, AVCaptureMetadataOutputObjectsDelegate {
        var parent: QRScannerView

        init(parent: QRScannerView) {
            self.parent = parent
        }

        func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
            if let metadataObject = metadataObjects.first {
                guard let readableObject = metadataObject as? AVMetadataMachineReadableCodeObject else { return }
                guard let stringValue = readableObject.stringValue else { return }
                AudioServicesPlaySystemSound(SystemSoundID(kSystemSoundID_Vibrate))
                DispatchQueue.main.async {
                    self.parent.scannedCode = stringValue
                    Crashlytics.log("QR code successfully scanned: \(stringValue)")
                    self.parent.presentationMode.wrappedValue.dismiss()
                }
            }
        }
    }

    // MARK: - Coordinator Creation
    
    func makeCoordinator() -> Coordinator {
        return Coordinator(parent: self)
    }

    // MARK: - UIViewControllerRepresentable
    
    func makeUIViewController(context: Context) -> UIViewController {
        let viewController = UIViewController()

        let captureSession = AVCaptureSession()
        guard let videoCaptureDevice = AVCaptureDevice.default(for: .video) else {
            Crashlytics.log("Failed to get the camera device")
            return viewController }
        let videoInput: AVCaptureDeviceInput

        do {
            videoInput = try AVCaptureDeviceInput(device: videoCaptureDevice)
        } catch {
            Crashlytics.log("Failed to create AVCaptureDeviceInput: \(error.localizedDescription)")
            return viewController
        }

        if captureSession.canAddInput(videoInput) {
            captureSession.addInput(videoInput)
        } else {
            Crashlytics.log("Failed to add input to capture session")
            return viewController
        }

        let metadataOutput = AVCaptureMetadataOutput()

        if captureSession.canAddOutput(metadataOutput) {
            captureSession.addOutput(metadataOutput)

            metadataOutput.setMetadataObjectsDelegate(context.coordinator, queue: DispatchQueue.main)
            metadataOutput.metadataObjectTypes = [.qr]
        } else {
            Crashlytics.log("Failed to add output to capture session")
            return viewController
        }

        let previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        previewLayer.frame = viewController.view.layer.bounds
        previewLayer.videoGravity = .resizeAspectFill
        viewController.view.layer.addSublayer(previewLayer)

        captureSession.startRunning()

        return viewController
    }

    func updateUIViewController(_ uiViewController: UIViewController, context: Context) {}
}

#Preview {
    QRScannerView(scannedCode: .constant(""))
}
