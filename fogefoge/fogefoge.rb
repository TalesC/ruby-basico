require_relative "ui"
require_relative "heroi"

def le_mapa(numero)
    arquivo = "mapa#{numero}.txt"
    texto = File.read arquivo
    mapa = texto.split "\n"
end

def encontrar_jogador(mapa)
    heroi = "H"
    mapa.each_with_index do |linha_atual, linha|
        coluna_heroi = linha_atual.index heroi
        if coluna_heroi
            jogador = Heroi.new
            jogador.linha = linha
            jogador.coluna = coluna_heroi
            return jogador
        end
    end
    nil
end

def posicao_valida? mapa, posisao
    linhas = mapa.size
    colunas = mapa[0].size
    estourou_linhas = posisao[0] < 0 || posisao[0] >= linhas
    estourou_colunas = posisao[1] < 0 || posisao[1] >= colunas

    if estourou_linhas || estourou_colunas
        return false
    end

    valor_atual = mapa[posisao[0]][posisao[1]]
    if valor_atual == "X" || valor_atual == "F"
        return false
    end

    true
end

def posicoes_validas_a_partir_de_mapa mapa, novo_mapa, posicao
    baixo = [posicao[0] +1, posicao[1]]
    direita = [posicao[0] , posicao[1] +1]
    cima = [posicao[0] -1, posicao[1]]
    esquerda = [posicao[0] , posicao[1] -1]

    posicoes = [baixo, direita, cima, esquerda]
    posicoes.delete_if{ |p| ((!posicao_valida? mapa, p) || (!posicao_valida? novo_mapa, p)) }
end

def move_fantasma mapa, novo_mapa, linha, coluna
    posicoes = posicoes_validas_a_partir_de_mapa mapa, novo_mapa, [linha, coluna]
    return if posicoes.empty?
    
    aleatoria = rand posicoes.size
    posicao = posicoes[aleatoria]
    mapa[linha][coluna] = " "
    novo_mapa[posicao[0]][posicao[1]] = "F"
end

def copia_mapa mapa
    novo_mapa = mapa.join("\n").tr("F", " ").split "\n"
end

def jogador_perdeu? mapa
    perdeu = !(encontrar_jogador mapa)
end

def move_fantasmas mapa
    caractere_do_fantasma = "F"
    novo_mapa = copia_mapa mapa
    mapa.each_with_index do |linha_atual, linha|
        linha_atual.chars.each_with_index do |caractere_atual, coluna|
            eh_fantasma = caractere_atual == caractere_do_fantasma
            if eh_fantasma
                move_fantasma mapa, novo_mapa, linha, coluna
            end
        end
    end
    novo_mapa
end

def executa_remocao mapa, posicao, quantidade
    if mapa[posicao.linha][posicao.coluna] == "X"
        return
    end
    posicao.remove_do mapa
end

def remove mapa, posicao, quantidade 
    posicao = posicao.direita
    executa_remocao mapa, posicao.direita, quantidade
    executa_remocao mapa, posicao.esquerda, quantidade
    executa_remocao mapa, posicao.cima, quantidade
    executa_remocao mapa, posicao.baixo, quantidade
    if(quantidade > 0)
        remove mapa, posicao, quantidade -1
    end
end

def joga (nome)
    mapa = le_mapa 4

    while true
        desenha mapa
        direcao = pede_movimento
        heroi = encontrar_jogador mapa
        nova_posicao = heroi.calcula_nova_posicao direcao
        
        if !posicao_valida? mapa, nova_posicao.to_array
            next
        end   

        heroi.remove_do mapa
        if mapa[nova_posicao.linha][nova_posicao.coluna] == "*"
            remove mapa, nova_posicao, 4
        end
        nova_posicao.coloca_no mapa

        mapa = move_fantasmas mapa
        if jogador_perdeu? mapa
            game_over
            break
        end

    end
end

def inicia_fogefoge
    nome = da_boas_vindas
    joga nome
end