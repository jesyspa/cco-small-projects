module CCO.HM.Compiler (
      compile
) where

import CCO.HM.AG.HmCore
import CCO.HM.Base
import CCO.Core.Base
import CCO.Component

compile :: Component Tm Mod
compile = component $ \tm -> do
    let inh = Inh_Tm { gsymbols_Inh_Tm = bindNames, symbols_Inh_Tm = [], inLambda_Inh_Tm = False}
        wtm = wrap_Tm (sem_Tm tm) inh
        binds :: [(Var, Bind)]
        binds = bindings_Syn_Tm wtm
        bindNames = map fst binds
        bindVals = map snd binds
    return $ Mod (code_Syn_Tm wtm) bindVals
