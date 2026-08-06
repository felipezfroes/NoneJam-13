//==================================================
// CONFIGURAÇÃO DO MENU
//==================================================

botoes = [];

selecao = 0;
usando_mouse = false;

menu_tempo = 0;


//==================================================
// MOUSE
//==================================================

mouse_x_anterior = device_mouse_x_to_gui(0);
mouse_y_anterior = device_mouse_y_to_gui(0);


//==================================================
// TRANSIÇÃO
//==================================================

transicao_ativa = false;
transicao_alpha = 0;

transicao_frames = 22;
transicao_contador = 0;

acao_pendente = "";


//==================================================
// INTRO / FADE-IN
//==================================================

intro_alpha = 1;
intro_frames = 28;
intro_contador = 0;


//==================================================
// FUNDO / ANIMAÇÃO
//==================================================

pulso_tempo = 0;

//==================================================
// WIDGETS SOCIAIS
//==================================================

widgets = [];


//==================================================
// CRIAR WIDGET
//==================================================

criar_widget = function(_objeto)
{
    var _widget = instance_create_depth(
        0,
        0,
        depth,
        _objeto
    );

    array_push(
        widgets,
        _widget
    );

    return _widget;
};


//==================================================
// CRIAR BOTÃO
//==================================================

criar_botao = function(_texto, _acao, _indice)
{
    var _botao = instance_create_depth(
        0,
        0,
        depth,
        obj_menu_button
    );

    (_botao).texto = _texto;
    (_botao).acao = _acao;
    (_botao).menu_index = _indice;

    array_push(botoes, _botao);

    return _botao;
};


//==================================================
// MUDAR SELEÇÃO
//==================================================

mudar_selecao = function(_nova_selecao)
{
    var _total = array_length(botoes);

    if (_total <= 0)
    {
        return;
    }

    _nova_selecao = (_nova_selecao + _total) mod _total;

    if (_nova_selecao == selecao)
    {
        return;
    }

    selecao = _nova_selecao;

    scr_play_sfx(
        snd_plate,
        0.25,
        1.08,
        1.14,
        3
    );
};


//==================================================
// INICIAR AÇÃO
//==================================================

iniciar_acao = function(_acao)
{
    if (transicao_ativa)
    {
        return;
    }

    acao_pendente = _acao;

    transicao_ativa = true;
    transicao_alpha = 0;
    transicao_contador = 0;

    scr_play_sfx(
        snd_transition,
        0.48,
        0.98,
        1.02,
        6
    );
};


//==================================================
// EXECUTAR AÇÃO
//==================================================

executar_acao = function()
{
    switch (acao_pendente)
    {
        case "jogar":
        {
            room_goto(rm_tuto_temporal);
            break;
        }

        case "sair":
        {
            game_end();
            break;
        }
    }
};


//==================================================
// CRIAR BOTÕES
//==================================================

criar_botao("JOGAR", "jogar", 0);
criar_botao("SAIR",   "sair",   1);

//==================================================
// CRIAR REDES SOCIAIS
//==================================================

// Ordem visual da esquerda para a direita.
criar_widget(
    obj_title_widget_itchio
);

criar_widget(
    obj_title_widget_youtube
);

criar_widget(
    obj_title_widget_portfolio
);


//==================================================
// SOM AMBIENTE
//==================================================

if (!audio_is_playing(snd_clock_ambient))
{
    var _ambiente = audio_play_sound(
        snd_clock_ambient,
        0,
        true
    );

    audio_sound_gain(_ambiente, 0.09, 0);
}