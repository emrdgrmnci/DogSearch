//
//  PhotoClient.swift
//  DogSearch
//
//  Created by TextalkMedia-Emre on 2022-10-07.
//

import Foundation
import Combine

final class PhotoClient: PhotoClientProtocol {
  enum Endpoints {
    case getPhotos(String?)

    static let baseURL = "https://www.reddit.com/" //https://www.reddit.com/r/dog/top.json

    var baseURLValue: String {
      switch self {
      case .getPhotos(let query):
        return Endpoints.baseURL + "r/" + "\(query?.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? "")/" + "top.json"
      }
    }
    var url: URL {
      return URL(string: self.baseURLValue)!
    }
  }

  func getPhotos(query: String?) -> AnyPublisher<[Child], APIServiceErrors> {
    //Combine for networking
    return URLSession.shared.dataTaskPublisher(for: Endpoints.getPhotos(query ?? "").url)
      .map(\.data) // ask for Photo data
      .decode(type: Photo.self, decoder: JSONDecoder())
      .mapError({ error -> APIServiceErrors in
        if let _ = error as? DecodingError {
          return APIServiceErrors.failedToParseGetPhotos
        }
        return APIServiceErrors.failedToGetPhotos
      })
      .map { $0.data.children }
      .receive(on: DispatchQueue.main) //what thread data received from (on main thread)
      .eraseToAnyPublisher()
  }
}
