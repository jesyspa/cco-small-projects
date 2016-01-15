module Analysis where

data Direction = Forward | Backward
               deriving (Eq, Ord, Read, Show)

data Update a = Monolithic (Int -> a -> a)
              | Composite { remove :: a -> a -> a
                          , gen :: Int -> a
                          , kill :: Int -> a
                          }

data Analysis a = Analysis
                { combine :: a -> a -> a
                , direction :: Direction
                , bottom :: a
                , extremal :: a
                , update :: Update a
                }
