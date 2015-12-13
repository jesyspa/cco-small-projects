module CCO.HM.AddLaziness (
      addLaziness
) where

import CCO.HM.AG.AddLaziness
import CCO.HM.AG.BNormal
import CCO.HM.AG.BNormalUtils
import CCO.Component
import CCO.Feedback
import Data.List
import Control.Monad

addLaziness :: Component BRoot BRoot
addLaziness = component $ \tm -> do
    let wtm = wrap_BRoot (sem_BRoot tm) Inh_BRoot
    return $ code_Syn_BRoot wtm
