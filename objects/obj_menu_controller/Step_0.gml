//==================================================
// TEMPO
//==================================================

menu_tempo++;
pulso_tempo += 0.05;


//==================================================
// INTRO
//==================================================

if (intro_contador < intro_frames)
{
    intro_contador++;
    intro_alpha = 1 - (intro_contador / intro_frames);
}
else
{
    intro_alpha = 0;
}


//==================================================
// POSICIONAR BOTÕES
//==================================================

var _gui_width = display_get_gui_width();
var _gui_height = display_get_gui_height();

var _centro_x = floor(_gui_width * 0.5);

//==================================================
// POSIÇÃO DOS BOTÕES
//==================================================

// Em 448 px de altura:
// JOGAR fica aproximadamente em Y 318;
// SAIR fica aproximadamente em Y 372.

var _inicio_y =
    floor(_gui_height * 0.71);

var _espaco = 54;

for (var _i = 0; _i < array_length(botoes); _i++)
{
    var _botao = botoes[_i];

    if (!instance_exists(_botao))
    {
        continue;
    }

    (_botao).gui_x = _centro_x;
    (_botao).gui_y = _inicio_y + _i * _espaco;
}


//==================================================
// TRANSIÇÃO
//==================================================

if (transicao_ativa)
{
    transicao_contador++;

    transicao_alpha = clamp(
        transicao_contador / transicao_frames,
        0,
        1
    );

    if (transicao_contador >= transicao_frames)
    {
        executar_acao();
    }

    exit;
}


//==================================================
// LEITURA DO MOUSE
//==================================================

var _mouse_x = device_mouse_x_to_gui(0);
var _mouse_y = device_mouse_y_to_gui(0);

var _mouse_moveu =
    abs(_mouse_x - mouse_x_anterior) > 0.5
    || abs(_mouse_y - mouse_y_anterior) > 0.5;

if (_mouse_moveu)
{
    usando_mouse = true;
}


//==================================================
// HOVER DO MOUSE
//==================================================

var _hover_index = -1;

for (var _i = 0; _i < array_length(botoes); _i++)
{
    var _botao = botoes[_i];

    if (!instance_exists(_botao))
    {
        continue;
    }

    var _meia_largura =
        (_botao).largura
        * 0.5
        * 1.06;
    
    var _meia_altura =
        (_botao).altura
        * 0.5
        * 1.10;

    var _hover =
        point_in_rectangle(
            _mouse_x,
            _mouse_y,
            (_botao).gui_x - _meia_largura,
            (_botao).gui_y - _meia_altura,
            (_botao).gui_x + _meia_largura,
            (_botao).gui_y + _meia_altura
        );

    (_botao).hover = _hover;

    if (_hover)
    {
        _hover_index = _i;
    }
}


//==================================================
// SELEÇÃO PELO MOUSE
//==================================================

if (usando_mouse && _hover_index >= 0)
{
    mudar_selecao(_hover_index);
}


//==================================================
// TECLADO
//==================================================

var _baixo =
    keyboard_check_pressed(vk_down)
    || keyboard_check_pressed(ord("S"));

var _cima =
    keyboard_check_pressed(vk_up)
    || keyboard_check_pressed(ord("W"));

var _delta_menu = _baixo - _cima;

if (_delta_menu != 0)
{
    usando_mouse = false;
    mudar_selecao(selecao + sign(_delta_menu));
}


//==================================================
// CONFIRMAÇÃO
//==================================================

var _confirmar = false;

if (mouse_check_button_pressed(mb_left) && _hover_index >= 0)
{
    usando_mouse = true;
    mudar_selecao(_hover_index);
    _confirmar = true;
}

if (
    keyboard_check_pressed(vk_enter)
    || keyboard_check_pressed(vk_space)
)
{
    _confirmar = true;
}


//==================================================
// ESC PARA SAIR
//==================================================

if (keyboard_check_pressed(vk_escape))
{
    iniciar_acao("sair");
    exit;
}


//==================================================
// EXECUTAR BOTÃO
//==================================================

if (_confirmar)
{
    var _botao_selecionado = botoes[selecao];

    if (instance_exists(_botao_selecionado))
    {
        iniciar_acao((_botao_selecionado).acao);
    }
}


//==================================================
// VISUAL DOS BOTÕES
//==================================================

for (
    var _i = 0;
    _i < array_length(botoes);
    _i++
)
{
    var _botao =
        botoes[_i];

    if (!instance_exists(_botao))
    {
        continue;
    }


    (_botao).selecionado =
        _i == selecao;


    var _escala_alvo = 1;
    var _brilho_alvo = 0;


    // Seleção por teclado ou mouse.
    if ((_botao).selecionado)
    {
        _escala_alvo = 1.045;
        _brilho_alvo = 1;
    }

    // Mouse apenas passando pelo botão.
    else if ((_botao).hover)
    {
        _escala_alvo = 1.02;
        _brilho_alvo = 0.45;
    }


    (_botao).escala_visual =
        lerp(
            (_botao).escala_visual,
            _escala_alvo,
            0.20
        );

    (_botao).brilho_visual =
        lerp(
            (_botao).brilho_visual,
            _brilho_alvo,
            0.17
        );
}

//==================================================
// WIDGETS SOCIAIS
//==================================================

var _total_widgets =
    array_length(widgets);

var _widget_hover_index = -1;


//==================================================
// POSIÇÃO
//==================================================

// Rodapé direito.
var _widget_y =
    _gui_height - 38;

var _widget_right =
    _gui_width - 34;

var _widget_spacing = 48;


//==================================================
// ATUALIZAR WIDGETS
//==================================================

for (
    var _i = 0;
    _i < _total_widgets;
    _i++
)
{
    var _widget =
        widgets[_i];

    if (!instance_exists(_widget))
    {
        continue;
    }


    //==================================================
    // POSICIONAMENTO
    //==================================================

    var _indice_invertido =
        (_total_widgets - 1) - _i;

    (_widget).gui_x =
        _widget_right
        - _indice_invertido
        * _widget_spacing;

    (_widget).gui_y =
        _widget_y;


    //==================================================
    // ÁREA DO MOUSE
    //==================================================

    var _largura =
        sprite_get_width(
            (_widget).sprite_index
        )
        * (_widget).scale_base;

    var _altura =
        sprite_get_height(
            (_widget).sprite_index
        )
        * (_widget).scale_base;

    var _hover_widget =
        point_in_rectangle(
            _mouse_x,
            _mouse_y,

            (_widget).gui_x
                - _largura * 0.60,

            (_widget).gui_y
                - _altura * 0.60,

            (_widget).gui_x
                + _largura * 0.60,

            (_widget).gui_y
                + _altura * 0.60
        );


    (_widget).hover =
        _hover_widget;

    if (_hover_widget)
    {
        _widget_hover_index =
            _i;
    }


    //==================================================
    // ANIMAÇÃO
    //==================================================

    var _scale_target =
        (_widget).scale_base;

    var _glow_target = 0;


    if (_hover_widget)
    {
        _scale_target =
            (_widget).scale_base
            * 1.12;

        _glow_target = 1;
    }


    if ((_widget).pressed_timer > 0)
    {
        (_widget).pressed_timer--;

        _scale_target =
            (_widget).scale_base
            * 0.92;
    }


    (_widget).scale_target =
        _scale_target;

    (_widget).scale_current =
        lerp(
            (_widget).scale_current,
            (_widget).scale_target,
            0.22
        );

    (_widget).glow =
        lerp(
            (_widget).glow,
            _glow_target,
            0.18
        );
}


//==================================================
// CLIQUE
//==================================================

if (
    _widget_hover_index >= 0
    && mouse_check_button_pressed(
        mb_left
    )
)
{
    var _widget_clicado =
        widgets[
            _widget_hover_index
        ];

    if (
        instance_exists(
            _widget_clicado
        )
    )
    {
        (_widget_clicado).
            pressed_timer = 7;


        scr_play_sfx(
            snd_plate,
            0.34,
            1.12,
            1.18,
            5
        );


        (_widget_clicado).action();
    }
}


//==================================================
// CURSOR
//==================================================

var _mouse_interativo =
    _hover_index >= 0
    || _widget_hover_index >= 0;

window_set_cursor(
    _mouse_interativo
    ? cr_handpoint
    : cr_default
);

//==================================================
// GUARDAR MOUSE
//==================================================

mouse_x_anterior = _mouse_x;
mouse_y_anterior = _mouse_y;