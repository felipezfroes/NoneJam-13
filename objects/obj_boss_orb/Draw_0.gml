draw_set_alpha(0.35);
draw_set_colour(c_aqua);

draw_circle(
    x,
    y,
    raio + 4,
    false
);

draw_set_alpha(1);
draw_set_colour(c_white);

draw_circle(
    x,
    y,
    raio,
    false
);

draw_set_colour(c_aqua);

draw_circle(
    x,
    y,
    max(1, raio - 3),
    false
);

draw_set_colour(c_white);