//==================================================
// ENUMS
//==================================================

enum BossState
{
    dormindo,
    esperando,
    carregando,
    disparando,
    atingido,
    movendo,
    derrotado
}

enum BossAttack
{
    principal,
    cruz,
    diagonal,
    orbes
}


//==================================================
// VIDA E FASE
//==================================================

vida = 3;
fase = 1;

estado = BossState.dormindo;
ativado = false;
invulneravel = false;


//==================================================
// POSIÇÃO
//==================================================

posicao_base_x = x;
posicao_base_y = y;

alvo_x = x;


//==================================================
// ATAQUES
//==================================================

ataque_atual = BossAttack.principal;
indice_ataque = 0;

timer = 0;

intervalo_disparo = 80;
tempo_carregamento = 45;

maximo_projeteis = 8;


// Sequência previsível da primeira fase.
sequencia_fase_1 =
[
    BossAttack.principal,
    BossAttack.cruz,
    BossAttack.principal
];

// Sequência após o primeiro dano.
sequencia_fase_2 =
[
    BossAttack.cruz,
    BossAttack.diagonal,
    BossAttack.principal,
    BossAttack.orbes,
    BossAttack.cruz,
    BossAttack.principal
];


//==================================================
// ALVO DOS ATAQUES
//==================================================

// A cruz usa uma posição fixa registrada no começo
// do carregamento, não acompanha o player.
ataque_alvo_x = x;
ataque_alvo_y = y;


//==================================================
// GAME FEEL
//==================================================

idle_tempo = 0;
idle_offset_y = 0;

draw_offset_x = 0;
draw_offset_y = 0;

shake_timer = 0;
shake_forca = 0;

flash_timer = 0;

escala_x_visual = 1;
escala_y_visual = 1;

cor_visual = c_white;

derrota_timer = 0;


//==================================================
// SPRITE
//==================================================

image_speed = 0;
image_index = 0;


//==================================================
// CRIAR PROJÉTIL
//==================================================

criar_projetil = function(
    _x,
    _y,
    _vel_x,
    _vel_y,
    _pode_danificar_boss,
    _pode_multiplicar,
    _geracao
)
{
    if (
        instance_number(obj_boss_projectile)
        >= maximo_projeteis
    )
    {
        return noone;
    }

    var _tiro = instance_create_depth(
        _x,
        _y,
        depth - 1,
        obj_boss_projectile
    );

    (_tiro).vel_x = _vel_x;
    (_tiro).vel_y = _vel_y;

    (_tiro).refletido = false;

    (_tiro).pode_danificar_boss =
        _pode_danificar_boss;

    (_tiro).pode_multiplicar =
        _pode_multiplicar;

    (_tiro).geracao = _geracao;

    // Impede tiros que nasceram juntos de reagirem
    // imediatamente no ponto de criação.
    (_tiro).reacao_grace = 10;

    return _tiro;
};


//==================================================
// SELECIONAR PRÓXIMO ATAQUE
//==================================================

selecionar_proximo_ataque = function()
{
    var _sequencia;

    if (fase == 1)
    {
        _sequencia = sequencia_fase_1;
    }
    else
    {
        _sequencia = sequencia_fase_2;
    }

    ataque_atual =
        _sequencia[
            indice_ataque
            mod array_length(_sequencia)
        ];

    indice_ataque++;

    var _player = instance_find(
        obj_player,
        0
    );

    if (instance_exists(_player))
    {
        ataque_alvo_x = clamp(
            (_player).x + (_player).velh * 18,
            144,
            400
        );
        
        ataque_alvo_y = clamp(
            (_player).y + (_player).velv * 18,
            96,
            208
        );
    }

    switch (ataque_atual)
    {
        case BossAttack.principal:
        {
            tempo_carregamento = 45;
            break;
        }

        case BossAttack.cruz:
        {
            tempo_carregamento = 45;
            break;
        }

        case BossAttack.diagonal:
        {
            tempo_carregamento = 35;
            break;
        }

        case BossAttack.orbes:
        {
            tempo_carregamento = 50;
            break;
        }
    }
};


//==================================================
// ATAQUE PRINCIPAL
//==================================================

ataque_principal = function()
{
    // Este é o único tiro que pode causar dano
    // depois de ser refletido pela caixa.
    criar_projetil(
        x,
        y + 28,
        0,
        4,
        true,
        false,
        0
    );
};


//==================================================
// ATAQUE CRUZ
//==================================================

ataque_cruz = function()
{
    var _vel = 2;

    // Os tiros já nascem afastados do centro,
    // evitando colisão instantânea entre eles.
    criar_projetil(
        ataque_alvo_x - 10,
        ataque_alvo_y,
        -_vel,
        0,
        false,
        false,
        0
    );

    criar_projetil(
        ataque_alvo_x + 10,
        ataque_alvo_y,
        _vel,
        0,
        false,
        false,
        0
    );

    criar_projetil(
        ataque_alvo_x,
        ataque_alvo_y - 10,
        0,
        -_vel,
        false,
        false,
        0
    );

    criar_projetil(
        ataque_alvo_x,
        ataque_alvo_y + 10,
        0,
        _vel,
        false,
        false,
        0
    );
};


//==================================================
// ATAQUE DIAGONAL
//==================================================

ataque_diagonal = function()
{
    var _vel = 4;

    // Quatro diagonais voltadas para a região
    // inferior da arena.
    var _direcoes =
    [
        220,
        240,
        300,
        320
    ];

    for (
        var _i = 0;
        _i < array_length(_direcoes);
        _i++
    )
    {
        var _dir = _direcoes[_i];

        criar_projetil(
            x,
            y + 24,
            lengthdir_x(_vel, _dir),
            lengthdir_y(_vel, _dir),
            false,
            false,
            0
        );
    }
};


//==================================================
// ATAQUE DOS ORBES
//==================================================

ataque_orbes = function()
{
    // Cantos úteis da arena superior.
    var _posicoes =
    [
        [144, 80,  1],
        [400, 80,  1],
        [144, 208, -1],
        [400, 208, -1]
    ];

    for (
        var _i = 0;
        _i < array_length(_posicoes);
        _i++
    )
    {
        var _orb = instance_create_depth(
            _posicoes[_i][0],
            _posicoes[_i][1],
            depth - 1,
            obj_boss_orb
        );

        (_orb).direcao_vertical =
            _posicoes[_i][2];

        (_orb).boss_id = id;
    }
};


//==================================================
// EXECUTAR ATAQUE
//==================================================

executar_ataque = function()
{
    switch (ataque_atual)
    {
        case BossAttack.principal:
        {
            ataque_principal();
            break;
        }

        case BossAttack.cruz:
        {
            ataque_cruz();
            break;
        }

        case BossAttack.diagonal:
        {
            ataque_diagonal();
            break;
        }

        case BossAttack.orbes:
        {
            ataque_orbes();
            break;
        }
    }

    // Pequeno recuo visual.
    escala_x_visual = 1.08;
    escala_y_visual = 0.92;

    flash_timer = 5;
};


//==================================================
// MÁQUINA DE ESTADOS
//==================================================

maquina_de_estado = function()
{
    switch (estado)
    {
        case BossState.dormindo:
        {
            if (!ativado)
            {
                var _player = instance_find(
                    obj_player,
                    0
                );

                var _caixa = instance_find(
                    obj_box,
                    0
                );

                if (
                    instance_exists(_player)
                    && instance_exists(_caixa)
                    && (_player).y < 240
                    && (_caixa).y < 240
                )
                {
                    ativado = true;

                    estado =
                        BossState.esperando;

                    timer = 90;

                    (_player).
                        limpar_historico_temporal();
                }
            }

            break;
        }


        case BossState.esperando:
        {
            timer--;

            if (
                timer <= 0
                && instance_number(
                    obj_boss_projectile
                ) <= 4
                && !instance_exists(
                    obj_boss_orb
                )
            )
            {
                selecionar_proximo_ataque();

                estado =
                    BossState.carregando;

                timer =
                    tempo_carregamento;
            }

            break;
        }


        case BossState.carregando:
        {
            timer--;

            if (timer <= 0)
            {
                estado =
                    BossState.disparando;
            }

            break;
        }


        case BossState.disparando:
        {
            executar_ataque();

            estado =
                BossState.esperando;

            if (fase == 1)
            {
                timer = intervalo_disparo;
            }
            else
            {
                timer = 65;
            }

            break;
        }


        case BossState.atingido:
        {
            timer--;

            if (timer <= 0)
            {
                if (vida <= 0)
                {
                    estado =
                        BossState.derrotado;

                    derrota_timer = 90;

                    with (
                        obj_boss_projectile
                    )
                    {
                        instance_destroy();
                    }

                    with (obj_boss_orb)
                    {
                        instance_destroy();
                    }
                }
                else
                {
                    fase = 2;

                    alvo_x = 368;

                    intervalo_disparo = 65;

                    estado =
                        BossState.movendo;
                }
            }

            break;
        }


        case BossState.movendo:
        {
            x = lerp(
                x,
                alvo_x,
                0.12
            );

            if (abs(x - alvo_x) < 1)
            {
                x = alvo_x;

                posicao_base_x = x;

                invulneravel = false;

                indice_ataque = 0;

                estado =
                    BossState.esperando;

                timer = 60;
            }

            break;
        }


        case BossState.derrotado:
        {
            derrota_timer--;

            shake_timer = 2;
            shake_forca = 2;

            cor_visual =
                choose(
                    c_white,
                    c_aqua
                );

            escala_x_visual += 0.005;
            escala_y_visual += 0.005;

            if (derrota_timer <= 0)
            {
                var _manager =
                    instance_find(
                        obj_time_manager,
                        0
                    );

                if (
                    instance_exists(
                        _manager
                    )
                )
                {
                    (_manager).
                        concluir_mvp();
                }

                instance_destroy();
            }

            break;
        }
    }
};  