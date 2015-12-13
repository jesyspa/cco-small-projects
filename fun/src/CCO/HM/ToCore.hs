module CCO.HM.ToCore (
      toCore
) where

import CCO.HM.AG.BNormal
import CCO.HM.AG.HmCore
import CCO.HM.AG.BaseHelpers
import CCO.HM.Context
import CCO.Component
import CCO.Core.AG.Base

toCore :: Component BRoot Mod
toCore = component $ \br -> do
    let wbr = wrap_BRoot (sem_BRoot br) Inh_BRoot
    return $ code_Syn_BRoot wbr
