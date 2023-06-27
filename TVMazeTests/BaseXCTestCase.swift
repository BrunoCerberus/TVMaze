//
//  BaseXCTestCase.swift
//  TVMazeTests
//
//  Created by bruno on 26/06/23.
//

import XCTest
import SnapshotTesting
import SwiftUI
import ComposableArchitecture
@testable import TVMaze
import Kingfisher

class BaseXCTestCase: XCTestCase {

    let scheduler: TestSchedulerOf<DispatchQueue> = DispatchQueue.test
    private let deviceToBeTested: String = "iPhone SE (3rd generation)"
    let snapshotLowPrecision: Float = 0.8
    let snapshotPrecision: Float = 0.95
    let snapshotHighPrecision: Float = 1
    let snapshotRecord: Bool = false

    override func setUpWithError() throws {
        try? super.setUpWithError()

        guard UIDevice.current.name.contains(deviceToBeTested) else {
            fatalError("Switch to \(deviceToBeTested) for these tests.")
        }
        
        UIView.appearance().overrideUserInterfaceStyle = .dark
        UIView.setAnimationsEnabled(false)
    }

    override func tearDownWithError() throws {
        try? super.tearDownWithError()
    }

    func storeForSnapshot<State: Equatable, Action: Equatable>(state: State) -> Store<State, Action> {
        Store(
            initialState: state,
            reducer: .empty,
            environment: Void()
        )
    }
}

/// Returns a valid snapshot directory under the project’s `ci_scripts`.
///
/// - Parameter file: A `StaticString` representing the current test’s filename.
/// - Returns: A directory for the snapshots.
/// - Note: It makes strong assumptions about the structure of the project; namely,
///   it expects the project to consist of a single package located at the root.
public func snapshotDirectory(
    for file: StaticString,
    testsPathComponent: String = "TVMazeTests",
    ciScriptsPathComponent: String = "ci_scripts",
    snapshotsPathComponent: String = "TVMazeTests"
) -> String {
    
    let fileURL: URL = URL(fileURLWithPath: "\(file)", isDirectory: false)
    let isCI: Bool = fileURL.path.contains("Volumes")
    
    let packageRootPath: [String] = fileURL
        .pathComponents
        .prefix(while: { $0 != testsPathComponent })

    let testsPath: [String] = packageRootPath + [testsPathComponent]
    
    let relativePath: ArraySlice<String> = fileURL
        .deletingPathExtension()
        .pathComponents
        .dropFirst(testsPath.count)
    
    var snapshotDirectoryPath: [String] = packageRootPath
    
    if isCI {
        snapshotDirectoryPath = snapshotDirectoryPath + [ciScriptsPathComponent, snapshotsPathComponent] + relativePath
    } else {
        snapshotDirectoryPath = snapshotDirectoryPath + [snapshotsPathComponent] + relativePath
    }
    
    let lastPath: String? = snapshotDirectoryPath.last
    let withoutlast: [String] = snapshotDirectoryPath.dropLast()
    let withSnaphot: [String] = withoutlast + ["__Snapshots__"]
    let withComplete: [String] = withSnaphot + [lastPath ?? ""]
    
    return withComplete.joined(separator: "/")
}

/// Asserts that a given value matches references on disk.
///
/// - Parameters:
///   - value: A value to compare against a reference.
///   - snapshotting: An array of strategies for serializing, deserializing, and comparing values.
///   - recording: Whether or not to record a new reference.
///   - timeout: The amount of time a snapshot must be generated in.
///   - file: The file in which failure occurred. Defaults to the file name of the test case in which this function was called.
///   - testName: The name of the test in which failure occurred. Defaults to the function name of the test case in which this function was called.
///   - line: The line number on which failure occurred. Defaults to the line number on which this function was called.
///   - testsPathComponent: The name of the tests directory. Defaults to “Tests”.
public func ciAssertSnapshot<Value, Format>(
    matching value: @autoclosure () throws -> Value,
    as snapshotting: Snapshotting<Value, Format>,
    named name: String? = nil,
    record recording: Bool = false,
    timeout: TimeInterval = 5,
    file: StaticString = #file,
    testName: String = #function,
    line: UInt = #line,
    testsPathComponent: String = "TVMazeTests"
) {
    let failure: String? = verifySnapshot(
        matching: try value(),
        as: snapshotting,
        named: name,
        record: recording,
        snapshotDirectory: snapshotDirectory(for: file, testsPathComponent: testsPathComponent),
        timeout: timeout,
        file: file,
        testName: testName
    )

    guard let message = failure else { return }
    XCTFail(message, file: file, line: line)
}
