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
      duration: const Duration(seconds: 2),
    );
    animation = CurvedAnimation(
      parent: controller,
      curve: Curves.easeInOut,
      // curve: Curves.slowMiddle,
    );

    controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text(
              'Added Successfully!',
              style: TextStyle(
                color: Colors.black,
                fontSize: 15,
              ),
              textAlign: TextAlign.center,
            ),
            backgroundColor: Colors.white,
            behavior: SnackBarBehavior.floating,
            duration: const Duration(seconds: 3),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(5),
              side: const BorderSide(
                color: Colors.black45,
                width: 1.5,
              ),
            ),
            padding: const EdgeInsets.all(20),
            margin: EdgeInsets.zero,
            elevation: 0,
            dismissDirection: DismissDirection.horizontal,
          ),
        );
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

  List<String> features = [
    'NVIDIA® GeForce RTX™ 3080 Ti Laptop GPU 16GB GDDR6',
    'Windows 11 Pro',
    '17.3″ UHD (3840*2160), 120Hz 100% DCI-P3',
    'Alder Lake i9-12900HX',
    '2TB NVMe PCIe Gen4x4 SSD',
    'DDR5 32GB*2 (4800Mhz)',
    'Intel® Killer™ Wi-Fi 6E AX1675',
    '4 cell, 99.99Whr',
  ];

  @override
  Widget build(BuildContext context) {
    final fromKey = GlobalKey();
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text(
          'Product Screen',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
      ),
      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Image(
                  image: const NetworkImage(
                      'https://wallpaperaccess.com/full/112373.jpg'),
                  width: double.infinity,
                  height: 210,
                  key: fromKey,
                ),
                const SizedBox(height: 15),
                const Text(
                  'MSI Titan GT77 12UHS 034',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 5),
                const Text(
                  'RM 24,999.00',
                  style: TextStyle(
                    color: Colors.redAccent,
                    fontSize: 17,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 10),
                ListView.separated(
                  shrinkWrap: true,
                  itemCount: features.length,
                  itemBuilder: (context, index) {
                    return Text(
                      '* ${features[index]}',
                      style: const TextStyle(fontWeight: FontWeight.w500),
                    );
                  },
                  separatorBuilder: (context, index) {
                    return const SizedBox(height: 5);
                  },
                ),
              ],
            ),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 15,
                  vertical: 10,
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          setState(() {
                            fromPosition = getPositionByKey(fromKey);
                          });
                          controller.reset();
                          controller.forward();
                        },
                        style: ElevatedButton.styleFrom(
                          minimumSize: const Size(double.infinity, 45),
                          elevation: 0,
                          shadowColor: Colors.transparent,
                          backgroundColor: Colors.transparent,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5),
                            side: const BorderSide(
                              color: Colors.black45,
                              width: 1.5,
                            ),
                          ),
                        ),
                        child: const Text(
                          'Add to Cart!',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 25),
                    Container(
                      width: 45,
                      height: 45,
                      decoration: BoxDecoration(
                        color: Colors.transparent,
                        borderRadius: BorderRadius.circular(100),
                        border: Border.all(
                          color: Colors.black45,
                          width: 1.5,
                        ),
                      ),
                      child: Stack(
                        children: [
                          buildFlyWidget(),
                          const Positioned.fill(
                            child: Icon(
                              Icons.shopping_cart,
                              color: Colors.black54,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
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
      width: 45,
      height: 45,
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
              child: ClipRRect(
                borderRadius: BorderRadius.circular(100),
                child: const SizedBox(
                  width: 45,
                  height: 45,
                  child: Image(
                    image: NetworkImage(
                        'https://wallpaperaccess.com/full/112373.jpg'),
                    fit: BoxFit.fill,
                  ),
                ),
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
