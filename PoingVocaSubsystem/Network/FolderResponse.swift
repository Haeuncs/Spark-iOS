//
//  FolderResponse.swift
//  PoingVocaSubsystem
//
//  Created by LEE HAEUN on 2020/09/17.
//  Copyright © 2020 LEE HAEUN. All rights reserved.
//

import Foundation

public class FolderResponse: Codable {
    public let `default`: Bool
    public let id: Int
    public let name: String
    public let shareable: Bool
}
