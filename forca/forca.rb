

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

def salva_rank (nome, pontos_totais)
    conteudo = "#{nome}\n#{pontos_totais}"
    File.write "rank.txt", conteudo
end

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

    arquivo = File.new("dicionario.txt")
    puts "###################################"
    puts arquivo.gets.to_i

    quantidade_de_palavras = arquivo.gets.to_i
    numero_aleatorio = rand(quantidade_de_palavras)
    for linha in 1..(numero_aleatorio -1)
        arquivo.gets
    end
    palavra_secreta = arquivo.gets.strip.downcase    
    arquivo.close
    
    avisa_palavra_escolhida palavra_secreta
end

def joga  
    erros = 0
    chutes = []
    pontos_ate_agora = 0

    while erros < 5 
        palavra_secreta = escolhe_palavra_secreta_sem_consumir_muita_memoria
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

    loop do
        pontos_totais += joga
        avisa_pontos_totais pontos_totais
        salva_rank nome, pontos_totais
        break if nao_que_jogar
    end
end