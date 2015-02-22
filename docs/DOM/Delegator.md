# Module Documentation

## Module DOM.Delegator

#### `withDelegator`

``` purescript
withDelegator :: forall e a. Eff e a -> Eff e a
```

preserve dom-delegator from dead code eliminator

#### `addGlobalEventListener`

``` purescript
addGlobalEventListener :: forall e event. String -> (event -> Eff e Unit) -> Eff e Unit
```


#### `addEventListener`

``` purescript
addEventListener :: forall e event. Node -> String -> (event -> Eff e Unit) -> Eff e Unit
```




