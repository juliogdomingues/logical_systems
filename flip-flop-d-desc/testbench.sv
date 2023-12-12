module testbench;

  // Instancia o flip-flop D implementado com portas NAND
  d_flip_flop_desc df1(d, clk, q, notq);

  // Variáveis de entrada e saída
  reg d, clk;
  wire q, notq;

  initial begin
    // Grava os sinais em um arquivo de dump
    $dumpfile("dump.vcd");
    $dumpvars(1);

    // Inicializa variáveis
    clk = 0;
    d = 0;

    // Aplicação de estímulo no sinal de dados
    #50 d = 1;
    #50 d = 0;

    // Finaliza simulação após 150 unidades de tempo
    #50 $finish;
  end

  // Geração do sinal de clock
  always #2 clk = ~clk;
endmodule
