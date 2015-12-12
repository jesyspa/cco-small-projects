module CCO.HM.ToANormal (
      toANormal
) where

import CCO.HM.AG.ANormal
import CCO.HM.AG.ToANormal
import CCO.HM.Base
import CCO.HM.Builtins
import CCO.Component

toANormal :: Component Tm ATm
toANormal = component $ \tm -> do
    let wtm = wrap_Tm (sem_Tm tm) (Inh_Tm 0)
        binds = bindings_Syn_Tm wtm
        code = code_Syn_Tm wtm
        vars = freevars_Syn_Tm wtm
    return $ wrapBinds code (binds ++ filter (flip elem vars . fst) builtins)

