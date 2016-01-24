begin
    proc incr(val x, res y) is
      y := x + 1;
    end

    proc decr(val x, res y) is
      y := x - 1;
    end

    x := 1;

    call incr(x, x);
    call decr(x, x);
    call incr(x, x);

    a := x;
end
