//
//  PedalChartsBrainTests.swift
//  PedalChartsBrainTests
//
//  Created by Mike Muszynski on 8/3/20.
//

import XCTest
@testable import PedalChartAnalyzer
import Music

class PedalChartsBrainTests: XCTestCase {

    func testAllCombinations() {
        XCTAssertEqual(PedalChart.allPedalCombinations.count, 2187)
        XCTAssertEqual(Set(PedalChart.allPedalCombinations).count, 2187)
    }
    
    func testScale() throws {
        let scale = try MusicScale(root: MusicPitch(name: .c, accidental: .natural), mode: .major, direction: .up).dropLast()
        let brain = PedalChartAnalyzer()
        let charts = brain.formCharts(from: Array(scale))
    }
    
    func testChord() throws {
        let chord = try MusicChord(root: MusicPitch(name: .c, accidental: .natural), type: .dominantSeventh)
        let disallowed = try chord.transposed(by: MusicInterval(direction: .upward, quality: .minor, quantity: .second))
        let otherDisallowed = try chord.transposed(by: MusicInterval(direction: .downward, quality: .minor, quantity: .second))
        let charts = PedalChartAnalyzer().formCharts(from: Array(chord), avoidingPitches: Array(disallowed) + Array(otherDisallowed))
    }
    
    func testArrayLiteral() {
        let chart: PedalChart = [0, 1, 2, 0, 1, 2, 1]
        XCTAssertEqual(chart.state, [0, 1, 2, 0, 1, 2, 1])
    }

}
