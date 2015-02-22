module Main where

import Control.Monad.Eff
import DOM
import Debug.Trace
import DOM.Delegator
import Control.Timer

foreign import getElementById """
function getElementById(id){
  return function(){
    return document.getElementById(id);
  }
}""" :: forall e. String -> Eff e Node

main = domDelegatorWith ["mousemove"] $ do
  trace "start"
  unregisterKeydown <- addGlobalEventListener "keydown" $ \_ -> trace "keydown"

  test <- getElementById "test"
  unregisterClick <- addEventListener test "click" $ \_ -> trace "test clicked"

  unregisterMove <- addGlobalEventListener "mousemove" $ \_ -> trace "mouse move"

  timeout 3000 $ do
    trace "timeout"
    unregisterKeydown
    unregisterClick
    unregisterMove
