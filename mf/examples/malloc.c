begin
    int x[4] ;
    *(x + 2) := 8 ;
    y := *x ;
    free(x) ;
end
