module CCO.HM.AddLaziness (
      addLaziness
) where

import CCO.HM.AG.AddLaziness
import CCO.HM.AG.ANormal
import CCO.Component
import CCO.Feedback
import Data.List
import Control.Monad

addLaziness :: Component ATm ATm
addLaziness = component $ \tm -> do
    let wtm = wrap_ATm (sem_ATm tm) (Inh_ATm 0)
        code = code_Syn_ATm wtm
    return code
