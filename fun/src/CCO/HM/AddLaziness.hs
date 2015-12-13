module CCO.HM.AddLaziness (
      addLaziness
) where

import CCO.HM.AG.AddLaziness
import CCO.HM.AG.Base
import CCO.Component
import CCO.Feedback
import Data.List
import Control.Monad

addLaziness :: Component Tm Tm
addLaziness = component $ \tm -> do
    let wtm = wrap_Tm (sem_Tm tm) (Inh_Tm 0)
        code = code_Syn_Tm wtm
    return code
