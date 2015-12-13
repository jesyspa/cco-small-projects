module CCO.HM.AttachBuiltins (
      attachBuiltins
) where

import CCO.HM.AG.BNormal
import CCO.HM.AG.AttachBuiltins
import CCO.HM.Builtins
import CCO.Component
import Control.Arrow (arr)

attachBuiltins :: Component BRoot BRoot
attachBuiltins = arr sem_BRoot

