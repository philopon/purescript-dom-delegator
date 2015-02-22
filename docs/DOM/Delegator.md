# Module Documentation

## Module DOM.Delegator

#### `Delegator`

``` purescript
data Delegator :: !
```


#### `EffDelegator`

``` purescript
type EffDelegator e = Eff (delegator :: Delegator | e)
```


#### `domDelegatorWith`

``` purescript
domDelegatorWith :: forall e a. [String] -> EffDelegator e a -> Eff e a
```

#### `domDelegator`

``` purescript
domDelegator :: forall e a. EffDelegator e a -> Eff e a
```

preserve dom-delegator from dead code eliminator

#### `Unregister`

``` purescript
type Unregister e = EffDelegator e Unit
```


#### `addGlobalEventListener`

``` purescript
addGlobalEventListener :: forall e event. String -> (event -> Eff e Unit) -> EffDelegator e (Unregister e)
```


#### `addEventListener`

``` purescript
addEventListener :: forall e event. Node -> String -> (event -> Eff e Unit) -> EffDelegator e (Unregister e)
```




