module CCO.HM.Compiler (
      compile
) where

import CCO.HM.Base              (Root)
import CCO.Core.Base            (Mod)
import CCO.HM.Sanitize          (sanitize)
import CCO.HM.ToBNormal         (toBNormal)
import CCO.HM.AttachBuiltins    (attachBuiltins)
import CCO.HM.AddLaziness       (addLaziness)
import CCO.HM.AddForcing        (addForcing)
import CCO.HM.AnnotateTailCalls (annotateTailCalls)
import CCO.HM.ToCore            (toCore)
import CCO.Component            (Component)
import Control.Arrow            ((>>>))

-- | Compile a rooted Hindley-Milner term to a module.
compile :: Component Root Mod
compile = sanitize >>> toBNormal >>> attachBuiltins >>> annotateTailCalls >>> addLaziness >>> addForcing >>> toCore
