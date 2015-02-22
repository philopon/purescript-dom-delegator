module Main where

import Control.Monad.Eff
import DOM
import Debug.Trace
import DOM.Delegator

foreign import getElementById """
function getElementById(id){
  return function(){
    return document.getElementById(id);
  }
}""" :: forall e. String -> Eff e Node

main = withDelegator $ do
  trace "start"
  addGlobalEventListener "keydown" $ \_ -> trace "keydown"

  test <- getElementById "test"
  addEventListener test "click" $ \_ -> trace "test clicked"
