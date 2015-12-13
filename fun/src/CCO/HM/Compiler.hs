module CCO.HM.Compiler (
      compile
) where

import CCO.HM.Base
import CCO.Core.Base
import CCO.HM.Sanitize
import CCO.HM.AddLaziness
import CCO.HM.ToANormal
import CCO.HM.ToCore
import CCO.Component
import Control.Arrow ((>>>))

compile :: Component Tm Mod
compile = sanitize >>> addLaziness >>> toANormal >>> toCore
