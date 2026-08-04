//==================================================
// CONFIGURAÇÃO
//==================================================

grid_size = 16;

// Margem permitida entre o centro do player
// e o centro da caixa.
margem_alinhamento = 8;

// Distância máxima para o player alcançar a caixa.
distancia_maxima = 26;

//==================================================
// GAME FEEL VISUAL
//==================================================

// Deslocamento usado apenas no Draw.
// A posição lógica da caixa continua no grid.
draw_offset_x = 0;
draw_offset_y = 0;

// Escala visual.
escala_visual_x = 1;
escala_visual_y = 1;

// Rotação rápida ao empurrar.
angulo_visual = 0;

// Tremor quando o empurrão falha.
shake_timer = 0;
shake_forca = 0;

// Pequeno brilho ao ser empurrada.
flash_timer = 0;


//==================================================
// PARTÍCULAS DE POEIRA
//==================================================

poeira = [];

criar_poeira = function(_direcao_x, _direcao_y)
{
    repeat (5)
    {
        var _particula =
        {
            x: x
                + random_range(-6, 6)
                - (_direcao_x * 5),

            y: y
                + random_range(3, 8)
                - (_direcao_y * 5),

            vel_x:
                random_range(-0.5, 0.5)
                - (_direcao_x * 0.35),

            vel_y:
                random_range(-0.8, -0.2)
                - (_direcao_y * 0.35),

            vida: irandom_range(10, 18),

            tamanho: choose(1, 1, 2)
        };

        array_push(
            poeira,
            _particula
        );
    }
};

//==================================================
// PROMPT DE INTERAÇÃO
//==================================================

pode_mostrar_prompt = function(_actor)
{
    if (!instance_exists(_actor))
    {
        return false;
    }

    var _distancia = point_distance(
        x,
        y,
        (_actor).x,
        (_actor).y
    );

    if (_distancia > distancia_maxima)
    {
        return false;
    }

    var _alinhado_horizontal =
        abs((_actor).y - y)
        <= margem_alinhamento;

    var _alinhado_vertical =
        abs((_actor).x - x)
        <= margem_alinhamento;

    return (
        _alinhado_horizontal
        || _alinhado_vertical
    );
};

//==================================================
// EMPURRÃO BLOQUEADO
//==================================================

efeito_empurrao_bloqueado = function()
{
    shake_timer = 6;
    shake_forca = 1;

    escala_visual_x = 1.06;
    escala_visual_y = 0.94;
};

//==================================================
// EMPURRAR CAIXA
//==================================================

empurrar = function(_actor)
{
    if (!instance_exists(_actor))
    {
        return false;
    }

    var _direcao_x = (_actor).direcao_olhar_x;
    var _direcao_y = (_actor).direcao_olhar_y;

    // A direção precisa ser cardinal.
    if (_direcao_x == 0 && _direcao_y == 0)
    {
        return false;
    }

    // CENTROS REAIS DAS MÁSCARAS

    var _actor_centro_x =
        ((_actor).bbox_left + (_actor).bbox_right) * 0.5;

    var _actor_centro_y =
        ((_actor).bbox_top + (_actor).bbox_bottom) * 0.5;

    var _caixa_centro_x =
        (bbox_left + bbox_right) * 0.5;

    var _caixa_centro_y =
        (bbox_top + bbox_bottom) * 0.5;


    var _dif_x = _caixa_centro_x - _actor_centro_x;
    var _dif_y = _caixa_centro_y - _actor_centro_y;


    // CONFIRMAR QUE A CAIXA ESTÁ NA FRENTE DO PLAYER

    if (_direcao_x != 0)
    {
        // A caixa precisa estar alinhada horizontalmente.
        if (abs(_dif_y) > margem_alinhamento)
        {
            return false;
        }

        // A caixa precisa estar do lado para onde
        // o player está olhando.
        if (sign(_dif_x) != _direcao_x)
        {
            return false;
        }

        if (abs(_dif_x) > distancia_maxima)
        {
            return false;
        }
    }
    else
    {
        // A caixa precisa estar alinhada verticalmente.
        if (abs(_dif_x) > margem_alinhamento)
        {
            return false;
        }

        // A caixa precisa estar do lado para onde
        // o player está olhando.
        if (sign(_dif_y) != _direcao_y)
        {
            return false;
        }

        if (abs(_dif_y) > distancia_maxima)
        {
            return false;
        }
    }

    // DESTINO DA CAIXA

    var _destino_x =
        x + (_direcao_x * grid_size);

    var _destino_y =
        y + (_direcao_y * grid_size);


    // MÁSCARA DA CAIXA NA POSIÇÃO FUTURA

    var _offset_left   = bbox_left - x;
    var _offset_right  = bbox_right - x;
    var _offset_top    = bbox_top - y;
    var _offset_bottom = bbox_bottom - y;

    var _destino_left =
        _destino_x + _offset_left;

    var _destino_right =
        _destino_x + _offset_right;

    var _destino_top =
        _destino_y + _offset_top;

    var _destino_bottom =
        _destino_y + _offset_bottom;


    // VERIFICAR COLISÕES

    // O último argumento true ignora a própria caixa.
    var _obstaculo = collision_rectangle(
        _destino_left,
        _destino_top,
        _destino_right,
        _destino_bottom,
        obj_colisor,
        false,
        true
    );

    if (_obstaculo != noone)
    {
        efeito_empurrao_bloqueado();
        return false;
    }


    var _player_no_destino = collision_rectangle(
        _destino_left,
        _destino_top,
        _destino_right,
        _destino_bottom,
        obj_player,
        false,
        true
    );

    if (_player_no_destino != noone)
    {
        efeito_empurrao_bloqueado();
        return false;
    }


    var _eco_no_destino = collision_rectangle(
        _destino_left,
        _destino_top,
        _destino_right,
        _destino_bottom,
        obj_echo,
        false,
        true
    );

    if (_eco_no_destino != noone)
    {
        efeito_empurrao_bloqueado();
        return false;
    }

    //==================================================
    // GUARDAR POSIÇÃO ANTES DO MOVIMENTO
    //==================================================
    
    var _x_anterior = x;
    var _y_anterior = y;
    
    
    //==================================================
    // MOVIMENTO LÓGICO IMEDIATO
    //==================================================
    
    x = _destino_x;
    y = _destino_y;
    
    
    //==================================================
    // MOVIMENTO VISUAL SUAVE
    //==================================================
    
    // Como o objeto já mudou de posição,
    // o desenho começa visualmente no local anterior.
    draw_offset_x =
        _x_anterior - x;
    
    draw_offset_y =
        _y_anterior - y;
    
    
    //==================================================
    // SQUASH E STRETCH
    //==================================================
    
    if (_direcao_x != 0)
    {
        escala_visual_x = 1.18;
        escala_visual_y = 0.86;
    
        angulo_visual =
            -_direcao_x * 3;
    }
    else
    {
        escala_visual_x = 0.88;
        escala_visual_y = 1.14;
    
        angulo_visual =
            _direcao_y * 2;
    }
    
    
    //==================================================
    // EFEITOS
    //==================================================
    
    flash_timer = 4;
    
    criar_poeira(
        _direcao_x,
        _direcao_y
    );
    
    return true;
};