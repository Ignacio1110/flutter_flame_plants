import 'package:flame/components.dart';
import 'package:flame/sprite.dart';

class Plant extends SpriteAnimationComponent with HasGameRef{
  int type = 0;
  final double _animationSpeed = 0.35;
  late final SpriteAnimation _growUpAnimation;
  Plant(double s, this.type)
      : super(
    size: Vector2(16.0, 32.0),
  );

  @override
  Future<void>? onLoad()async {
    _loadAnimations().then((_)=>{animation =_growUpAnimation});
    super.onLoad();
  }

  Future<void> _loadAnimations() async {
    final spriteSheet = SpriteSheet(
      image: await gameRef.images.load('plants.png'),
      srcSize: Vector2(16.0, 32.0),
    );

    _growUpAnimation =spriteSheet.createAnimation(row: type, stepTime: _animationSpeed, to: 6,loop: false);
  }

}
