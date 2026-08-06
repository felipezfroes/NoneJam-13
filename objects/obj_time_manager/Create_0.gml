playerid = noone;

inicio_x = 0;
inicio_y = 0;

comandos_h = [];
comandos_v = [];

direcoes_x = [];
direcoes_y = [];

frame_gravacao = 0;
max_frames = 60 * 15;

gravando = true;
eco_criado = false;
eco_id = noone;

vitoria = false;

//==================================================
// TELA FINAL
//==================================================

tela_final_alpha = 0;
tela_final_tempo = 0;

tela_final_delay_input = 45;


//==================================================
// OPÇÕES
//==================================================

tela_final_opcoes =
[
    "VOLTAR",
    "SAIR"
];

tela_final_selecao = 0;
tela_final_hover_index = -1;

tela_final_usando_mouse = false;

tela_final_mouse_x_anterior =
    device_mouse_x_to_gui(0);

tela_final_mouse_y_anterior =
    device_mouse_y_to_gui(0);


//==================================================
// VISUAL DOS BOTÕES
//==================================================

tela_final_botao_escala =
[
    1,
    1
];

tela_final_botao_brilho =
[
    0,
    0
];

tela_final_botao_x = 0;
tela_final_botao_inicio_y = 0;
tela_final_botao_espaco = 54;

tela_final_escala_base_atual = 3;


//==================================================
// SAÍDA DA TELA FINAL
//==================================================

tela_final_saida_ativa = false;
tela_final_saida_alpha = 0;

tela_final_saida_contador = 0;
tela_final_saida_frames = 22;

tela_final_acao_pendente = "";


//==================================================
// MUDAR SELEÇÃO
//==================================================

tela_final_mudar_selecao = function(
    _nova_selecao
)
{
    var _total =
        array_length(
            tela_final_opcoes
        );

    if (_total <= 0)
    {
        return;
    }

    _nova_selecao =
        (
            _nova_selecao
            + _total
        )
        mod _total;

    if (
        _nova_selecao
        == tela_final_selecao
    )
    {
        return;
    }

    tela_final_selecao =
        _nova_selecao;


    scr_play_sfx(
        snd_plate,
        0.26,
        1.08,
        1.14,
        3
    );
};


//==================================================
// INICIAR AÇÃO FINAL
//==================================================

tela_final_iniciar_acao = function(
    _acao
)
{
    if (tela_final_saida_ativa)
    {
        return;
    }

    tela_final_acao_pendente =
        _acao;

    tela_final_saida_ativa = true;

    tela_final_saida_alpha = 0;
    tela_final_saida_contador = 0;


    scr_play_sfx(
        snd_transition,
        0.48,
        0.98,
        1.02,
        6
    );
};


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

//==================================================
// GRAVAR COMANDO E DIREÇÃO
//==================================================

gravar_comando = function(
    _input_h,
    _input_v,
    _direcao_x,
    _direcao_y
)
{
    if (
        !gravando
        || eco_criado
        || vitoria
    )
    {
        return;
    }

    if (frame_gravacao >= max_frames)
    {
        gravando = false;
        return;
    }


    //==================================================
    // COMANDOS
    //==================================================

    comandos_h[frame_gravacao] =
        clamp(_input_h, -1, 1);

    comandos_v[frame_gravacao] =
        clamp(_input_v, -1, 1);


    //==================================================
    // DIREÇÃO VISUAL
    //==================================================

    var _dir_x =
        sign(_direcao_x);

    var _dir_y =
        sign(_direcao_y);


    // Segurança caso uma direção inválida seja enviada.
    if (_dir_x == 0 && _dir_y == 0)
    {
        if (frame_gravacao > 0)
        {
            _dir_x =
                direcoes_x[
                    frame_gravacao - 1
                ];

            _dir_y =
                direcoes_y[
                    frame_gravacao - 1
                ];
        }
        else
        {
            _dir_x = 0;
            _dir_y = 1;
        }
    }


    direcoes_x[frame_gravacao] =
        _dir_x;

    direcoes_y[frame_gravacao] =
        _dir_y;


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
    
    var _copia_direcao_x = [];
    var _copia_direcao_y = [];

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
    
    array_copy(
        _copia_direcao_x,
        0,
        direcoes_x,
        0,
        frame_gravacao
    );
    
    array_copy(
        _copia_direcao_y,
        0,
        direcoes_y,
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
    
    (eco_id).direcoes_x =
        _copia_direcao_x;
    
    (eco_id).direcoes_y =
        _copia_direcao_y;
    
    
    // Aplicar imediatamente a primeira direção gravada.
    if (frame_gravacao > 0)
    {
        (eco_id).direcao_olhar_x =
            _copia_direcao_x[0];
    
        (eco_id).direcao_olhar_y =
            _copia_direcao_y[0];
    
        (eco_id).
            atualizar_sprite_direcao();
    }
    
    (eco_id).frame_reproducao = 0;
    (eco_id).reproduzindo = true;

    // Simula a criação de uma nova linha temporal.
    (playerid).x = inicio_x;
    (playerid).y = inicio_y;

    (playerid).velh = 0;
    (playerid).velv = 0;

    (playerid).input_h = 0;
    (playerid).input_v = 0;
    
    (playerid).limpar_historico_temporal();

    eco_criado = true;
    gravando = false;
    
    
    //==================================================
    // SOM TEMPORAL
    //==================================================
    
    scr_play_sfx(
        snd_temporal_burst,
        0.62,
        1.08,
        1.16,
        6
    );
    
    
    return eco_id;
};

//==================================================
// CONCLUIR FASE
//==================================================

concluir_mvp = function()
{
    if (vitoria)
    {
        return;
    }

    vitoria = true;
    gravando = false;


    //==================================================
    // PARAR PLAYER
    //==================================================

    if (instance_exists(playerid))
    {
        (playerid).velh = 0;
        (playerid).velv = 0;

        (playerid).input_h = 0;
        (playerid).input_v = 0;
    }


    //==================================================
    // PARAR ECO
    //==================================================

    if (instance_exists(eco_id))
    {
        (eco_id).velh = 0;
        (eco_id).velv = 0;

        (eco_id).reproduzindo = false;
    }


    //==================================================
    // BOSS É O FINAL ATUAL
    //==================================================

    // Não tenta procurar nem acessar outra room.
    if (room == rm_boss)
    {
        return;
    }


    //==================================================
    // PRÓXIMA ROOM
    //==================================================

    var _proxima_room =
        obter_proxima_room();

    if (_proxima_room == -1)
    {
        return;
    }

    iniciar_transicao_room(
        _proxima_room
    );
};

//==================================================
// TRANSIÇÃO ENTRE ROOMS
//==================================================

enum TransitionState
{
    entrando,
    jogando,
    saindo
}


//==================================================
// CONFIGURAÇÃO
//==================================================

transicao_estado =
    TransitionState.entrando;

transicao_alpha = 1;

// Entre duas rooms:
// 30 frames de saída
// 30 frames de entrada
// Total: 60 frames.
transicao_frames_saida = 30;
transicao_frames_entrada = 30;

transicao_contador = 0;

transicao_room_destino = -1;
transicao_trocou_room = false;


//==================================================
// AMPULHETA
//==================================================

transicao_ampulheta_frame = 0;
transicao_ampulheta_velocidade = 0.32;
transicao_ampulheta_escala = 4;

transicao_tempo = 0;


//==================================================
// ENCONTRAR PRÓXIMA ROOM
//==================================================

obter_proxima_room = function()
{
    switch (room)
    {
        case rm_tuto_temporal:
        {
            return rm_tuto_caixa;
        }

        case rm_tuto_caixa:
        {
            return rm_3;
        }

        case rm_3:
        {
            return rm_boss;
        }

        // O boss é atualmente a última room.
        case rm_boss:
        {
            return -1;
        }
    }

    return -1;
};


//==================================================
// INICIAR TRANSIÇÃO
//==================================================

iniciar_transicao_room = function(
    _room_destino
)
{
    // Já está saindo.
    if (
        transicao_estado
        == TransitionState.saindo
    )
    {
        return false;
    }


    // Não existe uma room de destino.
    if (_room_destino == -1)
    {
        return false;
    }
    
    //==================================================
    // SOM DA TRANSIÇÃO
    //==================================================
    
    scr_play_sfx(
        snd_transition,
        0.52,
        0.98,
        1.02,
        6
    );

    transicao_room_destino =
        _room_destino;

    transicao_estado =
        TransitionState.saindo;

    transicao_contador = 0;
    transicao_alpha = 0;

    transicao_trocou_room = false;

    transicao_ampulheta_frame = 0;
    transicao_tempo = 0;


    //==================================================
    // PARAR O PLAYER
    //==================================================

    if (instance_exists(playerid))
    {
        (playerid).input_h = 0;
        (playerid).input_v = 0;

        (playerid).velh = 0;
        (playerid).velv = 0;
    }


    //==================================================
    // PARAR O ECO
    //==================================================

    if (instance_exists(eco_id))
    {
        (eco_id).velh = 0;
        (eco_id).velv = 0;

        (eco_id).reproduzindo = false;
    }


    return true;
};

//==================================================
// AMBIENTE DE RELÓGIO
//==================================================

if (!audio_is_playing(snd_clock_ambient))
{
    var _clock_audio = audio_play_sound(
        snd_clock_ambient,
        0,
        true
    );

    audio_sound_gain(
        _clock_audio,
        0.11,
        0
    );
}