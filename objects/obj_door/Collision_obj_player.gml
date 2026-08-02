if (aberta)
{
    var _time_manager = instance_find(obj_time_manager, 0);

    if (instance_exists(_time_manager))
    {
        (_time_manager).concluir_mvp();
    }
}