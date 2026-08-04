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
// TRANSIÇÃO ENTRE FASES
//==================================================

fase_efeito_timer = 0;
fase_efeito_duracao = 24;

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
// DESTRUIÇÃO DO BOSS
//==================================================

derrota_iniciada = false;
derrota_explosao_final = false;
derrota_conclusao_enviada = false;

derrota_timer = 0;
derrota_duracao = 72;

derrota_spawn_timer = 0;

derrota_onda_timer = 0;
derrota_onda_duracao = 20;

derrota_particulas = [];


//==================================================
// CRIAR PARTÍCULAS PIXELADAS
//==================================================

criar_particulas_derrota = function(
    _quantidade,
    _forca
)
{
    repeat (_quantidade)
    {
        var _px =
            x + irandom_range(-12, 12);

        var _py =
            y + irandom_range(-18, 18);

        var _direcao =
            point_direction(
                x,
                y,
                _px,
                _py
            )
            + random_range(-30, 30);

        var _velocidade =
            random_range(
                _forca * 0.55,
                _forca
            );

        var _vida =
            irandom_range(24, 46);

        var _cor = choose(
            c_white,
            c_white,
            c_aqua,
            make_colour_rgb(
                120,
                150,
                160
            )
        );

        var _particula =
        {
            x: _px,
            y: _py,

            vel_x:
                lengthdir_x(
                    _velocidade,
                    _direcao
                ),

            vel_y:
                lengthdir_y(
                    _velocidade,
                    _direcao
                ),

            gravidade:
                random_range(
                    0.035,
                    0.075
                ),

            atrito:
                random_range(
                    0.965,
                    0.985
                ),

            vida: _vida,
            vida_max: _vida,

            tamanho:
                choose(1, 1, 2, 2, 3),

            cor: _cor
        };

        array_push(
            derrota_particulas,
            _particula
        );
    }
};


//==================================================
// INICIAR DERROTA
//==================================================

iniciar_derrota = function()
{
    if (derrota_iniciada)
    {
        return;
    }

    derrota_iniciada = true;
    derrota_explosao_final = false;
    derrota_conclusao_enviada = false;

    derrota_timer =
        derrota_duracao;

    derrota_spawn_timer = 0;

    invulneravel = true;

    onda_diagonal_ativa = false;

    escala_x_visual = 1.12;
    escala_y_visual = 0.88;

    shake_timer = 18;
    shake_forca = 2;


    // Limpar perigos restantes.
    with (obj_boss_projectile)
    {
        instance_destroy();
    }

    with (obj_boss_orb)
    {
        instance_destroy();
    }


    // Primeiras rachaduras.
    criar_particulas_derrota(
        14,
        1.8
    );
};


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
                    estado =
                        BossState.derrotado;
                
                    iniciar_derrota();
                }
               else
               {
                   // Avança diretamente para a próxima fase.
                   fase++;
       
                   indice_posicao = clamp(
                       indice_posicao + 1,
                       0,
                       array_length(posicoes_boss) - 1
                   );
       
                   alvo_x =
                       posicoes_boss[indice_posicao];
       
                   indice_ataque = 0;
       
                   onda_diagonal_ativa = false;
                   fase_efeito_timer = fase_efeito_duracao;
       
                   with (obj_boss_projectile)
                   {
                       instance_destroy();
                   }
       
                   with (obj_boss_orb)
                   {
                       instance_destroy();
                   }
       
                   estado = BossState.movendo;
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
            // Segurança caso o estado tenha sido definido
            // por outro trecho de código.
            if (!derrota_iniciada)
            {
                iniciar_derrota();
            }
        
        
            //==================================================
            // CONTAGEM
            //==================================================
        
            derrota_timer = max(
                0,
                derrota_timer - 1
            );
        
            derrota_spawn_timer--;
        
        
            //==================================================
            // DESINTEGRAÇÃO INICIAL
            //==================================================
        
            if (
                derrota_timer > 28
                && derrota_spawn_timer <= 0
            )
            {
                derrota_spawn_timer = 4;
        
                criar_particulas_derrota(
                    2,
                    1.4
                );
        
                shake_timer = 4;
                shake_forca = 1;
            }
        
        
            //==================================================
            // COMPRIMIR E PISCAR
            //==================================================
        
            if (derrota_timer > 28)
            {
                var _progresso =
                    1
                    - (
                        derrota_timer - 28
                    )
                    / max(
                        1,
                        derrota_duracao - 28
                    );
        
                var _pulso =
                    sin(
                        _progresso
                        * pi
                        * 10
                    );
        
                escala_x_visual =
                    1 + _pulso * 0.08;
        
                escala_y_visual =
                    1 - _pulso * 0.06;
        
                cor_visual =
                    (
                        floor(derrota_timer / 4)
                        mod 2 == 0
                    )
                    ? c_white
                    : c_aqua;
        
                image_alpha = clamp(
                    (derrota_timer - 28)
                    / 44,
                    0.18,
                    1
                );
            }
        
        
            //==================================================
            // EXPLOSÃO FINAL
            //==================================================
        
            if (
                derrota_timer <= 28
                && !derrota_explosao_final
            )
            {
                derrota_explosao_final = true;
        
                image_alpha = 0;
        
                derrota_onda_timer =
                    derrota_onda_duracao;
        
                criar_particulas_derrota(
                    32,
                    3.3
                );
        
                shake_timer = 12;
                shake_forca = 3;
            }
        
        
            //==================================================
            // FINALIZAR BATALHA
            //==================================================
        
            if (
                derrota_timer <= 0
                && !derrota_conclusao_enviada
            )
            {
                derrota_conclusao_enviada =
                    true;
        
                var _manager =
                    instance_find(
                        obj_time_manager,
                        0
                    );
        
                if (
                    instance_exists(_manager)
                    && variable_instance_exists(
                        _manager,
                        "concluir_mvp"
                    )
                )
                {
                    (_manager).concluir_mvp();
                }
            }
        
        
            // Sem manager, remove o boss depois que todas
            // as partículas terminarem.
            if (
                derrota_conclusao_enviada
                && array_length(
                    derrota_particulas
                ) <= 0
            )
            {
                instance_destroy();
            }
        
            break;
        }
             
    }
};  