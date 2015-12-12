module CCO.HM.Compiler (
      compile
) where

import CCO.HM.Base
import CCO.Core.Base
import CCO.HM.ToANormal
import CCO.HM.ToCore
import CCO.HM.Sanitize
import CCO.Component
import Control.Arrow ((>>>))

compile :: Component Tm Mod
compile = sanitize >>> toANormal >>> toCore
