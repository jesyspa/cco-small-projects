module CCO.Diag.Figure (
      (|+|)
    , (|-|)
    , zero
    , translate, translatePair
    , trProgram, trPlatform, trInterpreter, trCompiler
    , rUProgram, cUProgram, rPPlatform, rUInterpreter, rPInterpreter, cUInterpreter, rUCompiler, cUCompiler, cPCompiler
    , maxPointwise, minPointwise
) where

import CCO.Diag.AG.MakePictureHelpers

-- | Plus and minus operators for points
(|+|), (|-|) :: Point -> Point -> Point
(x1, y1) |+| (x2, y2) = (x1 + x2, y1 + y2)
(x1, y1) |-| (x2, y2) = (x1 - x2, y1 - y2)

-- | Calculate the translation of a single point, this is used to recalculate the
--  position in Execute diagrams
translate :: Point -> (Double, Double) -> (Double, Double)
translate (x, y) (a, b) = (a + x, b + y)

-- | Calculate the translation of a pair of points, this is used to recalculate the
--  position in Compile diagrams
translatePair :: Point -> (Point, Point) -> (Point, Point)
translatePair p (a, b) = (a |+| p, b |+| p)

-- | Pointwise version of max and min
maxPointwise, minPointwise :: Point -> Point -> Point
maxPointwise (x1, y1) (x2, y2) = (x1 `max` x2, y1 `max` y2)
minPointwise (x1, y1) (x2, y2) = (x1 `min` x2, y1 `min` y2)

-- Base points for simple diagrams
rUProgram :: Point
rUProgram = (7.5, 0)
cUProgram :: (Point, Point)
cUProgram = ((57.5, 0), (7.5, 0))

rPPlatform :: Point
rPPlatform = (0, 30)

rUInterpreter :: Point
rUInterpreter = (0, 0)
rPInterpreter :: Point
rPInterpreter = (0, 30)
cUInterpreter :: (Point, Point)
cUInterpreter = ((50, 0), (0, 0))

rUCompiler :: Point
rUCompiler = (50, 0)
cUCompiler :: (Point, Point)
cUCompiler = ((100, 0), (50, 0))
cPCompiler :: (Point, Point)
cPCompiler = ((0, 20), (150, 20))

zero :: Point
zero = (0, 0)

trProgram, trPlatform, trInterpreter, trCompiler :: Point
trProgram = (65, 30)
trPlatform = (50, 30)
trInterpreter = (50, 30)
trCompiler = (150, 30)
