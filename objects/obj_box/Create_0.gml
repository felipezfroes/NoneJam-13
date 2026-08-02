// A posição colocada na room representa o ponto onde a caixa bloqueia o eco.
pos_bloqueio_x = x;
pos_bloqueio_y = y;

// No começo ela fica fora do caminho para o jogador gravar a linha original.
pos_descanso_x = x;
pos_descanso_y = y + 48;

x = pos_descanso_x;
y = pos_descanso_y;

no_caminho = false;
image_alpha = 0.65;


// Alterna a caixa entre o caminho gravado e a posição de descanso.
alternar_posicao = function()
{
    var _destino_x = pos_bloqueio_x;
    var _destino_y = pos_bloqueio_y;

    if (no_caminho)
    {
        _destino_x = pos_descanso_x;
        _destino_y = pos_descanso_y;
    }

    // Não teleporta a caixa para dentro de outro ator ou de uma parede.
    if (place_meeting(_destino_x, _destino_y, obj_player))
    {
        return false;
    }

    if (place_meeting(_destino_x, _destino_y, obj_echo))
    {
        return false;
    }

    if (place_meeting(_destino_x, _destino_y, obj_colisor))
    {
        return false;
    }

    x = _destino_x;
    y = _destino_y;

    no_caminho = !no_caminho;
    image_alpha = no_caminho ? 1 : 0.65;

    return true;
};