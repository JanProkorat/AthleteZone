//
//  Scene.swift
//  Athlete Zone
//
//  Created by Jan Prokorát on 07.11.2022.
//

import SwiftUI

protocol Scene {
    var header: AnyView? { get }
    var content: AnyView? { get }
    var footer: AnyView? { get }
}
