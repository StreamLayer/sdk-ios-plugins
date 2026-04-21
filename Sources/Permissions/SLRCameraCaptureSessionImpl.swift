//
//  SLRCameraCaptureSessionImpl.swift
//  StreamLayerPlugins
//
//  Copyright © 2024 StreamLayer, Inc. All rights reserved.
//

#if os(iOS)
import UIKit
import AVFoundation
import StreamLayerSDK

final class SLRCameraCaptureSessionImpl: SLRCameraCaptureSession {

  private(set) var previewLayer: CALayer?
  private(set) var isInitialized: Bool = false
  private(set) var isCapturing: Bool = false

  private var captureSession: AVCaptureSession?
  private let operationQueue: OperationQueue = {
    let queue = OperationQueue()
    queue.qualityOfService = .userInitiated
    queue.maxConcurrentOperationCount = 1
    return queue
  }()

  func startCapturing(_ completion: @escaping () -> Void) {
    let operation = BlockOperation()
    operation.addExecutionBlock { [weak operation, weak self] in
      guard let self = self, let strongOperation = operation, !strongOperation.isCancelled else {
        DispatchQueue.main.async(execute: completion)
        return
      }

      if !self.isInitialized {
        #if !(arch(i386) || arch(x86_64))
        let session = AVCaptureSession()
        let layer = AVCaptureVideoPreviewLayer(session: session)
        layer.videoGravity = .resizeAspectFill

        if let device = AVCaptureDevice.default(.builtInWideAngleCamera,
                                                 for: .video,
                                                 position: .unspecified) {
          do {
            let input = try AVCaptureDeviceInput(device: device)
            if session.canAddInput(input) {
              session.addInput(input)
            }
          } catch {
            // Failed to create input device
          }
        }

        self.captureSession = session
        self.previewLayer = layer
        #endif
        self.isInitialized = true
      }

      self.captureSession?.startRunning()
      self.isCapturing = true
      DispatchQueue.main.async(execute: completion)
    }
    self.operationQueue.cancelAllOperations()
    self.operationQueue.addOperation(operation)
  }

  func stopCapturing(_ completion: @escaping () -> Void) {
    let operation = BlockOperation()
    operation.addExecutionBlock { [weak operation, weak self] in
      guard let self = self, let strongOperation = operation, !strongOperation.isCancelled else {
        DispatchQueue.main.async(execute: completion)
        return
      }

      self.captureSession?.stopRunning()
      self.captureSession?.inputs.forEach { self.captureSession?.removeInput($0) }
      self.isCapturing = false
      DispatchQueue.main.async(execute: completion)
    }
    self.operationQueue.cancelAllOperations()
    self.operationQueue.addOperation(operation)
  }

  deinit {
    var layer = self.previewLayer
    layer?.removeFromSuperlayer()
    var session: AVCaptureSession? = self.isInitialized ? self.captureSession : nil
    DispatchQueue.global(qos: .default).async {
      if layer != nil { layer = nil }
      if session != nil { session = nil }
    }
  }
}
#endif
