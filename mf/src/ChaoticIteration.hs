{-# LANGUAGE RecordWildCards #-}
module ChaoticIteration (
      chaoticIteration
) where

import Analysis
import AG.AttributeGrammar
import Properties as Prop

import Data.Map (Map)
import qualified Data.Map as M

-- I am not entirely satisfied that we require the program here.
-- Perhaps AnalysisSpec a should be changed so that it contains all the necessary
-- information to perform the analysis.  This is possible, but what exactly this info
-- is will probably only become clear while implementing this function.
chaoticIteration :: Program' -> AnalysisSpec a -> AnalysisResult a
chaoticIteration (Program' procs stat) AnalysisSpec{..} = go pFlow array
  where
    pFlow = case direction of
      Forward -> flow stat
      Backward -> flowR stat
    pInit = Prop.init stat
    pLabels = labels stat
    array = map initArray pLabels
    initArray label = if label == pInit then extremal else bottom


    go workList array = if null workList then finalize array
      else let
        (l, l') = head workList
        newWorkList = tail workList
        al = array !! l
        al' = array !! l'
        fal = runUpdate update l al
        in if fal `leq` al' then
          let
          newArray = replaceNth l' (al' `combine` fal) array
          additionalFlows = [(l', l'') | (l', l'') <- pFlow ]
          in go (additionalFlows ++ workList) newArray
        else
          go newWorkList array

    finalize :: [a] -> AnalysisResult a
    finalize a i = a !! i

replaceNth :: Int -> a -> [a] -> [a]
replaceNth n newVal (x:xs)
 | n == 0 = newVal:xs
 | otherwise = x:replaceNth (n-1) newVal xs

runUpdate :: Update a -> Int -> a -> a
runUpdate (Monolithic f) = f
