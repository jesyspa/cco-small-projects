module CCO.HM.AddForcing (
      addForcing
) where

import CCO.HM.AG.AddForcing
import CCO.HM.AG.BNormal
import CCO.HM.AG.BNormalUtils
import CCO.Component
import CCO.Feedback
import Data.List
import Control.Monad

addForcing :: Component BRoot BRoot
addForcing = component $ \br -> do
    let wbr = wrap_BRoot (sem_BRoot br) Inh_BRoot
    return $ code_Syn_BRoot wbr
