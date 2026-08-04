//==================================================
// TIMERS
//==================================================

tempo_vida--;

if (tempo_vida <= 0)
{
    instance_destroy();
    exit;
}

if (cooldown_reflexao > 0)
{
    cooldown_reflexao--;
}

if (reacao_grace > 0)
{
    reacao_grace--;
}

if (ignorar_player_frames > 0)
{
    ignorar_player_frames--;
}


//==================================================
// PULSO VISUAL
//==================================================

escala_visual =
    1
    + sin(current_time * 0.025)
    * 0.08;

image_xscale = escala_visual;
image_yscale = escala_visual;


//==================================================
// POSIÇÃO ANTERIOR
//==================================================

var _x_anterior = x;
var _y_anterior = y;


//==================================================
// MOVIMENTO
//==================================================

x += vel_x;
y += vel_y;

//==================================================
// REAÇÃO GARANTIDA NO PONTO DE ENCONTRO
//==================================================

if (
    pode_multiplicar
    && geracao == 0
    && reacao_grupo >= 0
    && !reacao_disparada
)
{
    var _distancia_alvo =
        point_distance(
            x,
            y,
            reacao_alvo_x,
            reacao_alvo_y
        );

    var _velocidade_atual =
        point_distance(
            0,
            0,
            vel_x,
            vel_y
        );

    if (
        _distancia_alvo
        <= _velocidade_atual + 2
    )
    {
        x = reacao_alvo_x;
        y = reacao_alvo_y;

        executar_reacao_em_cadeia(
            reacao_alvo_x,
            reacao_alvo_y,
            reacao_grupo
        );

        exit;
    }
}

//==================================================
// SPAWN DE RASTRO COM SPRITE
//==================================================

trail_timer++;

if (trail_timer >= trail_intervalo)
{
    trail_timer = 0;

    if (trail_sprite != noone)
    {
        var _trail = instance_create_depth(
            x,
            y,
            depth + 1,
            obj_projectile_trail_vfx
        );

        (_trail).sprite_index = trail_sprite;
        (_trail).image_blend = image_blend;
        (_trail).image_alpha = trail_alpha;
        (_trail).image_xscale = trail_scale;
        (_trail).image_yscale = trail_scale;
    }
}

//==================================================
// COLISÃO COM PLAYER
//==================================================

if (ignorar_player_frames <= 0)
{
    var _player = collision_line(
        _x_anterior,
        _y_anterior,
        x,
        y,
        obj_player,
        false,
        true
    );

    if (_player == noone)
    {
        _player = instance_place(
            x,
            y,
            obj_player
        );
    }

    if (_player != noone)
    {
        if (refletido)
        {
            instance_destroy();
            exit;
        }

        var _iniciou =
            (_player).
                iniciar_retrocesso_forcado(
                    (_player).
                        retrocesso_frames_impacto
                );

        if (_iniciou)
        {
            var _boss = instance_find(
                obj_boss,
                0
            );

            if (instance_exists(_boss))
            {
                if (
                    (_boss).estado
                        != BossState.atingido
                    && (_boss).estado
                        != BossState.movendo
                    && (_boss).estado
                        != BossState.derrotado
                )
                {
                    (_boss).estado =
                        BossState.esperando;

                    (_boss).timer = 60;
                }
            }

            with (obj_boss_projectile)
            {
                instance_destroy();
            }

            with (obj_boss_orb)
            {
                instance_destroy();
            }

            exit;
        }

        instance_destroy();
        exit;
    }
}


//==================================================
// COLISÃO ENTRE PROJÉTEIS
//==================================================

if (
    pode_multiplicar
    && !refletido
    && geracao == 0
    && reacao_grace <= 0
    && !reacao_processada
)
{
    var _outro = collision_circle(
        x,
        y,
        6,
        obj_boss_projectile,
        false,
        true
    );

    if (
        _outro != noone
        && _outro != id
        && instance_exists(_outro)
        && (_outro).pode_multiplicar
        && !(_outro).refletido
        && (_outro).geracao == 0
        && (_outro).reacao_grace <= 0
        && !(_outro).reacao_processada
    )
    {
        // Somente uma das instâncias processa a reação.
        if (id < _outro)
        {
            reacao_processada = true;
            (_outro).reacao_processada = true;

            var _reacao_x =
                (x + (_outro).x)
                * 0.5;

            var _reacao_y =
                (y + (_outro).y)
                * 0.5;

            var _boss = instance_find(
                obj_boss,
                0
            );

            if (instance_exists(_boss))
            {
                var _vel = 1.7;

                var _direcoes =
                [
                    225,
                    270,
                    315
                ];

                for (
                    var _i = 0;
                    _i
                        < array_length(
                            _direcoes
                        );
                    _i++
                )
                {
                    if (
                        instance_number(
                            obj_boss_projectile
                        )
                        >= (_boss).
                            maximo_projeteis
                    )
                    {
                        break;
                    }

                    var _dir =
                        _direcoes[_i];

                    var _filho =
                        instance_create_depth(
                            _reacao_x,
                            _reacao_y,
                            depth,
                            obj_boss_projectile
                        );

                    (_filho).vel_x =
                        lengthdir_x(
                            _vel,
                            _dir
                        );

                    (_filho).vel_y =
                        lengthdir_y(
                            _vel,
                            _dir
                        );

                    (_filho).geracao = 1;

                    (_filho).
                        pode_multiplicar =
                            false;

                    (_filho).
                        pode_danificar_boss =
                            false;

                    (_filho).reacao_grace =
                        20;

                    (_filho).image_blend =
                        c_aqua;
                    
                    (_filho).tipo_tiro = ProjectileType.chain;
                    (_filho).aplicar_visual();
                }
            }

            // Pequeno flash usando os próprios rastros.
            repeat (3)
            {
                var _vfx =
                    instance_create_depth(
                        _reacao_x
                            + irandom_range(
                                -4,
                                4
                            ),
                        _reacao_y
                            + irandom_range(
                                -4,
                                4
                            ),
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
                    0.65;
            }

            with (_outro)
            {
                instance_destroy();
            }

            instance_destroy();
            exit;
        }
    }
}


//==================================================
// COLISÃO COM CAIXA
//==================================================

var _caixa = instance_place(
    x,
    y,
    obj_box
);

if (
    _caixa != noone
    && cooldown_reflexao <= 0
)
{
    var _reflexao_vfx = instance_create_depth(
    x,
    y,
    depth + 2,
    obj_animated_vfx
    );
    
    (_reflexao_vfx).sprite_index =
        spr_boss_proj_main  ;
    
    (_reflexao_vfx).image_speed = 0.35;
    (_reflexao_vfx).image_blend = c_aqua;
    
    (_reflexao_vfx).escala_inicial = 0.7;
    (_reflexao_vfx).escala_final = 1.2;
    
    (_reflexao_vfx).fade_inicio_frame = 0.5;
    
    // Rebate na direção contrária.
    vel_x = -vel_x;
    vel_y = -vel_y;

    refletido = true;

    pode_multiplicar = false;
    
    aplicar_visual();

    cooldown_reflexao = 8;
    ignorar_player_frames = 5;

    image_blend = c_aqua;

    // Retira o tiro de dentro da caixa.
    x += vel_x;
    y += vel_y;

    exit;
}


//==================================================
// ESCUDO / PORTA
//==================================================

if (
    place_meeting(
        x,
        y,
        obj_door_blocker
    )
)
{
    instance_destroy();
    exit;
}


//==================================================
// OUTROS COLISORES
//==================================================

// A caixa precisa ser verificada primeiro porque
// herda de obj_colisor.
var _colisor = instance_place(
    x,
    y,
    obj_colisor
);

if (_colisor != noone)
{
    instance_destroy();
    exit;
}


//==================================================
// FORA DA ROOM
//==================================================

if (
    x < -32
    || x > room_width + 32
    || y < -32
    || y > room_height + 32
)
{
    instance_destroy();
}