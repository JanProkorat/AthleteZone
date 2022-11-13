//
//  Scene.swift
//  Athlete Zone
//
//  Created by Jan Prokorát on 07.11.2022.
//

import SwiftUI

protocol Scene {
    
    var Header: AnyView? { get }
    var Content: AnyView? { get }
    var Footer: AnyView? { get }


}
