import CCO.Component  (Component, component, printer, ioWrap)
import CCO.Tree       (Tree (fromTree, toTree), parser)
import CCO.Diag       (Diag)
import CCO.Picture    (Picture(..))
import Control.Arrow  (Arrow (arr), (>>>))
import CCO.Diag.AG.MakePicture

tdiag2picture :: Component Diag Picture
tdiag2picture = arr $ \x -> Picture (200, 200) $ code_Syn_Diag $ wrap_Diag (sem_Diag x) $ Inh_Diag

main = ioWrap (parser >>> component toTree >>> tdiag2picture >>> arr fromTree >>> printer)
