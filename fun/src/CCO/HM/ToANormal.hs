module CCO.HM.ToANormal (
      toANormal
) where


import CCO.HM.AG.ANormal
import CCO.HM.AG.ToANormal
import CCO.HM.Base
import CCO.Component
import Control.Arrow ((>>>))

builtins :: [(Var, AExp)]
builtins = [bFalse, bTrue]
    where bFalse = ("False", AAlloc 0 [])
          bTrue  = ("True",  AAlloc 1 [])

toANormal :: Component Tm ATm
toANormal = component $ \tm -> do
    let wtm = wrap_Tm (sem_Tm tm) Inh_Tm
        binds = bindings_Syn_Tm wtm
        code = code_Syn_Tm wtm
    return $ wrapBinds code (builtins ++ binds)

