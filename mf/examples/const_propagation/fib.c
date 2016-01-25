begin
  proc fib(val x, res z) is
      if (x == 0 or x == 1)
      then z := 1 ;
      else {
        step := 1 ;
        prec := x - step ;

        call fib(prec,y) ;
        call fib(prec-step,z) ;
        z := z + y ;
      }
  end

  x := 5 ;
  call fib(x, y) ;
end
