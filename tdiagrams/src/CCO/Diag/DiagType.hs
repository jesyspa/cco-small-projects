module CCO.Diag.DiagType (
      DiagType(..)
    , nullType
    , TypeError(..)
) where

-- | Any object can support up to three operations, with each being
-- permitted one "language".
data DiagType = DiagType { canRunOn :: Maybe String, canRun :: Maybe String, canCompile :: Maybe (String, String)}
-- Remark: we allow a composite diagram to be compiled.  Whether this makes
-- any sense is questionable, but it is permitted by the typing rules
-- presented.

-- data DiagType = Program String | Platform String | Interpreter String String | Compiler String String String | Something

nullType :: DiagType
nullType = DiagType Nothing Nothing Nothing

data TypeError = GenericError String
               deriving (Eq, Ord, Read, Show)
