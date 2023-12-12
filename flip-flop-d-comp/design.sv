`timescale 1ns / 1ps

module d_flip_flop(
    input clk,  // Clock
    input d,    // Entrada de dados
    output reg q // Saída
);

// Lógica do flip-flop D
always @(posedge clk) begin
    q <= d;
end

endmodule
