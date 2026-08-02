image_alpha = max(
    0,
    image_alpha - fade_speed
);

if (image_alpha <= 0)
{
    instance_destroy();
}