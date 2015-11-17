import CCO.Component  (Component, component, printer, ioWrap)
import CCO.Tree       (Tree (fromTree, toTree), parser)
import CCO.Diag       (Diag)
import CCO.Picture    (Picture)
import Control.Arrow  (Arrow (arr), (>>>))

tdiag2picture :: Component Diag Picture
tdiag2picture = undefined

main = ioWrap (parser >>> component toTree >>> tdiag2picture >>> arr fromTree >>> printer)
