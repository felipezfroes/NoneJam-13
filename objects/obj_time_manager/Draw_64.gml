var _esconder_interface =
    transicao_estado
    == TransitionState.saindo
    && transicao_alpha >= 0.35;

var _gui_x = 16;
var _gui_y = 16;

var escala = 2;

var _barra_largura = (sprite_get_width(spr_record_bar) * 2) - 4 * escala;
var _barra_altura = 10;

var _progresso = clamp(
    frame_gravacao / max_frames,
    0,
    1
);

draw_set_halign(fa_left);
draw_set_valign(fa_top);

draw_set_font(fnt_01);

draw_set_alpha(1);
draw_set_color(c_white);


//==================================================
// TEXTO DO ESTADO
//==================================================

if (!_esconder_interface)
{
    if (vitoria)
    {
        draw_text(
            _gui_x,
            _gui_y,
            "MVP CONCLUIDO!"
            + "\nO eco abriu a porta."
            + "\nR: reiniciar o teste"
        );
    }
    else if (!eco_criado)
    {
        draw_text(
            _gui_x,
            _gui_y,
            "OBJETIVO: alcance a porta"
            + "\n2. SPACE: eco."
            + "\nR: reiniciar"
        );
    }
    else
    {
        var _estado_eco = "ECO: reproduzindo";
    
        var _eco = instance_find(obj_echo, 0);
    
        if (instance_exists(_eco))
        {
            if ((_eco).finalizado)
            {
                _estado_eco = "ECO: gravacao finalizada";
            }
        }
    
        draw_text(
            _gui_x,
            _gui_y,
            "Use o eco para ativar a placa."
            + "\nE perto da caixa: alterar o caminho."
            + "\n" + _estado_eco
            + "\nR: reiniciar"
        );
    }
    
    
    //==================================================
    // BARRA DE GRAVAÇÃO
    //==================================================
    
    var _barra_y = _gui_y + 76;
    
    draw_set_color(c_black);
    
    draw_sprite_ext(spr_record_bar, 0, _gui_x, _barra_y, escala,escala, 0,c_white,1);
    
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
        "Gravacao: "
        + string(floor(frame_gravacao / 60))
        + "s / 15s"
    );
}

//==================================================
// TRANSIÇÃO ENTRE ROOMS
//==================================================

if (transicao_alpha > 0)
{
    var _gui_width =
        display_get_gui_width();

    var _gui_height =
        display_get_gui_height();


    // Fundo preto.
    draw_set_alpha(
        transicao_alpha
    );

    draw_set_colour(c_black);

    draw_rectangle(
        0,
        0,
        _gui_width,
        _gui_height,
        false
    );


    // Ampulheta no centro.
    var _ampulheta_alpha =
        clamp(
            transicao_alpha * 1.35,
            0,
            1
        );

    draw_set_alpha(
        _ampulheta_alpha
    );

    draw_set_colour(c_white);

    draw_sprite_ext(
        spr_boss_hourglass_transition,
        floor(transicao_ampulheta_frame),
        _gui_width * 0.5,
        _gui_height * 0.5,
        1,
        1,
        0,
        c_white,
        _ampulheta_alpha
    );


    draw_set_alpha(1);
    draw_set_colour(c_white);
}