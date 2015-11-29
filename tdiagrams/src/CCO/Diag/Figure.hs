module CCO.Diag.Figure (
      Point(..)
    , (|+|)
    , (|-|)
    , translate, translatePair
    , rUProgram, cUProgram, rPPlatform, rUInterpreter, rPInterpreter, cUInterpreter, rUCompiler, cUCompiler, cPCompiler
) where

data Point = Point Double Double
           deriving (Eq, Ord, Read, Show)

-- | Plus and minus operators for points
(|+|), (|-|) :: Point -> Point -> Point
Point x1 y1 |+| Point x2 y2 = Point (x1 + x2) (y1 + y2)
Point x1 y1 |-| Point x2 y2 = Point (x1 - x2) (y1 - y2)

-- | Calculate the translation of a single point, this is used to recalculate the
--  position in Execute diagrams
translate :: Point -> (Double, Double) -> (Double, Double)
translate (Point x y) (a, b) = (a + x, b + y)

-- | Calculate the translation of a pair of points, this is used to recalculate the
--  position in Compile diagrams
translatePair :: Point -> (Point, Point) -> (Point, Point)
translatePair p (a, b) = (a |+| p, b |+| p)
-- Base points for simple diagrams
rUProgram :: Point
rUProgram = Point 7.5 0
cUProgram :: (Point, Point)
cUProgram = (Point 57.5 0, Point 7.5 0)

rPPlatform :: Point
rPPlatform = Point 0 30

rUInterpreter :: Point
rUInterpreter = Point 0 0
rPInterpreter :: Point
rPInterpreter = Point 0 30
cUInterpreter :: (Point, Point)
cUInterpreter = (Point 50 0, Point 0 0)

rUCompiler :: Point
rUCompiler = Point 50 0
cUCompiler :: (Point, Point)
cUCompiler = (Point 100 0, Point 50 0)
cPCompiler :: (Point, Point)
cPCompiler = (Point 0 20, Point 150 20)
