function scr_actor_apply_input(_input_h, _input_v, _speed)
{
    _input_h = clamp(_input_h, -1, 1);
    _input_v = clamp(_input_v, -1, 1);

    if (_input_h == 0 && _input_v == 0)
    {
        velh = 0;
        velv = 0;
        return;
    }

    var _length = point_distance(0, 0, _input_h, _input_v);

    velh = (_input_h / _length) * _speed;
    velv = (_input_v / _length) * _speed;
}