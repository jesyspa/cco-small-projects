module CCO.Compiler (
      compile
) where

import CCO.HM.Base                   (Root)
import CCO.Core.Base                 (Mod)
import CCO.HM.Sanitize               (sanitize)
import CCO.HM.ToBNormal              (toBNormal)
import CCO.BNormal.AttachBuiltins    (attachBuiltins)
import CCO.BNormal.AddLaziness       (addLaziness)
import CCO.BNormal.AddForcing        (addForcing)
import CCO.BNormal.AnnotateTailCalls (annotateTailCalls)
import CCO.BNormal.ToCore            (toCore)
import CCO.Component                 (Component)
import Control.Arrow                 ((>>>))

-- | Compile a rooted Hindley-Milner term to a module.
compile :: Component Root Mod
compile = sanitize >>> toBNormal >>> attachBuiltins >>> annotateTailCalls >>> addLaziness >>> addForcing >>> toCore
