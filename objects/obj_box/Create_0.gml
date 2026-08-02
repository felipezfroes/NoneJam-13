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
        return false;
    }

    // REALIZAR EMPURRÃO

    x = _destino_x;
    y = _destino_y;

    return true;
};