module CCO.BNormal.AttachBuiltins (
      attachBuiltins
) where

import CCO.BNormal.AG.BNormal        (BRoot)
import CCO.BNormal.AG.AttachBuiltins (sem_BRoot)
import CCO.Component                 (Component)
import Control.Arrow                 (arr)

-- | Add the definitions of built-ins to the output.
attachBuiltins :: Component BRoot BRoot
attachBuiltins = arr sem_BRoot

