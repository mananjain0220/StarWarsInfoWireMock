/// Copyright (c) 2019 Razeware LLC
/// 
/// Permission is hereby granted, free of charge, to any person obtaining a copy
/// of this software and associated documentation files (the "Software"), to deal
/// in the Software without restriction, including without limitation the rights
/// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
/// copies of the Software, and to permit persons to whom the Software is
/// furnished to do so, subject to the following conditions:
/// 
/// The above copyright notice and this permission notice shall be included in
/// all copies or substantial portions of the Software.
/// 
/// Notwithstanding the foregoing, you may not use, copy, modify, merge, publish,
/// distribute, sublicense, create a derivative work, and/or sell copies of the
/// Software in any work that is designed, intended, or marketed for pedagogical or
/// instructional purposes related to programming, coding, application development,
/// or information technology.  Permission for such use, copying, modification,
/// merger, publication, distribution, sublicensing, creation of derivative works,
/// or sale is expressly withheld.
/// 
/// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
/// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
/// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
/// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
/// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
/// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
/// THE SOFTWARE.

import Foundation

class StarWarsAPINetworklClient {
  var baseURLString: String {
    if CommandLine.arguments.contains("-runlocal-error") {
      return "http://localhost:9999/error/api/"
    } else if CommandLine.arguments.contains("-runlocal-empty") {
      return "http://localhost:9999/empty/api/"
    } else if CommandLine.arguments.contains("-runlocal-delay") {
      return "http://localhost:9999/delay/api/"
    } else if CommandLine.arguments.contains("-runlocal") {
      return "http://localhost:9999/swapi.dev/api/"
    } else {
      return "https://swapi.dev/api/"
    }
  }

  let defaultSession = URLSession(configuration: .default)
  var dataTask: URLSessionDataTask?

  func requestAllCharacters(completion: @escaping (Result<[StarWarsCharacter], Error>) -> Void) {
    dataTask?.cancel()
    let url = baseURL()
    print("📡 baseURLString: \(baseURLString)")
    let listURL = url.appendingPathComponent("people")
    
    dataTask = defaultSession.dataTask(with: listURL, completionHandler: { data, response, error in
      if let error = error {
        print("❌ Network error: \(error)")
        completion(.failure(error))
        return
      }
      
      guard let data = data else {
        print("❌ No data received")
        completion(.failure(NSError(domain: "EmptyData", code: 0, userInfo: nil)))
        return
      }

      do {
        let jsonDecoder = JSONDecoder()
        jsonDecoder.keyDecodingStrategy = .convertFromSnakeCase
        let characterResponse = try jsonDecoder.decode(CharacterListResponse.self, from: data)
        print("✅ Decoded characters: \(characterResponse.results.map { $0.name })")
        completion(.success(characterResponse.results))
      } catch {
        print("❌ Failed to decode JSON: \(error)")
        completion(.failure(error))
      }
    })
    
    dataTask?.resume()
  }

  func baseURL() -> URL {
    guard let url = URL(string: baseURLString) else {
      fatalError("Invalid url generation")
    }
    return url
  }
}

