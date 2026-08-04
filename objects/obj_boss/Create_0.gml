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
    transicao_fase,
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
// TRANSIÇÃO ENTRE FASES
//==================================================

fase_efeito_timer = 0;
fase_efeito_duracao = 54;

fase_transicao_progresso = 0;

ampulheta_frame = 0;
ampulheta_velocidade = 0.22;

transicao_flash_alpha = 0;

proxima_posicao_x = x;

//==================================================
// POSIÇÃO
//==================================================

posicao_base_x = x;
posicao_base_y = y;

alvo_x = x;

//==================================================
// POSIÇÕES DAS TRÊS FASES
//==================================================

// Arena atual:
// esquerda = 176
// centro   = 272
// direita  = 368

posicoes_boss =
[
    272,
    368,
    176
];

intervalos_por_fase =
[
    58,
    44,
    34
];

indice_posicao = 0;


//==================================================
// ATAQUE DIAGONAL EM DUAS ONDAS
//==================================================

onda_diagonal_ativa = false;
onda_diagonal_timer = 0;


//==================================================
// VARIAÇÃO DOS ORBES
//==================================================

// Alterna:
// 0 = orbes verticais
// 1 = orbes laterais

padrao_orbes = 0;


//==================================================
// ATAQUES
//==================================================

ataque_atual = BossAttack.principal;
indice_ataque = 0;

timer = 0;

intervalo_disparo = 80;
tempo_carregamento = 45;

maximo_projeteis = 16;


//==================================================
// SEQUÊNCIAS DE ATAQUES
//==================================================

// Fase 1:
// ensina ataque principal e retrocesso.
sequencia_fase_1 =
[
    BossAttack.principal,
    BossAttack.cruz,
    BossAttack.principal
];


// Fase 2:
// remove a zona segura ao lado do boss.
sequencia_fase_2 =
[
    BossAttack.cruz,
    BossAttack.diagonal,
    BossAttack.principal,
    BossAttack.orbes,
    BossAttack.cruz,
    BossAttack.principal
];


// Fase 3:
// pressão maior, mas mantém janelas claras
// para usar o projétil principal.
sequencia_fase_3 =
[
    BossAttack.orbes,
    BossAttack.cruz,
    BossAttack.diagonal,
    BossAttack.principal,
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
    
    (_tiro).tipo_tiro =
    _pode_danificar_boss
    ? ProjectileType.principal
    : ProjectileType.normal;

    (_tiro).aplicar_visual();

    return _tiro;
};


//==================================================
// SELECIONAR PRÓXIMO ATAQUE
//==================================================

selecionar_proximo_ataque = function()
{
    var _sequencia;

    switch (fase)
    {
        case 1:
        {
            _sequencia = sequencia_fase_1;
            break;
        }

        case 2:
        {
            _sequencia = sequencia_fase_2;
            break;
        }

        default:
        {
            _sequencia = sequencia_fase_3;
            break;
        }
    }

    ataque_atual =
        _sequencia[
            indice_ataque
            mod array_length(_sequencia)
        ];

    indice_ataque++;


    //==================================================
    // REGISTRAR ALVO DA CRUZ
    //==================================================

    var _player = instance_find(
        obj_player,
        0
    );

    if (instance_exists(_player))
    {
        // Prevê levemente a continuação do movimento,
        // sem perseguir o jogador durante o aviso.
        var _previsao = 18;

        if (fase == 3)
        {
            _previsao = 24;
        }

        ataque_alvo_x = clamp(
            (_player).x
            + (_player).velh * _previsao,
            144,
            400
        );

        ataque_alvo_y = clamp(
            (_player).y
            + (_player).velv * _previsao,
            96,
            208
        );
    }


    //==================================================
    // TEMPO DE AVISO
    //==================================================

    switch (ataque_atual)
    {
        case BossAttack.principal:
        {
            switch (fase)
            {
                case 1:
                    tempo_carregamento = 48;
                    break;
    
                case 2:
                    tempo_carregamento = 42;
                    break;
    
                default:
                    tempo_carregamento = 38;
                    break;
            }
    
            break;
        }
    
        case BossAttack.cruz:
        {
            tempo_carregamento =
                (fase == 3) ? 36 : 43;
    
            break;
        }
    
        case BossAttack.diagonal:
        {
            tempo_carregamento =
                (fase == 3) ? 30 : 35;
    
            break;
        }
    
        case BossAttack.orbes:
        {
            tempo_carregamento =
                (fase == 3) ? 38 : 45;
    
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
    var _vel = 1.7;

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
    var _vel = 1.7;

    if (fase == 3)
    {
        _vel = 2;
    }


    //==================================================
    // PRIMEIRA ONDA
    //==================================================

    // Esquerda.
    criar_projetil(
        x,
        y + 24,
        lengthdir_x(_vel, 235),
        lengthdir_y(_vel, 235),
        false,
        false,
        0
    );

    // Centro.
    criar_projetil(
        x,
        y + 24,
        0,
        _vel,
        false,
        false,
        0
    );

    // Direita.
    criar_projetil(
        x,
        y + 24,
        lengthdir_x(_vel, 305),
        lengthdir_y(_vel, 305),
        false,
        false,
        0
    );


    //==================================================
    // PREPARAR SEGUNDA ONDA
    //==================================================

    onda_diagonal_ativa = true;
    onda_diagonal_timer = 18;
};

//==================================================
// ATAQUE DOS ORBES
//==================================================

ataque_orbes = function()
{
    var _timer_orbe =
        (fase == 3) ? 42 : 52;


    //==================================================
    // PADRÃO VERTICAL
    //==================================================

    if (padrao_orbes == 0)
    {
        var _posicoes =
        [
            // x, y, vx, vy, grupo, alvo_x, alvo_y

            [176, 80,  0,  2.25, 1, 176, 144],
            [176, 208, 0, -2.25, 1, 176, 144],

            [368, 80,  0,  2.25, 2, 368, 144],
            [368, 208, 0, -2.25, 2, 368, 144]
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

            (_orb).vel_x_saida =
                _posicoes[_i][2];

            (_orb).vel_y_saida =
                _posicoes[_i][3];

            (_orb).reacao_grupo =
                _posicoes[_i][4];

            (_orb).reacao_alvo_x =
                _posicoes[_i][5];

            (_orb).reacao_alvo_y =
                _posicoes[_i][6];

            (_orb).timer =
                _timer_orbe;

            (_orb).boss_id = id;
        }
    }


    //==================================================
    // PADRÃO HORIZONTAL
    //==================================================

    else
    {
        var _posicoes =
        [
            [144, 144,  2.25, 0, 3, 272, 144],
            [400, 144, -2.25, 0, 3, 272, 144],

            [144, 192,  2.25, 0, 4, 272, 192],
            [400, 192, -2.25, 0, 4, 272, 192]
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

            (_orb).vel_x_saida =
                _posicoes[_i][2];

            (_orb).vel_y_saida =
                _posicoes[_i][3];

            (_orb).reacao_grupo =
                _posicoes[_i][4];

            (_orb).reacao_alvo_x =
                _posicoes[_i][5];

            (_orb).reacao_alvo_y =
                _posicoes[_i][6];

            (_orb).timer =
                _timer_orbe;

            (_orb).boss_id = id;
        }
    }

    padrao_orbes =
        1 - padrao_orbes;
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
        
            estado = BossState.esperando;
        
            var _indice_fase = clamp(
                fase - 1,
                0,
                array_length(intervalos_por_fase) - 1
            );
        
            timer =
                intervalos_por_fase[_indice_fase];
        
            break;
        }

        case BossState.atingido:
        {
            timer--;
        
            if (timer <= 0)
            {
                if (vida <= 0)
                {
                    estado = BossState.derrotado;
                    derrota_timer = 90;
        
                    with (obj_boss_projectile)
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
                    //==================================================
                    // PREPARAR NOVA FASE
                    //==================================================
        
                    fase++;
        
                    indice_posicao = clamp(
                        indice_posicao + 1,
                        0,
                        array_length(posicoes_boss) - 1
                    );
        
                    proxima_posicao_x =
                        posicoes_boss[indice_posicao];
        
                    indice_ataque = 0;
        
                    onda_diagonal_ativa = false;
        
                    with (obj_boss_projectile)
                    {
                        instance_destroy();
                    }
        
                    with (obj_boss_orb)
                    {
                        instance_destroy();
                    }
        
        
                    //==================================================
                    // INICIAR TRANSIÇÃO
                    //==================================================
        
                    estado =
                        BossState.transicao_fase;
        
                    timer =
                        fase_efeito_duracao;
        
                    fase_efeito_timer =
                        fase_efeito_duracao;
        
                    fase_transicao_progresso = 0;
        
                    ampulheta_frame = 0;
        
                    transicao_flash_alpha = 0.35;
        
                    escala_x_visual = 1.15;
                    escala_y_visual = 0.85;
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
       
           // Rastro temporal durante o deslocamento.
           if (current_time mod 5 == 0)
           {
               var _vfx = instance_create_depth(
                   x,
                   y,
                   depth + 2,
                   obj_echo_vfx
               );
       
               (_vfx).sprite_index =
                   sprite_index;
       
               (_vfx).image_index =
                   image_index;
       
               (_vfx).image_speed = 0;
       
               (_vfx).image_blend =
                   c_aqua;
       
               (_vfx).image_alpha =
                   0.35;
           }
       
           if (abs(x - alvo_x) < 1)
           {
               x = alvo_x;
       
               posicao_base_x = x;
       
               invulneravel = false;
       
               estado =
                   BossState.esperando;
       
               // Pequena pausa para o jogador perceber
               // a nova posição e reposicionar a caixa.
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
            
        case BossState.transicao_fase:
        {
            timer--;
        
            fase_efeito_timer = timer;
        
            fase_transicao_progresso =
                1
                - timer
                / max(
                    1,
                    fase_efeito_duracao
                );
        
        
            //==================================================
            // AMPULHETA
            //==================================================
        
            var _vel_ampulheta =
                ampulheta_velocidade;
        
            if (fase >= 3)
            {
                _vel_ampulheta *= 1.25;
            }
        
            ampulheta_frame +=
                _vel_ampulheta;
        
            var _frames_ampulheta =
                sprite_get_number(
                    spr_boss_hourglass_transition
                );
        
            if (_frames_ampulheta > 0)
            {
                ampulheta_frame =
                    ampulheta_frame
                    mod _frames_ampulheta;
            }
        
        
            //==================================================
            // PULSO DO BOSS
            //==================================================
        
            var _pulso =
                sin(
                    fase_transicao_progresso
                    * pi
                    * 6
                );
        
            escala_x_visual =
                1 + _pulso * 0.06;
        
            escala_y_visual =
                1 - _pulso * 0.04;
        
            cor_visual =
                merge_colour(
                    c_white,
                    c_aqua,
                    fase_transicao_progresso
                );
        
        
            //==================================================
            // FINALIZAR
            //==================================================
        
            if (timer <= 0)
            {
                alvo_x =
                    proxima_posicao_x;
        
                estado =
                    BossState.movendo;
        
                transicao_flash_alpha = 0.5;
            }
        
            break;
        }    
    }
};  