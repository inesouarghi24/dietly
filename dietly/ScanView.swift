import SwiftUI
import AVFoundation

struct ScanView: UIViewControllerRepresentable {
    @Binding var scannedBarcode: String

    class Coordinator: NSObject, AVCaptureMetadataOutputObjectsDelegate {
        var parent: ScanView

        init(parent: ScanView) {
            self.parent = parent
        }

        func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
            if let metadataObject = metadataObjects.first {
                guard let readableObject = metadataObject as? AVMetadataMachineReadableCodeObject else { return }
                guard let stringValue = readableObject.stringValue else { return }
                AudioServicesPlaySystemSound(SystemSoundID(kSystemSoundID_Vibrate))
                parent.scannedBarcode = stringValue
            }
        }
    }

    func makeCoordinator() -> Coordinator {
        return Coordinator(parent: self)
    }

    func makeUIViewController(context: Context) -> UIViewController {
        let viewController = UIViewController()
        let captureSession = AVCaptureSession()

        guard let videoCaptureDevice = AVCaptureDevice.default(for: .video) else { return viewController }
        let videoInput: AVCaptureDeviceInput

        do {
            videoInput = try AVCaptureDeviceInput(device: videoCaptureDevice)
        } catch {
            return viewController
        }

        if (captureSession.canAddInput(videoInput)) {
            captureSession.addInput(videoInput)
        } else {
            return viewController
        }

        let metadataOutput = AVCaptureMetadataOutput()

        if (captureSession.canAddOutput(metadataOutput)) {
            captureSession.addOutput(metadataOutput)

            metadataOutput.setMetadataObjectsDelegate(context.coordinator, queue: DispatchQueue.main)
            metadataOutput.metadataObjectTypes = [.ean13, .ean8, .upce]
        } else {
            return viewController
        }

        let previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        previewLayer.frame = viewController.view.layer.bounds
        previewLayer.videoGravity = .resizeAspectFill
        viewController.view.layer.addSublayer(previewLayer)
        
        let guideView = UIView()
        guideView.layer.borderColor = UIColor.red.cgColor
        guideView.layer.borderWidth = 3
        guideView.translatesAutoresizingMaskIntoConstraints = false
        viewController.view.addSubview(guideView)
        
        NSLayoutConstraint.activate([
            guideView.centerXAnchor.constraint(equalTo: viewController.view.centerXAnchor),
            guideView.centerYAnchor.constraint(equalTo: viewController.view.centerYAnchor),
            guideView.widthAnchor.constraint(equalToConstant: 250),
            guideView.heightAnchor.constraint(equalToConstant: 100)
        ])
        

        DispatchQueue.global(qos: .userInitiated).async {
            captureSession.startRunning()
        }

        return viewController
    }

    func updateUIViewController(_ uiViewController: UIViewController, context: Context) {
    }
}
