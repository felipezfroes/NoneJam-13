function scr_atualizar_profundidade(_instancia, _offset)
{
    if (!instance_exists(_instancia))
    {
        return;
    }

    (_instancia).depth =
        -floor((_instancia).bbox_bottom)
        + _offset;
}