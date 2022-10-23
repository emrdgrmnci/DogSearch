//
//  FileStorageManager.swift
//  DogSearch
//
//  Created by TextalkMedia-Emre on 2022-10-14.
//

import Foundation
import UIKit

final class FileStorageManager {
  static let shared = FileStorageManager()

  enum Error: Swift.Error {
    case fileAlreadyExists
    case invalidDirectory
    case writtingFailed
    case readingFailed
    case fileNotExists
  }
  let fileManager: FileManager

  init(fileManager: FileManager = .default) {
    self.fileManager = fileManager
  }

  func save(fileNamed: String) throws -> String {
    guard let url = makeURLSave(forFileNamed: fileNamed) else {
      throw Error.invalidDirectory
    }
    if fileManager.fileExists(atPath: url.absoluteString) {
      throw Error.fileAlreadyExists
    }

    let data = try Data(contentsOf: URL(string: fileNamed)!)

    do {
      try data.write(to: url)
    } catch {
      debugPrint(error)
      throw Error.writtingFailed
    }
    return url.absoluteString
  }

  private func makeURLRead(forFileNamed fileName: String) -> URL? {
    guard let url = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first else {
      return nil
    }
    return url.appendingPathComponent(fileName)
  }

  private func makeURLSave(forFileNamed fileName: String) -> URL? {
    guard let url = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first else {
      return nil
    }
    let removeBaseURL = fileName.replacingOccurrences(of: "https://images.dog.ceo/breeds/", with: "")
    let strURL = removeBaseURL.replacingOccurrences(of: "/", with: "__")
    return url.appendingPathComponent(strURL)
  }

  func read(fileNamed: String) throws -> UIImage? {
    do {
      let data = try Data(contentsOf: URL(string:fileNamed)!)
      return UIImage(data: data)
    } catch {
      debugPrint(error)
      throw Error.readingFailed
    }
  }

  func readAllFiles() throws -> [String]? {
    guard let url = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first else {
      return nil
    }
    var readFiles = [String]()

    do {
      let directoryContents = try FileManager.default.contentsOfDirectory(at: url, includingPropertiesForKeys: nil)
      for url in directoryContents {
        readFiles.append(url.absoluteString)
      }
      return readFiles
    } catch {
      debugPrint(error)
      throw Error.readingFailed
    }
  }

  func readAllRemoteURLs() throws -> [String]? {
    guard let url = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first else {
      return nil
    }
    var readFiles = [String]()

    do {

      let directoryContents = try FileManager.default.contentsOfDirectory(at: url, includingPropertiesForKeys: nil)
      for url in directoryContents {
        let splits = url.absoluteString.components(separatedBy: "/")

        let lastCharOfURL = splits.last
        readFiles.append("https://images.dog.ceo/breeds/" + (lastCharOfURL?.replacingOccurrences(of: "__", with: "/") ?? ""))
      }
      return readFiles
    } catch {
      debugPrint(error)
      throw Error.readingFailed
    }
  }

  func removeFileFromFileManager(filePath: String) throws -> Void {
    do {
      try FileManager.default.removeItem(at: URL(string: filePath)!)
    } catch {
      print("Could not delete file, probably read-only filesystem")
    }
    return
  }

  func getBreedByFilePath(fileNamed: String) throws -> String? {
    let splits = fileNamed.components(separatedBy: "/")
    let splitsBreed = splits.last?.components(separatedBy: "__")
    return splitsBreed?.first
  }
}
