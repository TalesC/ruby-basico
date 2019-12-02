

# def conta_letras (texto, letra)
#     total_encontrado = 0
#     for  caractere in texto.chars
#         if caractere == letra
#             total_encontrado += 1
#         end
#     end
#     total_encontrado
# end

require_relative 'ui'

def chutou_uma_letra? (chute) 
    chute.size == 1
end

def chutou_letra (palavra_secreta, chute, erros)
    letra_procurada = chute
    #total_encontrado = conta_letras palavra_secreta, letra_procurada
    total_encontrado = palavra_secreta.count letra_procurada

    if total_encontrado > 0 
        avisa_letra_encontrada total_encontrado
    else
        avisa_letra_nao_encontrada
        erros += 1
    end

    erros
end

def pede_um_chute_valido (chutes, erros, mascara)
    cabecalho_de_tentativas chutes, erros, mascara
    loop do
        chute = pede_um_chute
        if chutes.include? chute
            avisa_chute_efetuado chute
        else
            return chute
        end
    end
end

def palavra_mascarada (palavra_secreta, chutes)
    mascara = ""
    for letra in palavra_secreta.chars
        if chutes.include? letra
            mascara << letra
        else
            mascara << "_"
        end
    end
    mascara
end


def joga(nome) 
    palavra_secreta = escolhe_palavra_secreta
    
    erros = 0
    chutes = []
    pontos_ate_agora = 0

    while erros < 5 
        
        mascara = palavra_mascarada palavra_secreta, chutes
        chute = pede_um_chute_valido chutes, erros, mascara
        chutes << chute
    
        if chutou_uma_letra? chute
            erros = chutou_letra palavra_secreta, chute, erros
        else
            acertou = chute == palavra_secreta
            if acertou
                avisa_acertou_palavra
                pontos_ate_agora += 100
                break
            else
                avisa_errou_palavra
                pontos_ate_agora -= 30
                erros += 1
            end        
        end
    end
    avisa_pontos pontos_ate_agora

end

def jogo_da_forca
    nome = dar_boas_vindas

    loop do
        joga nome    
        break if nao_que_jogar
    end
end