pressionada = false;

abrir_porta = function ()
{
    with (obj_door) {
        aberta = true;
        image_index = 1;
    }
}

fechar_porta = function ()
{
    with (obj_door) {
        aberta = false;
        image_index = 0;
    }
}