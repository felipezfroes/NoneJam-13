//==================================================
// PROCURAR PLACAS CONECTADAS
//==================================================

var _deve_abrir = false;

var _quantidade_placas =
    instance_number(par_pressure_plate);

for (
    var _i = 0;
    _i < _quantidade_placas;
    _i++
)
{
    var _placa = instance_find(
        par_pressure_plate,
        _i
    );

    if (!instance_exists(_placa))
    {
        continue;
    }

    if (
        (_placa).canal == canal
        && (_placa).pressionada
    )
    {
        _deve_abrir = true;
        break;
    }
}


//==================================================
// NÃO FECHAR SOBRE ALGUÉM
//==================================================

// A porta só permanece aberta por ocupação caso
// já estivesse aberta. Encostar em uma porta fechada
// não deve abri-la.
if (aberta && !_deve_abrir)
{
    var _passagem_ocupada =
        place_meeting(x, y, obj_player)
        || place_meeting(x, y, obj_echo)
        || place_meeting(x, y, obj_box);

    if (_passagem_ocupada)
    {
        _deve_abrir = true;
    }
}


//==================================================
// APLICAR ESTADO
//==================================================

definir_aberta(_deve_abrir);


//==================================================
// VISUAL
//==================================================

if (aberta)
{
    image_index = 1;
    image_alpha = 1;
}
else
{
    image_index = 0;
    image_alpha = 1;
}

scr_atualizar_profundidade(id, 0);