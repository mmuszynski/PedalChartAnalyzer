//
//  File.swift
//  
//
//  Created by Mike Muszynski on 8/5/20.
//

import Foundation
import Music

public struct PedalChart: Hashable {
    /// The default pitches when the pedals of the harp are at their lowest positions
    /// D C B E F G A
    public static let defaultPedalPitches: [MusicPitch] = [
        MusicPitch(name: .d, accidental: .flat),
        MusicPitch(name: .c, accidental: .flat),
        MusicPitch(name: .b, accidental: .flat),
        MusicPitch(name: .e, accidental: .flat),
        MusicPitch(name: .f, accidental: .flat),
        MusicPitch(name: .g, accidental: .flat),
        MusicPitch(name: .a, accidental: .flat)
    ]
    
    /// The full set of combinations that are possible using the pedals of the harp
    static var allPedalCombinations: [PedalChart] {
        var combinations = [PedalChart]()
        
        func indexRange(for startingPitch: MusicPitch) -> ClosedRange<Int> {
            let index = startingPitch.enharmonicIndex
            return index...index+2
        }
        
        let defaultPedalPitches = PedalChart.defaultPedalPitches
        
        for i0 in indexRange(for: defaultPedalPitches[0]) {
            for i1 in indexRange(for: defaultPedalPitches[1]) {
                for i2 in indexRange(for: defaultPedalPitches[2]) {
                    for i3 in indexRange(for: defaultPedalPitches[3]) {
                        for i4 in indexRange(for: defaultPedalPitches[4]) {
                            for i5 in indexRange(for: defaultPedalPitches[5]) {
                                for i6 in indexRange(for: defaultPedalPitches[6]) {
                                    let chart = PedalChart(state: [i0, i1, i2, i3, i4, i5, i6])
                                    combinations.append(chart)
                                }
                            }
                        }
                    }
                }
            }
        }
        
        return combinations
    }
    
    public init(state: Array<Int>) {
        self.state = state
    }
    
    public var state = [0, 0, 0, 0, 0, 0, 0]
    public var pitches: [MusicPitch] {
        var allPitches = [MusicPitch]()
        for i in 0..<state.count {
            let defaultPitch = PedalChart.defaultPedalPitches[i]
            let newPitch = MusicPitch(enharmonicIndex: defaultPitch.enharmonicIndex + state[i], name: defaultPitch.name)!
            allPitches.append(newPitch)
        }
        
        return allPitches
    }
}

extension PedalChart: Sequence {
    public func makeIterator() -> Array<Int>.Iterator {
        return state.makeIterator()
    }
    
    subscript(index: Int) -> Int {
        get {
            return state[index]
        }
        set {
            state[index] = newValue
        }
    }
}
