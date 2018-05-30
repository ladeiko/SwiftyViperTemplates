# SwiftyViperTemplates Change Log

All notable changes to this project will be documented in this file.

## 1.4.0
### Added
* Add support for module state
* Add soft module shutdown by calling ```willDeinit``` of presenter using [OnDeallocateX](https://github.com/ladeiko/OnDeallocateX)
* Support for custom parameter ```extended_configure:true```
* More asserts

### Fixed
* Fix name of ```...didDismiss``` method of SwiftyViperMcFlurryAlert output

## 1.3.0
### Added
*  SwiftyViperMcFlurryStoryboardCollectionViewCacheTracker
*  SwiftyViperMcFlurryStoryboardRootCollectionViewCacheTracker
*  SwiftyViperMcFlurryStoryboardRootTableViewCacheTracker
*  SwiftyViperMcFlurryStoryboardTableViewCacheTracker
*  SwiftyViperMcFlurryAlert
*  SwiftyViperMcFlurryTrasparent

## 1.2.0
### Added
* ```viewController.moduleInput = presenter``` to configure()
* added inheritance of presenter from ```RamblerViperModuleInput ``` and its implementation
* added inheritance of all protocols from ```class```
