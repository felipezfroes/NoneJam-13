pressionada =
    place_meeting(x, y, obj_player)
    or place_meeting(x, y, obj_echo)
    or place_meeting(x, y, obj_box);

if (pressionada)
{
    image_index = 1;
    abrir_porta();
}
else
{
    image_index = 0;
    fechar_porta();
}