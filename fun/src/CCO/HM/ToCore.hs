module CCO.HM.ToCore (
      toCore
) where

import CCO.HM.AG.ANormal
import CCO.HM.AG.HmCore
import CCO.HM.AG.BaseHelpers
import CCO.HM.Context
import CCO.Component
import CCO.Core.AG.Base

toCore :: Component ATm Mod
toCore = component $ \atm -> do
    let inh = Inh_ATm { context_Inh_ATm = Context [] bindNames }
        wtm = wrap_ATm (sem_ATm atm) inh
        binds :: [(Var, Bind)]
        binds = bindings_Syn_ATm wtm
        bindNames = map fst binds
        bindVals = map snd binds
    return $ Mod (code_Syn_ATm wtm) bindVals
