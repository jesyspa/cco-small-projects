module CCO.HM.Compiler (
      compile
) where

import CCO.HM.AG.HmCore
import CCO.HM.Base
import CCO.Core.Base
import CCO.Component

compile :: Component Tm Mod
compile = component $ \tm -> do
    let wtm = wrap_Tm (sem_Tm tm) Inh_Tm
    return $ Mod (code_Syn_Tm wtm) (bindings_Syn_Tm wtm)
