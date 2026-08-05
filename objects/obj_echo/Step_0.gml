//==================================================
// PARADO OU FINALIZADO
//==================================================

if (!reproduzindo)
{
    velh = 0;
    velv = 0;

    atualizar_sprite_direcao();

    exit;
}


//==================================================
// VALIDAR TAMANHO DA GRAVAÇÃO
//==================================================

var _total_h =
    array_length(comandos_h);

var _total_v =
    array_length(comandos_v);

var _total_direcao_x =
    array_length(direcoes_x);

var _total_direcao_y =
    array_length(direcoes_y);


var _total_frames = min(
    min(
        _total_h,
        _total_v
    ),

    min(
        _total_direcao_x,
        _total_direcao_y
    )
);


//==================================================
// FINAL DA REPRODUÇÃO
//==================================================

if (frame_reproducao >= _total_frames)
{
    velh = 0;
    velv = 0;

    reproduzindo = false;
    finalizado = true;

    atualizar_sprite_direcao();

    exit;
}


//==================================================
// LER FRAME GRAVADO
//==================================================

var _input_h =
    comandos_h[frame_reproducao];

var _input_v =
    comandos_v[frame_reproducao];

var _direcao_x =
    direcoes_x[frame_reproducao];

var _direcao_y =
    direcoes_y[frame_reproducao];


//==================================================
// APLICAR DIREÇÃO GRAVADA
//==================================================

if (
    _direcao_x != 0
    || _direcao_y != 0
)
{
    direcao_olhar_x =
        _direcao_x;

    direcao_olhar_y =
        _direcao_y;
}


atualizar_sprite_direcao();


//==================================================
// APLICAR MOVIMENTO GRAVADO
//==================================================

scr_actor_apply_input(
    _input_h,
    _input_v,
    vel
);


frame_reproducao++;


//==================================================
// CRIAR RASTRO TEMPORAL
//==================================================

if (velh != 0 || velv != 0)
{
    vfx_timer++;

    if (vfx_timer >= vfx_intervalo)
    {
        vfx_timer = 0;

        var _vfx =
            instance_create_depth(
                x,
                y,
                depth + 2,
                obj_echo_vfx
            );


        // Copia o sprite da direção gravada.
        (_vfx).sprite_index =
            sprite_index;

        (_vfx).image_index =
            image_index;

        (_vfx).image_speed = 0;

        (_vfx).image_xscale =
            image_xscale;

        (_vfx).image_yscale =
            image_yscale;

        (_vfx).image_angle =
            image_angle;


        (_vfx).depth =
            -floor(
                (_vfx).bbox_bottom
            )
            + 2;


        (_vfx).image_blend =
            cor_eco;

        (_vfx).image_alpha =
            0.45;
    }
}