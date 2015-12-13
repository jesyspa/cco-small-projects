module CCO.HM.AttachBuiltins (
      attachBuiltins
) where

import CCO.HM.AG.BNormal
import CCO.HM.AG.AttachBuiltins
import CCO.HM.Builtins
import CCO.Component

attachBuiltins :: Component BRoot BRoot
attachBuiltins = component $ \br -> do
     return $ code_Syn_BRoot $ wrap_BRoot (sem_BRoot br) Inh_BRoot

