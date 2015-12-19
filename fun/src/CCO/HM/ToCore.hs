module CCO.HM.ToCore (
      toCore
) where

import CCO.HM.AG.BNormal (BRoot)
import CCO.HM.AG.HmCore  (wrap_BRoot, sem_BRoot, Inh_BRoot(..), code_Syn_BRoot)
import CCO.Component     (Component, component)
import CCO.Core.AG.Base  (Mod)

toCore :: Component BRoot Mod
toCore = component $ \br -> do
    let wbr = wrap_BRoot (sem_BRoot br) Inh_BRoot
    return $ code_Syn_BRoot wbr
