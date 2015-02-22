module DOM.Delegator
  ( Delegator(), EffDelegator()
  , domDelegator, domDelegatorWith
  , Unregister()
  , addGlobalEventListener, addEventListener
  ) where

import DOM
import Control.Monad.Eff
import Data.Function
import DOM.Delegator.Foreign(delegator)

foreign import data Delegator :: !
type EffDelegator e = Eff (delegator :: Delegator | e)

foreign import listenToImpl """
function listenToImpl(delegator, ev){
  return function(){
    delegator.listenTo(ev);
    return {};
  }
}""" :: forall delegator e. Fn2 delegator String (Eff e Unit)

foreign import unsafeCoerce """
function unsafeCoerce(a){
  return a;
}""" :: forall a b. a -> b

-- | preserve dom-delegator from dead code eliminator
-- | and add extra listening events.
domDelegatorWith :: forall e a. [String] -> EffDelegator e a -> Eff e a
domDelegatorWith es m = do
  foreachE es $ \e -> runFn2 listenToImpl delegator e
  unsafeCoerce m

-- | preserve dom-delegator from dead code eliminator
domDelegator :: forall e a. EffDelegator e a -> Eff e a
domDelegator = domDelegatorWith []

type Unregister e = EffDelegator e Unit

foreign import addGlobalEventListenerImpl """
function addGlobalEventListenerImpl(delegator, ev, fn) {
  return function(){
    var f = function(e){fn(e)();}
    delegator.addGlobalEventListener(ev, f);

    return function(){
      delegator.removeGlobalEventListener(ev, f);
      return {};
    }
  }
}""" :: forall delegator event e. Fn3 delegator String (event -> Eff e Unit) (EffDelegator e (Unregister e))

addGlobalEventListener :: forall e event. String -> (event -> Eff e Unit) -> EffDelegator e (Unregister e)
addGlobalEventListener ev f = runFn3 addGlobalEventListenerImpl delegator ev f

foreign import addEventListenerImpl """
function addEventListenerImpl(delegator, dom, ev, fn) {
  return function(){
    var f = function(e){fn(e)();}
    delegator.addEventListener(dom, ev, f);
    return function(){
      delegator.removeEventListener(dom, ev, f);
      return {};
    };
  }
}""" :: forall delegator event e. Fn4 delegator Node String (event -> Eff e Unit) (EffDelegator e (Unregister e))

addEventListener :: forall e event. Node -> String -> (event -> Eff e Unit) -> EffDelegator e (Unregister e)
addEventListener dom ev f = runFn4 addEventListenerImpl delegator dom ev f
