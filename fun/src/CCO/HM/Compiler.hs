module CCO.HM.Compiler (
      compile
) where

import CCO.HM.Base
import CCO.Core.Base
import CCO.HM.Sanitize
import CCO.HM.ToBNormal
import CCO.HM.AttachBuiltins
import CCO.HM.AddLaziness
import CCO.HM.AddForcing
import CCO.HM.AnnotateTailCalls
import CCO.HM.ToCore
import CCO.Component
import Control.Arrow ((>>>))

compile :: Component Tm Mod
compile = sanitize >>> toBNormal >>> attachBuiltins >>> annotateTailCalls >>> addLaziness >>> addForcing >>> toCore
