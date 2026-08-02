playerid = noone;

inicio_x = 0;
inicio_y = 0;

comandos_h = [];
comandos_v = [];

frame_gravacao = 0;
max_frames = 60 * 15;

gravando = true;
eco_criado = false;
vitoria = false;


// Registra qual instância será controlada pelo sistema temporal.
registrar_player = function(_player_id)
{
    if (!instance_exists(_player_id))
    {
        return;
    }

    playerid = _player_id;

    inicio_x = (_player_id).x;
    inicio_y = (_player_id).y;
};


// Guarda um comando por frame.
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


// Cria um eco reproduzindo a gravação inteira e devolve o player ao início.
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

    var _player_layer = (playerid).layer;

    var _echo = instance_create_layer(
        inicio_x,
        inicio_y,
        _player_layer,
        obj_echo
    );

    (_echo).comandos_h = _copia_h;
    (_echo).comandos_v = _copia_v;
    (_echo).frame_reproducao = 0;
    (_echo).reproduzindo = true;

    // O jogador atual começa uma nova linha a partir do mesmo ponto do eco.
    (playerid).x = inicio_x;
    (playerid).y = inicio_y;
    (playerid).velh = 0;
    (playerid).velv = 0;
    (playerid).input_h = 0;
    (playerid).input_v = 0;

    eco_criado = true;
    gravando = false;

    return _echo;
};


// Marca o objetivo do MVP como concluído.
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
};