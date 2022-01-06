import 'package:flame/components.dart';
import 'package:flame/extensions.dart';

class Selector extends SpriteComponent {
  bool show = true;

  Selector(double s, Image image)
      : super(
    sprite: Sprite(image, srcSize: Vector2.all(32.0)),
    size: Vector2.all(s),
  );

  @override
  void render(Canvas canvas) {
    if (!show) {
      return;
    }
    super.render(canvas);
  }
}