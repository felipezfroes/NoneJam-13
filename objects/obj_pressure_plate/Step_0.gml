if (pressionada)
{
    abrir_porta();
}
else 
{
    fechar_porta();
}


if (place_meeting(x,y, obj_player))
{
    pressionada = true;
}
else 
{
    pressionada = false;
}