module CCO.HM.ToANormal (
      toANormal
) where

import CCO.HM.ANormal
import CCO.HM.AG.BNormal
import CCO.HM.AG.ANormalUtils
import CCO.HM.AG.ToANormal
import CCO.HM.Builtins
import CCO.Component

toANormal :: Component BRoot ARoot
toANormal = component $ \br -> do
    let wbr = wrap_BRoot (sem_BRoot br) Inh_BRoot
    return $ code_Syn_BRoot wbr

