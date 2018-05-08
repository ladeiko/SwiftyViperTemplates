# SwiftyViperTemplates

Collection of [Generamba](https://github.com/rambler-digital-solutions/Generamba) VIPER templates.

## Changes

[CHANGELOG](CHANGELOG.md)

## Templates

### SwiftyViper
Simple viper module where UIViewController is not associated with any XIB/Storyboard file.

### SwiftyViperXib
Simple viper module where UIViewController is associated with XIB file (which one is also generated).

### SwiftyViperStoryboard
Simple viper module where UIViewController is associated with Storyboard file (which one is also generated).

### SwiftyViperMcFlurry
Similar to SwiftyViper, but also generates code which helps to use [ViperMcFlurryX](https://github.com/ladeiko/ViperMcFlurryX) module in router. 

#### Required modules

 * [ViperMcFlurryX](https://github.com/ladeiko/ViperMcFlurryX)

### SwiftyViperMcFlurryAlert
Creates module implementing UIAlertController in alert mode using VIPER paradigm.

#### Required modules

 * [ViperMcFlurryX](https://github.com/ladeiko/ViperMcFlurryX)
 * [TransparentProxyViewController](https://github.com/ladeiko/TransparentProxyViewController)

### SwiftyViperMcFlurryTrasparent 
Creates module with main transparent view presented immediatly event if animation was specified. You can use it to present some other native Apple controller over transparent view. Similar trick is used in SwiftyViperMcFlurryAlert template.
#### Required modules

 * [ViperMcFlurryX](https://github.com/ladeiko/ViperMcFlurryX)
 * [TransparentProxyViewController](https://github.com/ladeiko/TransparentProxyViewController)

### SwiftyViperMcFlurryXib
Similar to SwiftyViperXib, but also generates code which helps to use [ViperMcFlurryX](https://github.com/ladeiko/ViperMcFlurryX) module in router.

#### Required modules

 * [ViperMcFlurryX](https://github.com/ladeiko/ViperMcFlurryX)

### SwiftyViperMcFlurryStoryboard
Similar to SwiftyViperStoryboard, but also generates code which helps to use [ViperMcFlurryX](https://github.com/ladeiko/ViperMcFlurryX) module in router.

#### Required modules

 * [ViperMcFlurryX](https://github.com/ladeiko/ViperMcFlurryX)

### SwiftyViperMcFlurryEmbedStoryboard
Similar to SwiftyViperMcFlurryStoryboard, but also generates code to embed another module to current view via storyboard. This can be usefull when you compose module onto some container module. Later you can manually add more containers and embed more modules.

#### Required modules

 * [ViperMcFlurryX](https://github.com/ladeiko/ViperMcFlurryX)
 * [RamblerSegues](https://github.com/rambler-digital-solutions/RamblerSegues)

### SwiftyViperMcFlurryStoryboardCollectionViewCacheTracker
Creates module with UICollectionView as **secondary** view placed onto main controller view. Also it creates start code to show items stored in database using [CacheTracker](https://github.com/ladeiko/CacheTracker) and [CacheTrackerConsumer](https://github.com/ladeiko/CacheTrackerConsumer) in plain (no sections) mode.

#### Required modules

 * [ViperMcFlurryX](https://github.com/ladeiko/ViperMcFlurryX)
 * [CacheTracker](https://github.com/ladeiko/CacheTracker) 
 * [CacheTrackerConsumer](https://github.com/ladeiko/CacheTrackerConsumer)

### SwiftyViperMcFlurryStoryboardRootCollectionViewCacheTracker
Creates module with UICollectionView as **main** view of controller (UICollectionViewController). Also it creates start code to show items stored in database using [CacheTracker](https://github.com/ladeiko/CacheTracker) and [CacheTrackerConsumer](https://github.com/ladeiko/CacheTrackerConsumer) in plain (no sections) mode.

#### Required modules

 * [ViperMcFlurryX](https://github.com/ladeiko/ViperMcFlurryX)
 * [CacheTracker](https://github.com/ladeiko/CacheTracker) 
 * [CacheTrackerConsumer](https://github.com/ladeiko/CacheTrackerConsumer)
 
### SwiftyViperMcFlurryStoryboardRootTableViewCacheTracker
Creates module with UITableView as **secondary** view placed onto main controller view. Also it creates start code to show items stored in database using [CacheTracker](https://github.com/ladeiko/CacheTracker) and [CacheTrackerConsumer](https://github.com/ladeiko/CacheTrackerConsumer) in plain (no sections) mode.

#### Required modules

 * [ViperMcFlurryX](https://github.com/ladeiko/ViperMcFlurryX)
 * [CacheTracker](https://github.com/ladeiko/CacheTracker) 
 * [CacheTrackerConsumer](https://github.com/ladeiko/CacheTrackerConsumer)
 
### SwiftyViperMcFlurryStoryboardTableViewCacheTracker
Creates module with UITableView as **main** view of controller (UITableViewController). Also it creates start code to show items stored in database using [CacheTracker](https://github.com/ladeiko/CacheTracker) and [CacheTrackerConsumer](https://github.com/ladeiko/CacheTrackerConsumer) in plain (no sections) mode.

#### Required modules

 * [ViperMcFlurryX](https://github.com/ladeiko/ViperMcFlurryX)
 * [CacheTracker](https://github.com/ladeiko/CacheTracker) 
 * [CacheTrackerConsumer](https://github.com/ladeiko/CacheTrackerConsumer)

## LICENSE
This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details
