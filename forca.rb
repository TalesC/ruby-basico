def dar_boas_vindas 
    puts "Bem vindo ao jogo da forca."
    puts "Qual seu nome?"
    nome = gets.strip
    puts "\n\n\n\n\n\n"
    puts "Começaremos o jogo para você, #{nome}"
end

def escolhe_palavra_secreta
    puts "Escolhendo uma palavra secreta..."
    palavra_secreta = "programador"
    puts "Palavra secreta com #{palavra_secreta.size} letras ... boa sorte!"
    palavra_secreta
end

def nao_que_jogar 
    puts "Deseja jogar novamente? (S/N)"
    quero_jogar = gets.strip
    nao_que_jogar = quero_jogar.upcase != "S"
end

def pede_um_chute(chutes, erros)
    puts "\n\n\n\n"
    puts "Erros até agora: #{erros}"
    puts "Chutes até agora: #{chutes}"
    puts "Entre com uma letra ou uma palavra!"
    chute = gets.strip
    puts "Será que acertou? Você chutou #{chute}"
    chute
end

def chutou_uma_letra? (chute) 
    chute.size == 1
end



def chutou_letra (palavra_secreta, chute, erros)
    letra_procurada = chute
    #total_encontrado = conta_letras palavra_secreta, letra_procurada
    total_encontrado = palavra_secreta.count letra_procurada

    if total_encontrado > 0 
        puts "Letra encontrada #{total_encontrado} vezes."
    else
        puts "Letra não encontrada"
        erros += 1
    end

    erros
end

# def conta_letras (texto, letra)
#     total_encontrado = 0
#     for  caractere in texto.chars
#         if caractere == letra
#             total_encontrado += 1
#         end
#     end
#     total_encontrado
# end


def joga(nome) 
    palavra_secreta = escolhe_palavra_secreta
    
    erros = 0
    chutes = []
    pontos_ate_agora = 0

    while erros < 5 
        chute = pede_um_chute chutes, erros
        if chutes.include? chute
            puts "\nVocê ja chutou #{chute}"
            next
        end
        chutes << chute
    
        if chutou_uma_letra? chute
            erros = chutou_letra palavra_secreta, chute, erros
        else
            acertou = chute == palavra_secreta
            if acertou
                puts "Parabéns! Acertou!"
                pontos_ate_agora += 100
                break
            else
                puts "Que pena ... errou."
                pontos_ate_agora -= 30
                erros += 1
            end        
        end

    end
    puts "Você ganhou #{pontos_ate_agora} pontos."

end

nome = dar_boas_vindas

loop do
    joga nome    
    break if nao_que_jogar
end