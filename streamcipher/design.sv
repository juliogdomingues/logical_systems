module streamcipher (
    input clk, // Clock de entrada
    input reset, // Sinal de reset
    input loadControl, // Sinal de controle de carregamento
    input shiftControl, // Sinal de controle de deslocamento
    input [7:0] dataInput, // Dado de entrada de 8 bits
    output reg dataOutputEnabled, // Indicador de saída de dados habilitada
    output reg dataShifted, // Indicador de dado deslocado
    output reg [7:0] dataOutput // Dado de saída de 8 bits
);

    localparam MAX_BIT = 7, MIN_BIT = 0, DEFAULT_REG_VALUE = 8'b11111111;

    wire edgeBitXOR; // XOR dos bits de borda
    wire shiftedBitXOR;

    assign edgeBitXOR = (dataOutput[MIN_BIT] ^ dataOutput[MIN_BIT + 1]);
    assign shiftedBitXOR = (dataOutput[MAX_BIT] ^ dataOutput[MAX_BIT - 1]);

    always @(posedge clk) begin
        if (reset) begin
            // Reinicializa o registrador
            dataOutput <= DEFAULT_REG_VALUE;
            dataOutputEnabled <= 0;
            dataShifted <= 0;
        end
        else if (loadControl && shiftControl) begin
            // Carrega dados e ativa deslocamento
            dataOutputEnabled <= dataInput[MAX_BIT];
            dataShifted <= dataInput[MIN_BIT];
            dataOutput <= dataInput;
        end
        else if (loadControl && !shiftControl) begin
            // Carrega dados sem deslocamento
            dataOutputEnabled <= dataOutput[MAX_BIT];
            dataOutput <= {dataOutput[MAX_BIT - 1:MIN_BIT], shiftedBitXOR};
        end
        else if (!loadControl && shiftControl) begin
            // Ativa deslocamento sem carregar dados
            dataShifted <= dataOutput[MIN_BIT];
            dataOutput <= {edgeBitXOR, dataOutput[MAX_BIT:MIN_BIT + 1]};
        end
    end
endmodule

