module ConstantPropagation (
      constantPropagationAnalysis
) where

import AG.AttributeGrammar
import AG.ConstantPropagation
import Analysis
import qualified Data.Map as M

constantPropagationAnalysis :: Program' -> AnalysisSpec (M.Map String Int)
constantPropagationAnalysis prog = AnalysisSpec (M.mergeWithKey comb kill kill) leq Forward M.empty M.empty update
    where comb _ x y | x == y = Just x
                     | otherwise = Nothing
          leq = (<=)
          kill = const M.empty
          update = Monolithic $ \x -> M.findWithDefault id x (sem_Program' prog)
