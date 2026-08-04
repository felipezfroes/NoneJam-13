image_alpha = max(
    0,
    image_alpha - fade_speed
);

image_xscale = max(
    0,
    image_xscale - shrink_speed
);

image_yscale = max(
    0,
    image_yscale - shrink_speed
);


if (
    image_alpha <= 0
    || image_xscale <= 0
    || image_yscale <= 0
)
{
    instance_destroy();
}