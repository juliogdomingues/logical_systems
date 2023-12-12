module d_flip_flop_desc(d, clk, q, notq);
  input d, clk;
  output q, notq;

  wire w1, w2;

  // Combina d e clk
  nand U1(w1, d, clk);

  // Combina x e clk para comportamento de latch
  nand U2(w2, w1, clk);

  // Combina x e notq para produzir q
  nand U3(q, notq, w1);

  // Combina q e y para produzir qbar
  nand U4(notq, q, w2);
endmodule
