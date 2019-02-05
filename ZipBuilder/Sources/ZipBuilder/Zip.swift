/*
 * Copyright 2019 Google
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *      http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

import Foundation

/// Convenience
struct Zip {
  /// Compresses the contents of the directory into a Zip file that resides beside the directory
  /// being compressed and has the same name as the directory with a `.zip` suffix.
  ///
  /// - Parameter directory: The directory to compress.
  /// - Returns: A URL to the zip file created.
  static func zipContents(ofDir directory: URL) -> URL {
    // Ensure the directory being compressed exists.
    guard FileManager.default.directoryExists(at: directory) else {
      fatalError("Attempted to compress contents of \(directory) but the directory does not exist.")
    }

    // Generate the path of the Zip file.
    let parentDir = directory.deletingLastPathComponent()
    let zip = parentDir.appendingPathComponent("Firebase.zip")

    // Run the Zip command. This could be replaced with a proper Zip library in the future.
    let result = Shell.executeCommandFromScript("zip -q -r -dg \(zip) \(directory)")
    switch result {
    case .success(_):
      print("Successfully built Zip file.")
      return zip
    case let .error(code, output):
      fatalError("Error \(code) building zip file: \(output)")
    }
  }

  // Mark initialization as unavailable.
  @available(*, unavailable)
  init() { fatalError() }
}