//==================================================
// TEMPO
//==================================================

menu_tempo++;


//==================================================
// ATUALIZAR POSIÇÃO DOS BOTÕES
//==================================================

var _gui_width =
    display_get_gui_width();

var _gui_height =
    display_get_gui_height();

var _centro_x =
    floor(_gui_width * 0.5);

var _inicio_y =
    floor(_gui_height * 0.63);

var _espaco =
    54;


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

    (_botao).gui_x =
        _centro_x;

    (_botao).gui_y =
        _inicio_y
        + _i * _espaco;
}


//==================================================
// TRANSIÇÃO ATIVA
//==================================================

if (transicao_ativa)
{
    transicao_contador++;

    transicao_alpha =
        clamp(
            transicao_contador
            / transicao_frames,
            0,
            1
        );

    if (
        transicao_contador
        >= transicao_frames
    )
    {
        executar_acao();
    }

    exit;
}


//==================================================
// MOUSE NA GUI
//==================================================

var _mouse_x =
    device_mouse_x_to_gui(0);

var _mouse_y =
    device_mouse_y_to_gui(0);

var _mouse_moveu =
    abs(
        _mouse_x
        - mouse_x_anterior
    )
    > 0.5
    ||
    abs(
        _mouse_y
        - mouse_y_anterior
    )
    > 0.5;

if (_mouse_moveu)
{
    usando_mouse = true;
}


//==================================================
// DESCOBRIR BOTÃO SOB O MOUSE
//==================================================

var _hover_index = -1;

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

    var _metade_largura =
        (_botao).largura * 0.5;

    var _metade_altura =
        (_botao).altura * 0.5;

    var _esta_hover =
        point_in_rectangle(
            _mouse_x,
            _mouse_y,

            (_botao).gui_x
                - _metade_largura,

            (_botao).gui_y
                - _metade_altura,

            (_botao).gui_x
                + _metade_largura,

            (_botao).gui_y
                + _metade_altura
        );

    (_botao).hover =
        _esta_hover;

    if (_esta_hover)
    {
        _hover_index = _i;
    }
}


//==================================================
// SELEÇÃO PELO MOUSE
//==================================================

if (
    usando_mouse
    && _hover_index >= 0
)
{
    mudar_selecao(
        _hover_index
    );
}


//==================================================
// SELEÇÃO PELO TECLADO
//==================================================

var _pressionou_baixo =
    keyboard_check_pressed(
        vk_down
    )
    ||
    keyboard_check_pressed(
        ord("S")
    );

var _pressionou_cima =
    keyboard_check_pressed(
        vk_up
    )
    ||
    keyboard_check_pressed(
        ord("W")
    );

var _movimento_menu =
    _pressionou_baixo
    - _pressionou_cima;


if (_movimento_menu != 0)
{
    usando_mouse = false;

    mudar_selecao(
        selecao
        + sign(_movimento_menu)
    );
}


//==================================================
// CLIQUE DO MOUSE
//==================================================

var _confirmar = false;

if (
    mouse_check_button_pressed(
        mb_left
    )
    && _hover_index >= 0
)
{
    usando_mouse = true;

    mudar_selecao(
        _hover_index
    );

    _confirmar = true;
}


//==================================================
// CONFIRMAR PELO TECLADO
//==================================================

if (
    keyboard_check_pressed(
        vk_enter
    )
    ||
    keyboard_check_pressed(
        vk_space
    )
)
{
    _confirmar = true;
}


//==================================================
// ESC PARA SAIR
//==================================================

if (
    keyboard_check_pressed(
        vk_escape
    )
)
{
    iniciar_acao(
        "sair"
    );

    exit;
}


//==================================================
// EXECUTAR BOTÃO SELECIONADO
//==================================================

if (_confirmar)
{
    var _botao_selecionado =
        botoes[selecao];

    if (
        instance_exists(
            _botao_selecionado
        )
    )
    {
        iniciar_acao(
            (_botao_selecionado).acao
        );
    }
}


//==================================================
// ATUALIZAR VISUAL DOS BOTÕES
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

    var _escala_alvo =
        (_botao).selecionado
        ? 1.06
        : 1;

    (_botao).escala_visual =
        lerp(
            (_botao).escala_visual,
            _escala_alvo,
            0.22
        );
}


//==================================================
// GUARDAR POSIÇÃO DO MOUSE
//==================================================

mouse_x_anterior =
    _mouse_x;

mouse_y_anterior =
    _mouse_y;