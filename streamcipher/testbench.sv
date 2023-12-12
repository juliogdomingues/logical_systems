module test;
    reg [63:0] encryptedMessage; // Armazena a mensagem cifrada
    reg [63:0] decryptedMessage; // Armazena a mensagem decifrada
    reg [63:0] originalMessage;  // Armazena a mensagem original

    reg clk; // Sinal de clock
    reg reset; // Sinal de reset
    reg controlSignal1; // Sinal de controle 1
    reg controlSignal2; // Sinal de controle 2
    reg [7:0] key; // Chave de entrada
    wire keyBitOutput; // Bit de saída da chave

    integer index; // Variável auxiliar para laços

    streamcipher otp(
        .clk(clk),
        .reset(reset),
        .loadControl(controlSignal1),
        .shiftControl(controlSignal2),
        .dataInput(key),
        .dataShifted(keyBitOutput)
    );

    // Inverte o sinal de clock a cada 10 unidades de tempo
    always #10 clk = ~clk;

    initial begin
        reset = 1'b1; // Ativa o reset para inicializar o módulo
        #10 reset = 1'b0; // Desativa o reset após inicialização

        $dumpfile("dump.vcd");
        $dumpvars;

        clk = 1'b0;
        
        // Configura a chave
        setKey(8'b11110000); 

        // Mensagem a ser cifrada: "ISL UFMG"
        originalMessage = 64'b01001001_01010011_01001100_00100000_01010101_01000110_01001101_01000111;

        // Cifra a mensagem
        encryptMessage(originalMessage);
        
        // Redefine a chave para decifração
        setKey(8'b11110000); 

        // Decifra a mensagem
        decryptMessage(encryptedMessage);

        // Exibe os resultados
        displayResults;

        $finish;
    end
    
    // Tarefa para configurar a chave
    task setKey(input [7:0] seed);
    begin
        controlSignal1 = 1'b1;
        controlSignal2 = 1'b1;
        key = seed;
        #20 controlSignal1 = 1'b0; // Desativa o sinal
    end
    endtask

    // Tarefa para cifrar a mensagem
    task encryptMessage(input [63:0] msg);
    begin
        for (index = 63; index >= 0; index = index - 1) begin
            #20 encryptedMessage[index] = msg[index] ^ keyBitOutput; // Cifragem XOR
        end
    end
    endtask 

    // Tarefa para decifrar a mensagem cifrada
    task decryptMessage(input [63:0] msg);
    begin
        for (index = 63; index >= 0; index = index - 1) begin
            #20 decryptedMessage[index] = msg[index] ^ keyBitOutput; // Decifragem XOR
        end
    end
    endtask

    // Tarefa para exibir os resultados
    task displayResults;
    begin
      $display("\nMensagem Cifrada: %s", encryptedMessage);
      $display("Mensagem Original: %s", originalMessage);
      $display("Mensagem Decifrada: %s", decryptedMessage);
    end
    endtask
        
endmodule
