//
//  SomeModuleInput.swift
//  Demo
//
//  Created by Siarhei Ladzeika.
//  Copyright © 2018-present Siarhei Ladzeika. All rights reserved.
//

import ViperMcFlurryX

protocol SomeModuleInput: class {
    func configure()
}

class SomeModule: NSObject, SomeModuleInput, RamblerViperModuleOutput {
    func configure(){}
}
