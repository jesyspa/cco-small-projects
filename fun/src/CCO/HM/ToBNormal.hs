module CCO.HM.ToBNormal (
      toBNormal
) where

import CCO.HM.AG.BNormal
import CCO.HM.AG.BNormalUtils
import CCO.HM.AG.ToBNormal
import CCO.HM.Base
import CCO.HM.Builtins
import CCO.Component

toBNormal :: Component Tm BRoot
toBNormal = component $ \tm -> do
    let wtm = wrap_Tm (sem_Tm tm) (Inh_Tm 0)
        binds = bindings_Syn_Tm wtm
        code = code_Syn_Tm wtm
    return (BRoot $ wrap code binds)

