import 'package:add_to_cart_animation/Models/position.dart';
import 'package:flutter/material.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  MainScreenState createState() => MainScreenState();
}

class MainScreenState extends State<MainScreen> with TickerProviderStateMixin {
  late AnimationController controller;
  late Animation animation;

  Position? fromPosition;
  GlobalKey starKey = GlobalKey();

  @override
  void initState() {

    super.initState();
    controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    );
    animation = CurvedAnimation(
      parent: controller,
      // curve: Curves.easeInOut,
      curve: Curves.slowMiddle,
    );

    controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        print('End of Animation');
        setState(() {
          fromPosition = null;
        });
      }
    });

  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final fromKey = GlobalKey();
    return Scaffold(
      appBar: AppBar(),
      body: Stack(
        children: [
          Column(
            children: [
              const Expanded(child: SizedBox.shrink()),
              Icon(Icons.weekend, key: fromKey),
              ElevatedButton(
                  onPressed: () {
                    setState(() {
                      fromPosition = getPositionByKey(fromKey);
                    });
                    controller.reset();
                    controller.forward();
                  },
                  child: const Text('Start Animation')),
            ],
          ),
          Row(
            children: [
              const Spacer(),
              SizedBox(
                height: 40,
                width: 40,
                child: Stack(
                  children: [
                    buildFlyWidget(),
                    Container(
                        width: 24,
                        height: 24,
                        padding: const EdgeInsets.all(5),
                        child: const Icon(Icons.shopping_cart,
                            color: Colors.black)),
                  ],
                ),
              )
            ],
          ),
        ],
      ),
    );
  }

  Widget buildFlyWidget() {
    if (fromPosition == null) {
      return const SizedBox.shrink();
    }
    return Container(
      key: starKey,
      height: 24,
      width: 24,
      color: Colors.transparent,
      child: AnimatedBuilder(
        animation: animation,
        builder: (context, child) {
          Position currentPosition;
          double x = 0, y = 0;
          if (starKey.currentContext?.findRenderObject() != null) {
            currentPosition = getPositionByKey(starKey);
            x = fromPosition!.x - currentPosition.x;
            y = fromPosition!.y - currentPosition.y;
          }
          if (x == 0) return Container();
          return Transform.translate(
            offset: Offset(
              x * (1 - animation.value),
              y * (1 - animation.value),
            ),
            child: Opacity(
              opacity: fromPosition == null ? 0.0 : 1.0,
              child: const Icon(
                Icons.weekend_outlined,
                color: Colors.black,
              ),
            ),
          );
        },
      ),
    );
  }

  Position getPositionByKey(GlobalKey key) {
    final renderObject = key.currentContext!.findRenderObject()!;
    var translation = renderObject.getTransformTo(null).getTranslation();
    final rect =
        renderObject.paintBounds.shift(Offset(translation.x, translation.y));
    return Position(
      x: rect.left,
      y: rect.top,
      size: rect.size,
    );
  }
}
