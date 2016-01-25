{-# LANGUAGE RecordWildCards #-}
module Analysis where

import Text.PrettyPrint
import qualified Data.Map as M

-- | An update strategy.
--
-- Depending on the kind of analysis, it may be beneficial to regard updates as
-- monolithic (updating the state), or by specifying what variables are killed
-- and generated and deducing it from that.
--
-- At least, that's the theory.  In practice, it turned out that writing
-- everything monolithically was much more convenient.
data Update a = Monolithic (Int -> a -> a)
              | Composite { remove :: a -> a -> a
                          , gen :: Int -> a
                          , kill :: Int -> a
                          }

-- | A specification for an analysis.
--
-- This provides all the data necessary for the algorithm.
data AnalysisSpec a = AnalysisSpec
                    { combine :: a -> a -> a
                    , leq :: a -> a -> Bool
                    , flowGraph :: [(Int, Int)]
                    , procFlowGraph :: [((Int, Int), (Int, Int))]
                    , procBodies :: M.Map Int [(Int, Int)]
                    , entries :: [Int]
                    , labels :: [Int]
                    , bottom :: a
                    , extremal :: a
                    , update :: Update a
                    , pp :: a -> Doc
                    }

-- | Flag for distinguishing between entry and exit analysis values.
data Side = Entry | Exit
          deriving (Eq, Ord, Read, Show)

-- | The data the analysis produces.
type AnalysisResult a = Int -> Side -> a

-- | A spec for performing the analysis and a function for applying the result.
data Analysis p a = Analysis (p -> AnalysisSpec a) (AnalysisResult a -> p -> p)

-- Update the state.
runUpdate :: Update a -> (a -> a -> a) -> Int -> a -> a
runUpdate (Monolithic f) _ i x = f i x
runUpdate Composite{..} cmb i x = (x `remove` kill i) `cmb` gen i
