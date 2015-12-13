module CCO.HM.ToCore (
      toCore
) where

import CCO.HM.AG.ANormal
import CCO.HM.AG.HmCore
import CCO.HM.AG.BaseHelpers
import CCO.HM.Context
import CCO.Component
import CCO.Core.AG.Base

toCore :: Component ARoot Mod
toCore = component $ \ar -> do
    let wr = wrap_ARoot (sem_ARoot ar) Inh_ARoot
    return $ code_Syn_ARoot wr
