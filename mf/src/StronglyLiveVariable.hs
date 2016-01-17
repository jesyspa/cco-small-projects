module StronglyLiveVariable (
      stronglyLiveVariableAnalysis
) where

import AG.AttributeGrammar
import AG.StronglyLiveVariable
import Analysis
import qualified Data.Map as M
import qualified Data.Set as S
import Properties

stronglyLiveVariableAnalysis :: Program' -> AnalysisSpec (S.Set String)
stronglyLiveVariableAnalysis prog = AnalysisSpec S.union leq Backward allNames allNames update
    where update = Monolithic $ \x -> M.findWithDefault id x (sem_Program' prog)
          allNames = names prog
          leq = (<=)
