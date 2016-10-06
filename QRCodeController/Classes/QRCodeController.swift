import UIKit
import AVFoundation
import AudioToolbox

open class QRCodeController: UIViewController {
    
    public typealias QRCodeControllerCallback = (String) -> ()
    
    private let captureDevice = AVCaptureDevice.defaultDevice(withMediaType: AVMediaTypeVideo)
    private lazy var captureSession = AVCaptureSession()
    fileprivate lazy var borderView = UIView()
    fileprivate var previewLayer: AVCaptureVideoPreviewLayer?
    
    open var callback: QRCodeControllerCallback?
    open var borderColor = UIColor.green
    open var borderWidth: CGFloat = 2
    open var vibrate = true
    open var closeAfterCapture = true
    open var suppotedMetadataObjectTypes = [AVMetadataObjectTypeQRCode]
    
    fileprivate var decodedOutput: String? {
        didSet {
            if let newValue = decodedOutput {
                if newValue != oldValue {
                    decodedString(newValue)
                }
            }
        }
    }
    
    private func decodedString(_ string: String) {
        print("QRCodeController decoded string: \(string)")
        callback?(string)
        
        if vibrate {
            AudioServicesPlayAlertSound(SystemSoundID(kSystemSoundID_Vibrate))
        }

        if closeAfterCapture {
            dismiss(animated: true, completion: nil)
        }
    }
    
    open override func viewDidLoad() {
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
    
    private func configureCaptureSession(_ input: AVCaptureDeviceInput) {
        captureSession.addInput(input)
        let captureMetadataOutput = AVCaptureMetadataOutput()
        captureSession.addOutput(captureMetadataOutput)
        captureMetadataOutput.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
        captureMetadataOutput.metadataObjectTypes = suppotedMetadataObjectTypes
    }
    
    private func configurePreviewLayer() {
        previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        previewLayer?.videoGravity = AVLayerVideoGravityResizeAspectFill
        previewLayer?.frame = view.layer.bounds
        view.layer.addSublayer(previewLayer!)
    }
    
    private func configureBorderView() {
        borderView.layer.borderColor = borderColor.cgColor
        borderView.layer.borderWidth = borderWidth
        view.addSubview(borderView)
        view.bringSubview(toFront: borderView)
    }
}

extension QRCodeController: AVCaptureMetadataOutputObjectsDelegate {
    
    public func captureOutput(_ captureOutput: AVCaptureOutput!, didOutputMetadataObjects metadataObjects: [Any]!, from connection: AVCaptureConnection!) {
        
        guard metadataObjects != nil && metadataObjects.count > 0,
            let metadataObject = metadataObjects[0] as? AVMetadataMachineReadableCodeObject else {
                updateBorderViewBounds(nil)
                return
        }
        
        updateBorderViewBounds(previewLayer?.transformedMetadataObject(for: metadataObject))
        decodedOutput = metadataObject.stringValue
    }
    
    private func updateBorderViewBounds(_ barCodeObject: AVMetadataObject?) {
        borderView.frame = barCodeObject == nil ? CGRect.zero : barCodeObject!.bounds
    }
}
