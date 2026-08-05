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


if (ignorar_player_frames > 0)
{
    ignorar_player_frames--;
}


if (reacao_grace > 0)
{
    reacao_grace--;
}


//==================================================
// PULSO SOMENTE VISUAL
//==================================================

// A escala real da instância permanece 1.
// O Draw aplica esta escala sem alterar a colisão.

escala_visual =
    1
    + sin(
        current_time * 0.025
        
    )
    * 0.06;


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
// REAÇÃO GARANTIDA
//==================================================

if (
    pode_multiplicar
    && !refletido
    && geracao == 0
    && reacao_grupo >= 0
    && reacao_grace <= 0
    && !reacao_disparada
)
{
    var _antes_x =
        reacao_alvo_x
        - _x_anterior;

    var _antes_y =
        reacao_alvo_y
        - _y_anterior;

    var _depois_x =
        reacao_alvo_x
        - x;

    var _depois_y =
        reacao_alvo_y
        - y;


    // Produto escalar menor ou igual a zero:
    // o projétil alcançou ou atravessou o ponto.
    var _passou_do_alvo =
        (_antes_x * _depois_x)
        + (_antes_y * _depois_y)
        <= 0;


    var _velocidade =
        point_distance(
            0,
            0,
            vel_x,
            vel_y
        );

    var _proximo_do_alvo =
        point_distance(
            x,
            y,
            reacao_alvo_x,
            reacao_alvo_y
        )
        <= _velocidade + 0.5;


    if (
        _passou_do_alvo
        || _proximo_do_alvo
    )
    {
        x = reacao_alvo_x;
        y = reacao_alvo_y;

        if (
            executar_reacao_em_cadeia(
                reacao_alvo_x,
                reacao_alvo_y,
                reacao_grupo
            )
        )
        {
            exit;
        }
    }
}


//==================================================
// RASTRO
//==================================================

trail_timer++;

if (
    trail_timer >= trail_intervalo
    && trail_sprite != noone
)
{
    trail_timer = 0;

    criar_vfx_simples(
        trail_sprite,
        x,
        y,
        trail_alpha,
        trail_scale,
        image_blend
    );
}


//==================================================
// COLISÃO COM A CAIXA
//==================================================

// A caixa é verificada antes do player para que
// funcione corretamente como escudo e refletor.

var _caixa = collision_line(
    _x_anterior,
    _y_anterior,
    x,
    y,
    obj_box,
    false,
    true
);

if (_caixa == noone)
{
    _caixa = instance_place(
        x,
        y,
        obj_box
    );
}


if (
    _caixa != noone
    && cooldown_reflexao <= 0
)
{
    scr_play_sfx(
        snd_reflect,
        0.78,
        0.97,
        1.04,
        9
    );
    
    //==================================================
    // VFX DA REFLEXÃO
    //==================================================

    repeat (3)
    {
        criar_vfx_simples(
            sprite_index,

            x + irandom_range(-3, 3),
            y + irandom_range(-3, 3),

            random_range(0.25, 0.45),
            random_range(0.5, 0.85),
            c_aqua
        );
    }


    //==================================================
    // INVERTER MOVIMENTO
    //==================================================

    vel_x = -vel_x;
    vel_y = -vel_y;

    refletido = true;

    pode_multiplicar = false;

    reacao_grupo = -1;
    reacao_disparada = true;

    cooldown_reflexao = 8;
    ignorar_player_frames = 6;

    // Garante tempo suficiente para chegar ao boss.
    tempo_vida = max(
        tempo_vida,
        120
    );

    aplicar_visual();


    //==================================================
    // FEEDBACK NA CAIXA
    //==================================================

    if (
        variable_instance_exists(
            _caixa,
            "flash_timer"
        )
    )
    {
        (_caixa).flash_timer = 8;
    }

    if (
        variable_instance_exists(
            _caixa,
            "shake_timer"
        )
    )
    {
        (_caixa).shake_timer = 5;
        (_caixa).shake_forca = 1;
    }

    if (
        variable_instance_exists(
            _caixa,
            "escala_visual_x"
        )
    )
    {
        (_caixa).escala_visual_x = 1.12;
        (_caixa).escala_visual_y = 0.88;
    }


    // Volta um passo na direção refletida para
    // impedir que permaneça dentro da caixa.
    x = _x_anterior + vel_x;
    y = _y_anterior + vel_y;

    exit;
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
        processar_impacto_player(
            _player
        );

        exit;
    }
}


//==================================================
// COLISÃO COM PAREDES E PORTAS
//==================================================

// obj_box também herda de obj_colisor,
// mas já foi processada e teria causado exit.

var _obstaculo = collision_line(
    _x_anterior,
    _y_anterior,
    x,
    y,
    obj_colisor,
    false,
    true
);

if (_obstaculo == noone)
{
    _obstaculo = instance_place(
        x,
        y,
        obj_colisor
    );
}


if (_obstaculo != noone)
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
    exit;
}