module Analysis where

data Direction = Forward | Backward
               deriving (Eq, Ord, Read, Show)

data Update a = Monolithic (Int -> a -> a)
              | Composite { remove :: a -> a -> a
                          , gen :: Int -> a
                          , kill :: Int -> a
                          }

data AnalysisSpec a = AnalysisSpec
                    { combine :: a -> a -> a
                    , leq :: a -> a -> Bool
                    , direction :: Direction
                    , bottom :: a
                    , extremal :: a
                    , update :: Update a
                    }

type AnalysisResult a = Int -> a

data Analysis p a = Analysis (p -> AnalysisSpec a) (AnalysisResult a -> p -> p)
