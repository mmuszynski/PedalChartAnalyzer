//
//  PedalChartAnalyzer.swift
//  PedalChartAnalyzer
//
//  Created by Mike Muszynski on 8/3/20.
//

import Foundation
import Music

extension MusicPitch {
    public init(name: MusicPitchName, accidental: MusicAccidental) {
        self.init(name: name, accidental: accidental, octave: 1)
    }
}

public class PedalChartAnalyzer {
        
    public init() {}
    
    /// Given a set of pitches, forms a set of pedal arrangements that will produce the notes required
    ///
    /// When creating a pedal chart for a given set of pitches, a set of specific enharmonic indices will need to be included. Each pedal has a range of three specific enharmonic indices that it can produce for any given octave. Given these restrictions, it is possible to select all possible combinations of pedal states that produces these pitches.
    ///
    /// While there may be a unique solution, it is likely that there will be cases where there are also many or no solutions.
    ///
    /// - note: Pitch octave is ignored, as each pedal controls many octaves simultaneously
    ///
    /// - Parameter pitchCollection: The pitches to be included in the output chart
    public func formCharts(from pitchCollection: Array<MusicPitch>, optionalPitches: Array<MusicPitch> = [], avoidingPitches avoidancePitches: Array<MusicPitch> = []) -> Array<PedalChart> {
        func pitchToFirstOctave(pitch: MusicPitch) -> MusicPitch {
            return MusicPitch(name: pitch.name, accidental: pitch.accidental)
        }
        
        //Using the required pitches (those that are not explicitly set as optional)
        let requiredPitchSet = Set(Set(pitchCollection).subtracting(Set(optionalPitches))
                                    .map(pitchToFirstOctave)
                                    .map(\.enharmonicIndex))
        
        let disallowedPitchSet = Set(avoidancePitches
                                        .map(pitchToFirstOctave)
                                        .map(\.enharmonicIndex))
        
        //Come up with all possible pitch combinations
        //Filtering out those that do not contain required pitches
        let combinations = PedalChart.allPedalCombinations
            .filter { (array) -> Bool in
                let hasRequirements =
                    requiredPitchSet.isSubset(of: array) && disallowedPitchSet.isDisjoint(with: array)
                return hasRequirements
            }
        
        return combinations.map { representation in
            var rep = representation
            for i in 0..<PedalChart.defaultPedalPitches.count {
                rep[i] = rep[i] - PedalChart.defaultPedalPitches[i].enharmonicIndex
            }
            return rep
        }
    }
}
