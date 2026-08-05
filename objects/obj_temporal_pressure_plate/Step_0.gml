//==================================================
// NOVO ESTADO
//==================================================

var _novo_estado =
    place_meeting(x, y, obj_player)
    || place_meeting(x, y, obj_echo);


//==================================================
// MUDANÇA
//==================================================

if (_novo_estado != pressionada)
{
    pressionada = _novo_estado;

    scr_play_sfx(
        snd_plate,
        0.32,
        pressionada ? 1.05 : 0.78,
        pressionada ? 1.10 : 0.84,
        2
    );
}


//==================================================
// VISUAL
//==================================================

image_index = pressionada ? 1 : 0;