playerid = noone;

inicio_x = 0;
inicio_y = 0;

comandos_h = [];
comandos_v = [];

frame_gravacao = 0;
max_frames = 60 * 15;

gravando = true;
eco_criado = false;
eco_id = noone;

vitoria = false;


//==================================================
// REGISTRAR PLAYER
//==================================================

registrar_player = function(_player_id)
{
    if (!instance_exists(_player_id))
    {
        return;
    }

    // Evita redefinir o início constantemente.
    if (instance_exists(playerid))
    {
        return;
    }

    playerid = _player_id;

    inicio_x = (_player_id).x;
    inicio_y = (_player_id).y;
};


//==================================================
// GRAVAR COMANDO
//==================================================

gravar_comando = function(_input_h, _input_v)
{
    if (!gravando || eco_criado || vitoria)
    {
        return;
    }

    if (frame_gravacao >= max_frames)
    {
        gravando = false;
        return;
    }

    comandos_h[frame_gravacao] = clamp(_input_h, -1, 1);
    comandos_v[frame_gravacao] = clamp(_input_v, -1, 1);

    frame_gravacao++;
};


//==================================================
// CRIAR ECO
//==================================================

criar_eco_teste = function()
{
    if (eco_criado || vitoria)
    {
        return noone;
    }

    if (frame_gravacao <= 0)
    {
        return noone;
    }

    if (!instance_exists(playerid))
    {
        return noone;
    }

    var _copia_h = [];
    var _copia_v = [];

    array_copy(
        _copia_h,
        0,
        comandos_h,
        0,
        frame_gravacao
    );

    array_copy(
        _copia_v,
        0,
        comandos_v,
        0,
        frame_gravacao
    );

    //==================================================
    // CRIAR ECO
    //==================================================
    
    var _profundidade_inicial =
        -floor(inicio_y);
    
    eco_id = instance_create_depth(
        inicio_x,
        inicio_y,
        _profundidade_inicial,
        obj_echo
    );
    
    (eco_id).comandos_h = _copia_h;
    (eco_id).comandos_v = _copia_v;
    
    (eco_id).frame_reproducao = 0;
    (eco_id).reproduzindo = true;

    // Simula a criação de uma nova linha temporal.
    (playerid).x = inicio_x;
    (playerid).y = inicio_y;

    (playerid).velh = 0;
    (playerid).velv = 0;

    (playerid).input_h = 0;
    (playerid).input_v = 0;

    eco_criado = true;
    gravando = false;

    return eco_id;
};


//==================================================
// CONCLUIR MVP
//==================================================

concluir_mvp = function()
{
    if (vitoria)
    {
        return;
    }

    vitoria = true;
    gravando = false;

    if (instance_exists(playerid))
    {
        (playerid).velh = 0;
        (playerid).velv = 0;

        (playerid).input_h = 0;
        (playerid).input_v = 0;
    }

    if (instance_exists(eco_id))
    {
        (eco_id).velh = 0;
        (eco_id).velv = 0;
        (eco_id).reproduzindo = false;
    }
};