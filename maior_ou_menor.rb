
def dar_boas_vindas 
    puts "Bem vindo ao jogo da adivinhação"
    puts "Qual é o seu nome"
    nome = gets.strip
    3.times {puts}
    puts "Começaremos o jogo para vocẽ, #{nome}"
    nome
end 

def pede_dificuldade 
    puts "Qual o nível de dificuldade que deseja? (1 fácil, 5 difícil)"
    dificuldade = gets.to_i
end

def sortei_numero_secreto (dificuldade)
    maximo = define_maximo dificuldade
    puts "Escolhendo um numero secreto entre 0 e #{maximo -1} ..."
    sorteado = rand(maximo)
    puts "Escolhido... que tal advinhar hoje nosso numero?"
    sorteado
end

def define_maximo (dificuldade) 
    case dificuldade 
    when 1
        30
    when 2
        60
    when 3
        100
    when 4
        150
    else
        200    
    end
end    

def pede_um_numero(chutes, tentativa, limite_de_tentativas)
    puts "Tentativa #{tentativa} de #{limite_de_tentativas}"
    puts "Chutes até agora: #{chutes}" if chutes.size > 0
    puts "Entre com o numero"
    chute = gets.strip
    puts "Será que acertou? Você chutou " + chute
    chute.to_i
end

def verifica_acerto (chute, numero_secreto)
    acertou = chute == numero_secreto
    if acertou
        puts "Acertou!!"
        return true
    end

    maior = chute < numero_secreto
    if maior 
       puts "Numero secreto é maior!!"
    else
       puts "Numero secreto é menor!!"
    end
    false
end

def jogar (nome_cheat, dificuldade)
    pontos_ate_agora = 1000
    numero_secreto = sortei_numero_secreto dificuldade
    limite_de_tentativas = 5

    chutes = []

    for tentativa in 1..limite_de_tentativas
        2.times {puts}
        chute = pede_um_numero chutes,tentativa, limite_de_tentativas
        chutes << chute

        if nome_cheat == "Tales de Mileto"
            puts="Acertou!!"
            break
        end

        pontos_a_perder = (chute - numero_secreto).abs / 2.0
        pontos_ate_agora -= pontos_a_perder

        break if verifica_acerto chute, numero_secreto 
    end

    puts "Você ganhou #{pontos_ate_agora} pontos."
end

def nao_quer_jogar?
    puts "Deseja jogar novamente? (S/N)"
    nao_quer_jogar = gets.strip
    nao_quer_jogar.upcase != "S"
end

nome_cheat = dar_boas_vindas
dificuldade = pede_dificuldade

loop do
    jogar nome_cheat, dificuldade
    if nao_quer_jogar?
        break
    end
end
