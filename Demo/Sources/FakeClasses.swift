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
#if embeddable_extended_configure
    func configure(with config: SomeEmbeddableModuleInputConfig)
#else
    func configure()
#endif
}

@objc
protocol SomeEmbeddableModuleViewInput {
    func setSomeTitle(_ title: String?)
}

protocol SomeEmbeddableModuleViewOutput {
    func viewIsReady()
}

var embeddableViewsCount = 0
class SomeEmbeddableModuleView: UIViewController, SomeEmbeddableModuleViewInput {
    var output: SomeEmbeddableModuleViewOutput!
    weak var label: UILabel?
    init() {
        super.init(nibName: nil, bundle: nil)
        embeddableViewsCount += 1
        print("embeddableViewsCount=", embeddableViewsCount)
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    deinit {
        embeddableViewsCount -= 1
        print("embeddableViewsCount=",embeddableViewsCount)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .gray
        view.layer.borderWidth = 1
        view.layer.borderColor = UIColor.black.cgColor
        let l = UILabel(frame: view.bounds);
        l.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        l.textAlignment = .center
        l.textColor = .white
        view.addSubview(l)
        label = l
        output.viewIsReady()
    }
    func setSomeTitle(_ title: String?) {
        label?.text = title
    }
}

var embeddableModulesCount = 0
class SomeEmbeddableModule: SomeEmbeddableModuleInput, SomeEmbeddableModuleViewOutput {

    weak var view: SomeEmbeddableModuleViewInput!
    var title: String?

    init() {
        embeddableModulesCount += 1
        print("embeddableModulesCount=", embeddableModulesCount)
    }

    deinit {
        embeddableModulesCount -= 1
        print("embeddableModulesCount=",embeddableModulesCount)
    }

#if embeddable_extended_configure
    func configure(with config: SomeEmbeddableModuleInputConfig) {
        title = config.title
    }
#else
    func configure() {}
#endif

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
