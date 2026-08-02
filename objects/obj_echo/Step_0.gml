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

if (image_number mod 4)
{
    var inst = instance_create_layer(x,y, "Instances", obj_echo_vfx);
    inst.sprite_index = sprite_index;
    inst.image_index = image_index;
    inst.image_speed = 0;
}