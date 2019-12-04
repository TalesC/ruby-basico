

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
require_relative 'rank'


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

def escolhe_palavra_secreta
    avisa_escolhendo_palavra

    texto = File.read("dicionario.txt")
    todas_as_palavras = texto.split "\n"
    numero_aleatorio = rand(todas_as_palavras.size)
    palavra_secreta = todas_as_palavras[numero_aleatorio].downcase
    
    avisa_palavra_escolhida palavra_secreta
end

def escolhe_palavra_secreta_sem_consumir_muita_memoria
    avisa_escolhendo_palavra

    arquivo = File.open("dicionario.txt")
    quantidade_de_palavras = arquivo.readlines.size
    numero_aleatorio = rand(quantidade_de_palavras)
    arquivo.close

    arquivo = File.open("dicionario.txt")
    palavra_secreta = arquivo.readlines[numero_aleatorio].strip.downcase    
    arquivo.close
    
    avisa_palavra_escolhida palavra_secreta
end

def joga  
    erros = 0
    chutes = []
    pontos_ate_agora = 0

    palavra_secreta = escolhe_palavra_secreta_sem_consumir_muita_memoria

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
    pontos_ate_agora
end

def jogo_da_forca
    nome = dar_boas_vindas
    pontos_totais = 0
    campeao = le_rank

    avisa_campeao_atual campeao

    loop do
        pontos_totais += joga
        avisa_pontos_totais pontos_totais

        if(campeao[1].to_i < pontos_totais) 
            salva_rank nome, pontos_totais
        end

        break if nao_que_jogar
    end
end