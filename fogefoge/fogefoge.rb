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
    case direcao
        when "W"
            heroi[0] -=1
        when "S"
            heroi[0] +=1
        when "A"
            heroi[1] -=1
        when "D"
            heroi[1] +=1
    end
    heroi
end

def posicao_valida? mapa, posisao
    linhas = mapa.size
    colunas = mapa[0].size
    estourou_linhas = posisao[0] < 0 || posisao[0] >= linhas
    estourou_colunas = posisao[1] < 0 || posisao[1] >= colunas

    if estourou_linhas || estourou_colunas
        false
    end
    if mapa[posisao[0]][posisao[1]] == "X"
        false
    end
    true
end

def joga (nome)
    mapa = le_mapa 1

    while true
        desenha mapa
        direcao = pede_movimento
        heroi = encontrar_jogador mapa
        nova_posicao = calcula_nova_posicao [heroi[0], heroi[1]], direcao
        
        next if !posicao_valida? mapa, nova_posicao
              
        mapa[heroi[0]][heroi[1]] = " "
        mapa[nova_posicao[0]][nova_posicao[1]] = "H"
    end
end

def inicia_fogefoge
    nome = da_boas_vindas
    joga nome
end