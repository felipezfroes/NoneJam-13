pressionada = false;

porta = obj_door;

abrir_porta = function ()
{
    with (porta) {
        aberta = true;
        image_index = 1;
    }
}

fechar_porta = function ()
{
    with (porta) {
        aberta = false;
        image_index = 0;
    }
}

depth = 50;