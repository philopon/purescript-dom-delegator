module DOM.Delegator
  ( withDelegator
  , addGlobalEventListener, addEventListener
  ) where

import DOM
import Control.Monad.Eff
import Data.Function
import DOM.Delegator.Foreign(delegator)

-- | preserve dom-delegator from dead code eliminator
withDelegator :: forall e a. Eff e a -> Eff e a
withDelegator m = let d = delegator in m

foreign import addGlobalEventListenerImpl """
function addGlobalEventListenerImpl(delegator, ev, fn) {
  return function(){
    var f = function(e){fn(e)();}
    delegator.addGlobalEventListener(ev, f);
    return {};
  }
}""" :: forall delegator event e. Fn3 delegator String (event -> Eff e Unit) (Eff e Unit)

addGlobalEventListener :: forall e event. String -> (event -> Eff e Unit) -> Eff e Unit
addGlobalEventListener ev f = runFn3 addGlobalEventListenerImpl delegator ev f

foreign import addEventListenerImpl """
function addEventListenerImpl(delegator, dom, ev, fn) {
  return function(){
    var f = function(e){fn(e)();}
    delegator.addEventListener(dom, ev, f);
    return {};
  }
}""" :: forall delegator event e. Fn4 delegator Node String (event -> Eff e Unit) (Eff e Unit)

addEventListener :: forall e event. Node -> String -> (event -> Eff e Unit) -> Eff e Unit
addEventListener dom ev f = runFn4 addEventListenerImpl delegator dom ev f
