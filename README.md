# SwiftyViperTemplates

Collection of [Generamba](https://github.com/rambler-digital-solutions/Generamba) VIPER templates.

## Usage

* Create [Rambafile](Demo/Rambafile) at the root of your project folder.
 * setup all variables
 * in 'Templates' section define all templates or only some them.
 * open terminal in project folder
 * install [Generamba](https://github.com/ladeiko/Generamba)
 * run:
  ```
  generamba template install
  ```
 * generamba will fetch required templates to "./Templates" folder
 * now you can generate any new module using generamba:
```generamba gen MyModuleName SwiftyViperMcFlurryAlert```
 * also you can pass additional keys to generamba (see keys supported by these templates):
```generamba gen MyModuleName SwiftyViperMcFlurryAlert --custom_parameters extended_configure:true```

### Custom keys

Keys passed with --custom_parameters to generamba.

```bash
generamba gen MyModuleName SwiftyViperMcFlurryAlert --custom_parameters key1:value1 key2:value2 ...
```

#### extended\_configure:true

Usefull when configuration of module is not trivial.
If passed as true:

```bash
generamba gen MyModuleName SwiftyViperMcFlurryAlert --custom_parameters extended_configure:true
```

then ```configure()``` method of module input will be generated as:

```swift
struct MyModuleConfig {
    // TODO
}

protocol MyModuleInput: class {

    func configure(with config: MyModuleConfig)

}
```

In this case you can add more parameters while development to ```MyModuleConfig``` without modifying existing code.

#### redux\_service\_state\_vars=VARS

**NOTE:** Parameter make sense for ```SwiftyViperReduxService``` only.

```
redux_service_state_vars:a=AClass,b=BClass?
```

will produce state variables for service as:

```
var a: AClass
var b: BClass?
```

#### redux\_service\_state\_persistent:true

**NOTE:** Parameter make sense for ```SwiftyViperReduxService``` only.

Generates code for storing state of service to user defaults

#### redux\_service\_observable:true

**NOTE:** Parameter make sense for ```SwiftyViperReduxService``` only.

Generates method usifull for observing changes of service in Rx way.

#### redux\_service\_generate\_state\_vars\_getters:true

**NOTE:** Parameter make sense for ```SwiftyViperReduxService``` only.

Will generate getters for state vars.

```
var a: AClass { get }
var b: BClass? { get }
```

#### redux\_service\_generate\_state\_vars\_setters:true

**NOTE:** Parameter make sense for ```SwiftyViperReduxService``` only.

Will generate setters for state vars. Usefull only if ```redux_service_generate_state_vars_getters:true```is defined.

```
var a: AClass { get set }
var b: BClass? { get set }
```

## Changes

[CHANGELOG](CHANGELOG.md)

## Templates

### SwiftyViperService
Template for generating viper service using [ViperServices](https://github.com/ladeiko/ViperServices) module

#### Required modules

 * [ViperServices](https://github.com/ladeiko/ViperServices)

___

### SwiftyViper
Simple viper module where UIViewController is not associated with any XIB/Storyboard file.

#### Required modules

 * [OnDeallocateX](https://github.com/ladeiko/OnDeallocateX)

___

### SwiftyViperXib
Simple viper module where UIViewController is associated with XIB file (which one is also generated).

#### Required modules

 * [OnDeallocateX](https://github.com/ladeiko/OnDeallocateX)

___

### SwiftyViperStoryboard
Simple viper module where UIViewController is associated with Storyboard file (which one is also generated).

#### Required modules

 * [OnDeallocateX](https://github.com/ladeiko/OnDeallocateX)

___

### SwiftyViperMcFlurry
Similar to SwiftyViper, but also generates code which helps to use [ViperMcFlurryX](https://github.com/ladeiko/ViperMcFlurryX) module in router.

#### Required modules

 * [ViperMcFlurryX](https://github.com/ladeiko/ViperMcFlurryX)
 * [OnDeallocateX](https://github.com/ladeiko/OnDeallocateX)

___

### SwiftyViperMcFlurryAlert
Creates module implementing UIAlertController in alert mode using VIPER paradigm.

#### Required modules

 * [ViperMcFlurryX](https://github.com/ladeiko/ViperMcFlurryX)
 * [TransparentProxyViewController](https://github.com/ladeiko/TransparentProxyViewController)
 * [OnDeallocateX](https://github.com/ladeiko/OnDeallocateX)

___

### SwiftyViperMcFlurryTrasparent
Creates module with main transparent view presented immediatly event if animation was specified. You can use it to present some other native Apple controller over transparent view. Similar trick is used in SwiftyViperMcFlurryAlert template.
#### Required modules

 * [ViperMcFlurryX](https://github.com/ladeiko/ViperMcFlurryX)
 * [TransparentProxyViewController](https://github.com/ladeiko/TransparentProxyViewController)
 * [OnDeallocateX](https://github.com/ladeiko/OnDeallocateX)

___

### SwiftyViperMcFlurryXib
Similar to SwiftyViperXib, but also generates code which helps to use [ViperMcFlurryX](https://github.com/ladeiko/ViperMcFlurryX) module in router.

#### Required modules

 * [ViperMcFlurryX](https://github.com/ladeiko/ViperMcFlurryX)
 * [OnDeallocateX](https://github.com/ladeiko/OnDeallocateX)

___

### SwiftyViperMcFlurryStoryboard
Similar to SwiftyViperStoryboard, but also generates code which helps to use [ViperMcFlurryX](https://github.com/ladeiko/ViperMcFlurryX) module in router.

#### Required modules

 * [ViperMcFlurryX](https://github.com/ladeiko/ViperMcFlurryX)
 * [OnDeallocateX](https://github.com/ladeiko/OnDeallocateX)

___

### SwiftyViperMcFlurryEmbedStoryboard
Similar to SwiftyViperMcFlurryStoryboard, but also generates code to embed another module to current view via storyboard. This can be usefull when you compose module onto some container module. Later you can manually add more containers and embed more modules.

#### Required modules

 * [ViperMcFlurryX](https://github.com/ladeiko/ViperMcFlurryX)
 * [RamblerSegues](https://github.com/rambler-digital-solutions/RamblerSegues)
 * [OnDeallocateX](https://github.com/ladeiko/OnDeallocateX)

___

### SwiftyViperMcFlurryStoryboardCollectionViewCacheTracker
Creates module with UICollectionView as **secondary** view placed onto main controller view. Also it creates start code to show items stored in database using [CacheTracker](https://github.com/ladeiko/CacheTracker) and [CacheTrackerConsumer](https://github.com/ladeiko/CacheTrackerConsumer) in plain (no sections) mode.

#### Required modules

 * [ViperMcFlurryX](https://github.com/ladeiko/ViperMcFlurryX)
 * [CacheTracker](https://github.com/ladeiko/CacheTracker)
 * [CacheTrackerConsumer](https://github.com/ladeiko/CacheTrackerConsumer)
 * [OnDeallocateX](https://github.com/ladeiko/OnDeallocateX)

___

### SwiftyViperMcFlurryStoryboardRootCollectionViewCacheTracker
Creates module with UICollectionView as **main** view of controller (UICollectionViewController). Also it creates start code to show items stored in database using [CacheTracker](https://github.com/ladeiko/CacheTracker) and [CacheTrackerConsumer](https://github.com/ladeiko/CacheTrackerConsumer) in plain (no sections) mode.

#### Required modules

 * [ViperMcFlurryX](https://github.com/ladeiko/ViperMcFlurryX)
 * [CacheTracker](https://github.com/ladeiko/CacheTracker)
 * [CacheTrackerConsumer](https://github.com/ladeiko/CacheTrackerConsumer)
 * [OnDeallocateX](https://github.com/ladeiko/OnDeallocateX)

___

### SwiftyViperMcFlurryStoryboardRootTableViewCacheTracker
Creates module with UITableView as **secondary** view placed onto main controller view. Also it creates start code to show items stored in database using [CacheTracker](https://github.com/ladeiko/CacheTracker) and [CacheTrackerConsumer](https://github.com/ladeiko/CacheTrackerConsumer) in plain (no sections) mode.

#### Required modules

 * [ViperMcFlurryX](https://github.com/ladeiko/ViperMcFlurryX)
 * [CacheTracker](https://github.com/ladeiko/CacheTracker)
 * [CacheTrackerConsumer](https://github.com/ladeiko/CacheTrackerConsumer)
 * [OnDeallocateX](https://github.com/ladeiko/OnDeallocateX)

___

### SwiftyViperMcFlurryStoryboardTableViewCacheTracker
Creates module with UITableView as **main** view of controller (UITableViewController). Also it creates start code to show items stored in database using [CacheTracker](https://github.com/ladeiko/CacheTracker) and [CacheTrackerConsumer](https://github.com/ladeiko/CacheTrackerConsumer) in plain (no sections) mode.

#### Required modules

 * [ViperMcFlurryX](https://github.com/ladeiko/ViperMcFlurryX)
 * [CacheTracker](https://github.com/ladeiko/CacheTracker)
 * [CacheTrackerConsumer](https://github.com/ladeiko/CacheTrackerConsumer)
 * [OnDeallocateX](https://github.com/ladeiko/OnDeallocateX)

## LICENSE
This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details
