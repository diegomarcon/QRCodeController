import UIKit
import AVFoundation

public class QRCodeController: UIViewController {
    
    public typealias QRCodeControllerCallback = (String) -> ()
    
    private let captureDevice = AVCaptureDevice.defaultDeviceWithMediaType(AVMediaTypeVideo)
    private lazy var captureSession = AVCaptureSession()
    private lazy var borderView = UIView()
    private var previewLayer: AVCaptureVideoPreviewLayer?
    
    public var callback: QRCodeControllerCallback?
    
    public override func viewDidLoad() {
        super.viewDidLoad()

        do {
            let input = try AVCaptureDeviceInput(device: captureDevice)
            configureCaptureSession(input)
            configurePreviewLayer()
            configureBorderView()
            captureSession.startRunning()
        } catch {
            print(error)
            return
        }
    }
    
    private func configureCaptureSession(input: AVCaptureDeviceInput) {
        captureSession.addInput(input)
        let captureMetadataOutput = AVCaptureMetadataOutput()
        captureSession.addOutput(captureMetadataOutput)
        captureMetadataOutput.setMetadataObjectsDelegate(self, queue: dispatch_get_main_queue())
        captureMetadataOutput.metadataObjectTypes = [AVMetadataObjectTypeQRCode]
    }
    
    private func configurePreviewLayer() {
        previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        previewLayer?.videoGravity = AVLayerVideoGravityResizeAspectFill
        previewLayer?.frame = view.layer.bounds
        view.layer.addSublayer(previewLayer!)
    }
    
    private func configureBorderView() {
        borderView.layer.borderColor = UIColor.greenColor().CGColor
        borderView.layer.borderWidth = 2
        view.addSubview(borderView)
        view.bringSubviewToFront(borderView)
    }
}

extension QRCodeController: AVCaptureMetadataOutputObjectsDelegate {
    
    public func captureOutput(captureOutput: AVCaptureOutput!, didOutputMetadataObjects metadataObjects: [AnyObject]!, fromConnection connection: AVCaptureConnection!) {
        
        guard metadataObjects != nil && metadataObjects.count > 0,
            let metadataObject = metadataObjects[0] as? AVMetadataMachineReadableCodeObject else {
                updateBorderViewBounds(nil)
                return
        }
        
        updateBorderViewBounds(previewLayer?.transformedMetadataObjectForMetadataObject(metadataObject))
        
        if let decodedOutput = metadataObject.stringValue {
            callback?(decodedOutput)
        }
    }
    
    private func updateBorderViewBounds(barCodeObject: AVMetadataObject?) {
        borderView.frame = barCodeObject == nil ? CGRectZero : barCodeObject!.bounds
    }
}
