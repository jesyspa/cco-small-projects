module CCO.Diag.TypeError (
      TypeError(..)
) where

import CCO.SourcePos

data TypeError = GenericError SourcePos String
               deriving (Eq, Read)

