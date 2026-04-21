//
//  SLRPermissionsPlugin.swift
//  StreamLayerPlugins
//
//  Created by Vadim Vitvitskii on 21.04.2026.
//

#if os(iOS)
import Foundation
import StreamLayerSDK

public final class SLRPermissionsPlugin: NSObject, SLRPermissionDelegate {

  private let impl = SLRPermissionDelegateImpl()

  public override init() {
    super.init()
  }

  public func permissionStatus(for type: SLRPermissionType) -> SLRPermissionStatus {
    impl.permissionStatus(for: type)
  }

  public func requestPermission(for type: SLRPermissionType, completion: @escaping (Bool) -> Void) {
    impl.requestPermission(for: type, completion: completion)
  }

  public func fetchContacts(completion: @escaping ([SLRContactInfo]) -> Void) {
    impl.fetchContacts(completion: completion)
  }

  public func fetchContact(identifier: String, completion: @escaping (SLRContactInfo?) -> Void) {
    impl.fetchContact(identifier: identifier, completion: completion)
  }

  public func createPhotoLibraryDataSource() -> SLRPhotoLibraryDataSource? {
    impl.createPhotoLibraryDataSource()
  }

  public func createCameraCaptureSession() -> SLRCameraCaptureSession? {
    impl.createCameraCaptureSession()
  }
}
#endif
