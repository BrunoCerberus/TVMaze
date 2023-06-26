//
//  SearchSeriesResponse.swift
//  TVMaze
//
//  Created by bruno on 26/06/23.
//

import Foundation

typealias SearchSeriesResponse = [SearchSeries]

struct SearchSeries: BaseCodable, Equatable, Identifiable {
    let id = UUID()
    let score: Double?
    let show: Series
    
    enum CodingKeys: String, CodingKey {
        case score
        case show
    }
}
