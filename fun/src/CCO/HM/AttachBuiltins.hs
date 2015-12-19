module CCO.HM.AttachBuiltins (
      attachBuiltins
) where

import CCO.HM.AG.BNormal        (BRoot)
import CCO.HM.AG.AttachBuiltins (sem_BRoot)
import CCO.Component            (Component)
import Control.Arrow            (arr)

attachBuiltins :: Component BRoot BRoot
attachBuiltins = arr sem_BRoot

