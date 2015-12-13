module CheapPrinter (
      cheapPrinter
) where

import CCO.Printing     (render_, pp, Printable)
import CCO.Component    (Component)
import Control.Arrow    (arr)

-- By not restricting the maximum width we speed the renderer up somewhat.
-- It's still not exactly fast, but at least it doesn't start backtracking exponentially.
cheapPrinter :: Printable a => Bool -> Component a String
cheapPrinter b = arr $ render_ width . pp
    where width = if b then 120 else 10000000
