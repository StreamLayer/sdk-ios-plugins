//
//  SLRPhotoLibraryDataSourceImpl.swift
//  StreamLayerPlugins
//
//  Copyright © 2024 StreamLayer, Inc. All rights reserved.
//

#if os(iOS)
import UIKit
import Photos
import StreamLayerSDK

final class SLRPhotoLibraryDataSourceImpl: NSObject, SLRPhotoLibraryDataSource, PHPhotoLibraryChangeObserver {

  weak var delegate: SLRPhotoLibraryDataSourceDelegate?

  private var fetchResult: PHFetchResult<PHAsset>?
  private let imageManager = PHCachingImageManager()
  private var fullImageRequests: [Int: SLRPhotoRequestHandleImpl] = [:]

  override init() {
    super.init()
    let options = PHFetchOptions()
    options.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: false)]
    if let userLibrary = PHAssetCollection.fetchAssetCollections(
      with: .smartAlbum, subtype: .smartAlbumUserLibrary, options: nil
    ).firstObject {
      let fetchOptions = PHFetchOptions()
      fetchOptions.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: false)]
      fetchOptions.predicate = NSPredicate(format: "mediaType = %d", PHAssetMediaType.image.rawValue)
      fetchResult = PHAsset.fetchAssets(in: userLibrary, options: fetchOptions)
    } else {
      fetchResult = PHAsset.fetchAssets(with: .image, options: options)
    }
    PHPhotoLibrary.shared().register(self)
  }

  deinit {
    PHPhotoLibrary.shared().unregisterChangeObserver(self)
  }

  var count: Int {
    return fetchResult?.count ?? 0
  }

  @discardableResult
  func requestPreviewImage(
    at index: Int,
    targetSize: CGSize,
    completion: @escaping (Result<UIImage, Error>) -> Void
  ) -> SLRPhotoRequestHandle {
    guard let asset = fetchResult?.object(at: index) else {
      let handle = SLRPhotoRequestHandleImpl(requestId: -1)
      completion(.failure(NSError(domain: "SLRPhotoLibrary", code: -1,
                                  userInfo: [NSLocalizedDescriptionKey: "Asset not found"])))
      return handle
    }

    let options = PHImageRequestOptions()
    options.deliveryMode = .opportunistic
    options.resizeMode = .fast
    options.isNetworkAccessAllowed = true

    let reqId = imageManager.requestImage(
      for: asset,
      targetSize: targetSize,
      contentMode: .aspectFill,
      options: options
    ) { image, info in
      if let image = image {
        completion(.success(image))
      } else {
        let error = (info?[PHImageErrorKey] as? Error)
          ?? NSError(domain: "SLRPhotoLibrary", code: -2,
                     userInfo: [NSLocalizedDescriptionKey: "Failed to load image"])
        completion(.failure(error))
      }
    }

    return SLRPhotoRequestHandleImpl(requestId: reqId)
  }

  @discardableResult
  func requestFullImage(
    at index: Int,
    progressHandler: ((Double) -> Void)?,
    completion: @escaping (Result<UIImage, Error>) -> Void
  ) -> SLRPhotoRequestHandle {
    guard let asset = fetchResult?.object(at: index) else {
      let handle = SLRPhotoRequestHandleImpl(requestId: -1)
      completion(.failure(NSError(domain: "SLRPhotoLibrary", code: -1,
                                  userInfo: [NSLocalizedDescriptionKey: "Asset not found"])))
      return handle
    }

    let options = PHImageRequestOptions()
    options.isNetworkAccessAllowed = true
    options.progressHandler = { progress, _, _, _ in
      DispatchQueue.main.async { progressHandler?(progress) }
    }

    let reqId = imageManager.requestImageDataAndOrientation(for: asset, options: options) { data, _, _, info in
      if let data = data, let image = UIImage(data: data) {
        completion(.success(image))
      } else {
        let error = (info?[PHImageErrorKey] as? Error)
          ?? NSError(domain: "SLRPhotoLibrary", code: -2,
                     userInfo: [NSLocalizedDescriptionKey: "Failed to load full image"])
        completion(.failure(error))
      }
    }

    let handle = SLRPhotoRequestHandleImpl(requestId: reqId)
    handle.completionHandler = completion
    handle.progressHandler = progressHandler
    fullImageRequests[index] = handle
    return handle
  }

  func fullImageRequest(at index: Int) -> SLRPhotoRequestHandle? {
    return fullImageRequests[index]
  }

  // MARK: - PHPhotoLibraryChangeObserver

  func photoLibraryDidChange(_ changeInstance: PHChange) {
    guard let fetchResult = fetchResult,
          let changes = changeInstance.changeDetails(for: fetchResult) else { return }

    DispatchQueue.main.async { [weak self] in
      guard let self = self else { return }
      self.fetchResult = changes.fetchResultAfterChanges
      self.delegate?.dataSourceDidUpdate(self) {
        // Update block for collection view batch updates
      }
    }
  }
}

// MARK: - Photo Request Handle

final class SLRPhotoRequestHandleImpl: SLRPhotoRequestHandle {
  let requestId: Int32
  var progress: Double = 0
  var completionHandler: ((Result<UIImage, Error>) -> Void)?
  var progressHandler: ((Double) -> Void)?

  init(requestId: Int32) {
    self.requestId = requestId
  }

  func observeProgress(
    with progressHandler: ((Double) -> Void)?,
    completion: ((Result<UIImage, Error>) -> Void)?
  ) {
    self.progressHandler = progressHandler
    self.completionHandler = completion
  }

  func cancel() {
    PHCachingImageManager.default().cancelImageRequest(requestId)
  }
}
#endif
