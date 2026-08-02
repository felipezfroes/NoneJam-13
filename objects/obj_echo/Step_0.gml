if (!reproduzindo)
{
    velh = 0;
    velv = 0;
    exit;
}

var _total_h = array_length(comandos_h);
var _total_v = array_length(comandos_v);

var _total_frames = min(
    _total_h,
    _total_v
);

if (frame_reproducao >= _total_frames)
{
    velh = 0;
    velv = 0;

    reproduzindo = false;
    finalizado = true;

    exit;
}

var _input_h = comandos_h[frame_reproducao];
var _input_v = comandos_v[frame_reproducao];

scr_actor_apply_input(
    _input_h,
    _input_v,
    vel
);

frame_reproducao++;

//==================================================
// CRIAR RASTRO TEMPORAL
//==================================================

// Só cria rastro enquanto o eco está se movimentando.
if (velh != 0 || velv != 0)
{
    vfx_timer++;

    if (vfx_timer >= vfx_intervalo)
    {
        vfx_timer = 0;

        var _vfx = instance_create_layer(
            x,
            y,
            layer,
            obj_echo_vfx
        );

        // Copia o estado visual atual do eco.
        (_vfx).sprite_index = sprite_index;
        (_vfx).image_index = image_index;
        (_vfx).image_speed = 0;

        (_vfx).image_xscale = image_xscale;
        (_vfx).image_yscale = image_yscale;
        (_vfx).image_angle = image_angle;

        // Mesmo ciano utilizado pelo eco.
        (_vfx).image_blend = cor_eco;
        (_vfx).image_alpha = 0.45;

        // Mantém o rastro visualmente atrás do eco.
        (_vfx).depth = depth + 1;
    }
}