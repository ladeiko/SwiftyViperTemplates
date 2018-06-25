//
//  FakeClasses.swift
//  Demo
//
//  Created by Siarhei Ladzeika.
//  Copyright © 2018-present Siarhei Ladzeika. All rights reserved.
//

import ViperMcFlurryX

class AClass {}

class BClass {}

struct SomeEmbeddableModuleInputConfig {
    let title: String
}

protocol SomeEmbeddableModuleInput {
    func configure()
    func configure(with config: SomeEmbeddableModuleInputConfig)
}

@objc
protocol SomeEmbeddableModuleViewInput {
    func setSomeTitle(_ title: String?)
}

protocol SomeEmbeddableModuleViewOutput {
    func viewIsReady()
}

class SomeEmbeddableModuleView: UIViewController, SomeEmbeddableModuleViewInput {
    var output: SomeEmbeddableModuleViewOutput!
    weak var label: UILabel?
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .red
        view.layer.borderWidth = 1
        view.layer.borderColor = UIColor.black.cgColor
        let l = UILabel(frame: view.bounds);
        l.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        view.addSubview(l)
        label = l
        output.viewIsReady()
    }
    func setSomeTitle(_ title: String?) {
        label?.text = title
    }
}

class SomeEmbeddableModule: SomeEmbeddableModuleInput, SomeEmbeddableModuleViewOutput {
    weak var view: SomeEmbeddableModuleViewInput!
    var title: String?
    func configure() {}
    func configure(with config: SomeEmbeddableModuleInputConfig) {
        title = config.title
    }
    func viewIsReady() {
        view.setSomeTitle(title)
    }
}

class SomeEmbeddableModuleConfigurator: NSObject, RamblerViperModuleFactoryProtocol {
    func instantiateModuleTransitionHandler() -> RamblerViperModuleTransitionHandlerProtocol? {
        let presenter = SomeEmbeddableModule()
        let view = SomeEmbeddableModuleView()
        view.output = presenter
        presenter.view = view
        return view
    }
}
