require_relative "ui"

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
            return [linha, coluna_heroi]
        end
    end
end

def calcula_nova_posicao (heroi, direcao)
    heroi = heroi.dup

    movimentos = {
        "W" => [-1,0],
        "S" => [+1,0],
        "A" => [0,-1],
        "D" => [0,+1]
    }
    movimento = movimentos[direcao]
    heroi[0] += movimento[0]
    heroi[1] += movimento[1]
    heroi
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
    
    posicao = posicoes[0]
    mapa[linha][coluna] = " "
    novo_mapa[posicao[0]][posicao[1]] = "F"
end

def copia_mapa mapa
    novo_mapa = mapa.join("\n").tr("F", " ").split "\n"
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

def joga (nome)
    mapa = le_mapa 2

    while true
        desenha mapa
        direcao = pede_movimento
        heroi = encontrar_jogador mapa
        nova_posicao = calcula_nova_posicao heroi, direcao
        
        next if !posicao_valida? mapa, nova_posicao
              
        mapa[heroi[0]][heroi[1]] = " "
        mapa[nova_posicao[0]][nova_posicao[1]] = "H"

        mapa = move_fantasmas mapa
        
    end
end

def inicia_fogefoge
    nome = da_boas_vindas
    joga nome
end