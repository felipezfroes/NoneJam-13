var _gui_x = 16;
var _gui_y = 16;
var _barra_largura = 220;
var _barra_altura = 10;
var _progresso = clamp(frame_gravacao / max_frames, 0, 1);

draw_set_halign(fa_left);
draw_set_valign(fa_top);
draw_set_alpha(1);
draw_set_color(c_white);

if (vitoria)
{
    draw_text(
        _gui_x,
        _gui_y,
        "MVP CONCLUIDO!\nO eco abriu a porta e o player chegou ao objetivo.\nR: reiniciar o teste"
    );
}
else if (!eco_criado)
{
    draw_text(
        _gui_x,
        _gui_y,
        "1. Grave um caminho ate a placa.\n2. SPACE: criar o eco e voltar ao inicio.\nR: reiniciar"
    );
}
else
{
    var _estado_eco = "ECO: reproduzindo";

    if (instance_exists(obj_echo))
    {
        if (obj_echo.finalizado)
        {
            _estado_eco = "ECO: gravacao finalizada";
        }
    }

    draw_text(
        _gui_x,
        _gui_y,
        "Use o eco para ativar a placa e alcance a porta.\nE perto da caixa: alterar o caminho do eco.\n" + _estado_eco + "\nR: reiniciar"
    );
}

var _barra_y = _gui_y + 72;

draw_set_color(c_black);
draw_rectangle(
    _gui_x,
    _barra_y,
    _gui_x + _barra_largura,
    _barra_y + _barra_altura,
    false
);

draw_set_color(c_aqua);
draw_rectangle(
    _gui_x,
    _barra_y,
    _gui_x + (_barra_largura * _progresso),
    _barra_y + _barra_altura,
    false
);

draw_set_color(c_white);
draw_text(
    _gui_x,
    _barra_y + 14,
    "Gravacao: " + string(floor(frame_gravacao / 60)) + "s / 15s"
);