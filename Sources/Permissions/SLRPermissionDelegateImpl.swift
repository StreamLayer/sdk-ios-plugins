//
//  SLRPermissionDelegateImpl.swift
//  StreamLayerPlugins
//
//  Copyright © 2024 StreamLayer, Inc. All rights reserved.
//

#if os(iOS)
import UIKit
import AVFoundation
import Contacts
import Photos
import StreamLayerSDK

final class SLRPermissionDelegateImpl: NSObject, SLRPermissionDelegate {

  // MARK: - Permission Status

  func permissionStatus(for type: SLRPermissionType) -> SLRPermissionStatus {
    switch type {
    case .camera:
      switch AVCaptureDevice.authorizationStatus(for: .video) {
      case .authorized: return .authorized
      case .denied: return .denied
      case .notDetermined: return .notDetermined
      case .restricted: return .restricted
      @unknown default: return .denied
      }
    case .microphone:
      switch AVAudioSession.sharedInstance().recordPermission {
      case .granted: return .authorized
      case .denied: return .denied
      case .undetermined: return .notDetermined
      @unknown default: return .denied
      }
    case .contacts:
      switch CNContactStore.authorizationStatus(for: .contacts) {
      case .authorized: return .authorized
      case .denied: return .denied
      case .notDetermined: return .notDetermined
      case .restricted: return .restricted
      @unknown default: return .denied
      }
    case .photoLibrary:
      switch PHPhotoLibrary.authorizationStatus() {
      case .authorized, .limited: return .authorized
      case .denied: return .denied
      case .notDetermined: return .notDetermined
      case .restricted: return .restricted
      @unknown default: return .denied
      }
    }
  }

  // MARK: - Permission Requests

  func requestPermission(for type: SLRPermissionType, completion: @escaping (Bool) -> Void) {
    switch type {
    case .camera:
      AVCaptureDevice.requestAccess(for: .video) { granted in
        DispatchQueue.main.async { completion(granted) }
      }
    case .microphone:
      AVAudioSession.sharedInstance().requestRecordPermission { granted in
        DispatchQueue.main.async { completion(granted) }
      }
    case .contacts:
      CNContactStore().requestAccess(for: .contacts) { granted, _ in
        DispatchQueue.main.async { completion(granted) }
      }
    case .photoLibrary:
      PHPhotoLibrary.requestAuthorization { status in
        DispatchQueue.main.async { completion(status == .authorized || status == .limited) }
      }
    }
  }

  // MARK: - Contacts Data Access

  func fetchContacts(completion: @escaping ([SLRContactInfo]) -> Void) {
    DispatchQueue.global(qos: .userInitiated).async {
      let store = CNContactStore()
      let keysToFetch: [CNKeyDescriptor] = [
        CNContactIdentifierKey as CNKeyDescriptor,
        CNContactGivenNameKey as CNKeyDescriptor,
        CNContactFamilyNameKey as CNKeyDescriptor,
        CNContactPhoneNumbersKey as CNKeyDescriptor,
        CNContactThumbnailImageDataKey as CNKeyDescriptor
      ]
      let request = CNContactFetchRequest(keysToFetch: keysToFetch)
      var contacts: [SLRContactInfo] = []

      do {
        try store.enumerateContacts(with: request) { cnContact, _ in
          let phoneNumbers = cnContact.phoneNumbers.map { $0.value.stringValue }
          contacts.append(SLRContactInfo(
            identifier: cnContact.identifier,
            givenName: cnContact.givenName,
            familyName: cnContact.familyName,
            phoneNumbers: phoneNumbers,
            thumbnailImageData: cnContact.thumbnailImageData
          ))
        }
      } catch {
        print("Failed to fetch contacts: \(error)")
      }

      DispatchQueue.main.async { completion(contacts) }
    }
  }

  func fetchContact(identifier: String, completion: @escaping (SLRContactInfo?) -> Void) {
    DispatchQueue.global(qos: .userInitiated).async {
      let store = CNContactStore()
      let keysToFetch: [CNKeyDescriptor] = [
        CNContactIdentifierKey as CNKeyDescriptor,
        CNContactGivenNameKey as CNKeyDescriptor,
        CNContactFamilyNameKey as CNKeyDescriptor,
        CNContactPhoneNumbersKey as CNKeyDescriptor,
        CNContactThumbnailImageDataKey as CNKeyDescriptor
      ]
      do {
        let cnContact = try store.unifiedContact(withIdentifier: identifier,
                                                  keysToFetch: keysToFetch)
        let info = SLRContactInfo(
          identifier: cnContact.identifier,
          givenName: cnContact.givenName,
          familyName: cnContact.familyName,
          phoneNumbers: cnContact.phoneNumbers.map { $0.value.stringValue },
          thumbnailImageData: cnContact.thumbnailImageData
        )
        DispatchQueue.main.async { completion(info) }
      } catch {
        DispatchQueue.main.async { completion(nil) }
      }
    }
  }

  // MARK: - Photo Library Data Source

  func createPhotoLibraryDataSource() -> SLRPhotoLibraryDataSource? {
    return SLRPhotoLibraryDataSourceImpl()
  }

  // MARK: - Camera Capture Session

  func createCameraCaptureSession() -> SLRCameraCaptureSession? {
    return SLRCameraCaptureSessionImpl()
  }
}
#endif
