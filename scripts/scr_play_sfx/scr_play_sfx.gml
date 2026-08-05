function scr_play_sfx(
    _sound,
    _gain,
    _pitch_min,
    _pitch_max,
    _priority
)
{
    var _audio_id = audio_play_sound(
        _sound,
        _priority,
        false
    );

    audio_sound_gain(
        _audio_id,
        clamp(_gain, 0, 1),
        0
    );

    audio_sound_pitch(
        _audio_id,
        random_range(
            _pitch_min,
            _pitch_max
        )
    );

    return _audio_id;
}