module testbench;

reg clk;
reg d;
wire q;

// Instanciação do flip-flop D
d_flip_flop uut(
    .clk(clk), 
    .d(d), 
    .q(q)
);

initial begin
    // Inicialização
    clk = 0;
    d = 0;

    // Dump de variáveis para o arquivo VCD
    $dumpfile("dump.vcd");
    $dumpvars(1);

    // Testes
    #10 d = 1;
    #10 d = 0;
    #10 d = 1;
    #10 d = 0;

    // Termina a simulação após um determinado período
    #50 $finish;
end

// Gerador de clock
always #5 clk = ~clk;

endmodule
