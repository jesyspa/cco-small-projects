module ChaoticIteration (
      chaoticIteration
) where

import Analysis

-- I am not entirely satisfied that we require the program here.
-- Perhaps AnalysisSpec a should be changed so that it contains all the necessary
-- information to perform the analysis.  This is possible, but what exactly this info
-- is will probably only become clear while implementing this function.
chaoticIteration :: Program' -> AnalysisSpec a -> AnalysisResult a
chaoticIteration = error "Hi Giovanni, I left this for you to implement.  Have fun!"

