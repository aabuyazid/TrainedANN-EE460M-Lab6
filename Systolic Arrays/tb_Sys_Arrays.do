force clk 0 0 ns, 1 1 ns -repeat 2 ns

force start         1 10 ns, 0 100 ns

force a00           30 0 ns
force a01           30 0 ns
force a02           30 0 ns
force a10           00 0 ns
force a11           30 0 ns
force a12           30 0 ns
force a20           00 0 ns
force a21           00 0 ns
force a22           30 0 ns
force b00           30 0 ns
force b01           B0 0 ns
force b02           00 0 ns
force b10           00 0 ns
force b11           30 0 ns
force b12           B0 0 ns
force b20           00 0 ns
force b21           00 0 ns
force b22           30 0 ns

run 1000000 ns