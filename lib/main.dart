import 'dart:html';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

// Product model
class Product {
  final String name;
  final String description;
  final double price;
  final String imageUrl;
  final String color;

  Product({
    required this.name,
    required this.description,
    required this.price,
    required this.imageUrl,
    required this.color,
  });
}

// Cart item model
class CartItem {
  final Product product;
  int quantity;

  CartItem({required this.product, this.quantity = 1});
}

// Cart state
class CartState {
  final List<CartItem> items;

  CartState({required this.items});

}

// Cart events
abstract class CartEvent {}

class AddToCartEvent extends CartEvent {
  final Product product;

  AddToCartEvent(this.product);
}

class RemoveFromCartEvent extends CartEvent {
  final CartItem item;

  RemoveFromCartEvent(this.item);
}

class IncreaseQuantityEvent extends CartEvent {
  final CartItem item;

  IncreaseQuantityEvent(this.item);
}

class DecreaseQuantityEvent extends CartEvent {
  final CartItem item;

  DecreaseQuantityEvent(this.item);
}

// Cart bloc
class CartBloc extends Bloc<CartEvent, CartState> {
  CartBloc() : super(CartState(items: [])) {
    on<AddToCartEvent>(_addToCart);
    on<RemoveFromCartEvent>(_removeFromCart);
    on<IncreaseQuantityEvent>(_increaseQuantity);
    on<DecreaseQuantityEvent>(_decreaseQuantity);
  }

  Stream<CartState> _addToCart(AddToCartEvent event, Emitter<CartState> emit) async* {
    final currentState = state;
    final updatedItems = List<CartItem>.from(currentState.items);

    for (var item in updatedItems) {
      if (item.product == event.product) {
        item.quantity++;
        emit(CartState(items: updatedItems));
        return;
      }
    }

    updatedItems.add(CartItem(product: event.product));
    emit(CartState(items: updatedItems));
  }

  Stream<CartState> _removeFromCart(RemoveFromCartEvent event, Emitter<CartState> emit) async* {
    final currentState = state;
    final updatedItems = List<CartItem>.from(currentState.items);
    updatedItems.remove(event.item);
    emit(CartState(items: updatedItems));
  }

  Stream<CartState> _increaseQuantity(IncreaseQuantityEvent event, Emitter<CartState> emit) async* {
    final currentState = state;
    final updatedItems = List<CartItem>.from(currentState.items);
    final index = updatedItems.indexOf(event.item);
    updatedItems[index].quantity++;
    emit(CartState(items: updatedItems));
  }

  Stream<CartState> _decreaseQuantity(DecreaseQuantityEvent event, Emitter<CartState> emit) async* {
    final currentState = state;
    final updatedItems = List<CartItem>.from(currentState.items);
    final index = updatedItems.indexOf(event.item);
    if (updatedItems[index].quantity > 1) {
      updatedItems[index].quantity--;
    } else {
      updatedItems.removeAt(index);
    }
    emit(CartState(items: updatedItems));
  }
}

// Products data
final List<Product> products = [
  Product(
    name: 'Nike Air Zoom Pegasus 36',
    description: 'The iconic Nike Air Zoom Pegasus 36 offers more cooling and mesh that targets breathability across high-heat areas. A slimmer heel collar and tongue reduce bulk, while exposed cables give you a snug fit at higher speeds.',
    price: 108.97,
    imageUrl: 'https://s3-us-west-2.amazonaws.com/s.cdpn.io/1315882/air-zoom-pegasus-36-mens-running-shoe-wide-D24Mcz-removebg-preview.png',
    color: '#e1e7ed',
  ),
  Product(
    name: 'Nike Air Zoom Pegasus 36 Shield',
    description: 'The Nike Air Zoom Pegasus 36 Shield gets updated to conquer wet routes. A water-repellent upper combines with an outsole that helps create grip on wet surfaces, letting you run in confidence despite the weather.',
    price: 89.97,
    imageUrl: 'https://s3-us-west-2.amazonaws.com/s.cdpn.io/1315882/air-zoom-pegasus-36-shield-mens-running-shoe-24FBGb__1_-removebg-preview.png',
    color: '#4D317F',
  ),
  Product(
    name: 'Nike CruzrOne',
    description: 'Designed for steady, easy-paced movement, the Nike CruzrOne keeps you going. Its rocker-shaped sole and plush, lightweight cushioning let you move naturally and comfortably. The padded collar is lined with soft wool, adding luxury to every step, while mesh details let your foot breathe. There’s no finish line—there’s only you, one step after the next.',
    price: 100.97,
    imageUrl: 'https://s3-us-west-2.amazonaws.com/s.cdpn.io/1315882/cruzrone-unisex-shoe-T2rRwS-removebg-preview.png',
    color: '#E8D026',
  ),
  Product(
    name: 'Nike Epic React Flyknit 2',
    description: 'The Nike Epic React Flyknit 2 takes a step up from its predecessor with smooth, lightweight performance and a bold look. An updated Flyknit upper conforms to your foot with a minimal, supportive design. Underfoot, durable Nike React technology defies the odds by being both soft and responsive, for comfort that lasts as long as you can run.',
    price: 89.97,
    imageUrl: 'https://s3-us-west-2.amazonaws.com/s.cdpn.io/1315882/epic-react-flyknit-2-mens-running-shoe-2S0Cn1-removebg-preview.png',
    color: '#FD584A',
  ),
  Product(
    name: 'Nike Odyssey React Flyknit 2',
    description: 'The Nike Odyssey React Flyknit 2 provides a strategic combination of lightweight Flyknit construction and synthetic material for support. Underfoot, Nike React cushioning delivers a soft, springy ride for a route that begs to be crushed.',
    price: 71.97,
    imageUrl: 'https://s3-us-west-2.amazonaws.com/s.cdpn.io/1315882/odyssey-react-flyknit-2-mens-running-shoe-T3VG7N-removebg-preview.png',
    color: '#D4D7D6',
  ),
  Product(
    name: 'Nike React Infinity Run Flyknit',
    description: 'A pioneer in the running shoe frontier honors the original pioneer of running culture with the Nike React Infinity Run Flyknit. Blue Ribbon Track Club-inspired details pay homage to the haven that was created before running was even popular. This running shoe is designed to help reduce injury and keep you on the run. More foam and improved upper details provide a secure and cushioned feel.',
    price: 160.0,
    imageUrl: 'https://s3-us-west-2.amazonaws.com/s.cdpn.io/1315882/react-infinity-run-flyknit-mens-running-shoe-RQ484B__2_-removebg-preview.png',
    color: '#F2F5F4',
  ),
  Product(
    name: 'Nike React Miler',
    description: 'The Nike React Miler gives you trusted stability for miles with athlete-informed performance. Made for dependability on your long runs, its intuitive design offers a locked-in fit and a durable feel.',
    price: 130.0,
    imageUrl: 'https://s3-us-west-2.amazonaws.com/s.cdpn.io/1315882/react-miler-mens-running-shoe-DgF6nr-removebg-preview.png',
    color: '#22AFDC',
  ),
  Product(
    name: 'Nike Renew Ride',
    description: 'The Nike Renew Ride helps keep the committed runner moving with plush cushioning. Firm support at the outsole helps you maintain stability no matter the distance.',
    price: 60.97,
    imageUrl: 'https://s3-us-west-2.amazonaws.com/s.cdpn.io/1315882/renew-ride-mens-running-shoe-JkhdfR-removebg-preview.png',
    color: '#B50320',
  ),
  Product(
    name: 'Nike Vaporfly 4% Flyknit',
    description: 'Built to meet the exacting needs of world-class marathoners, Nike Vaporfly 4% Flyknit is designed for record-breaking speed. The Flyknit upper delivers breathable support, while the responsive foam and full-length plate provide incredible energy return for all 26.2.',
    price: 187.97,
    imageUrl: 'https://s3-us-west-2.amazonaws.com/s.cdpn.io/1315882/vaporfly-4-flyknit-running-shoe-v7G3FB-removebg-preview.png',
    color: '#3569A1',
  ),
  Product(
    name: 'Nike Zoom Fly 3 Premium',
    description: 'Inspired by the Vaporfly, the Nike Zoom Fly 3 Premium gives distance runners race-day comfort and durability. The power of a carbon fiber plate keeps you in the running mile after mile.',
    price: 160.0,
    imageUrl: 'https://s3-us-west-2.amazonaws.com/s.cdpn.io/1315882/zoom-fly-3-premium-mens-running-shoe-XhzpPH-removebg-preview.png',
    color: '#54D4C9',
  ),
];

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final sharedPreferences = await SharedPreferences.getInstance();
  final cartBloc = CartBloc();

  runApp(MyApp(cartBloc: cartBloc, sharedPreferences: sharedPreferences));
}

class MyApp extends StatelessWidget {
  final CartBloc cartBloc;
  final SharedPreferences sharedPreferences;

  const MyApp({super.key, 
    required this.cartBloc,
    required this.sharedPreferences,
  });

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'G-Sneaker',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MultiBlocProvider(
        providers: [
          BlocProvider.value(value: cartBloc),
        ],
        child: MyHomePage(sharedPreferences: sharedPreferences),
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  
  final SharedPreferences sharedPreferences;

  const MyHomePage({Key? key, required this.sharedPreferences}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> with SingleTickerProviderStateMixin{
  List<CartItem> cartItems = [];
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: Duration(seconds: 2),
      vsync: this,
    )..repeat(reverse: true);
    _animation = Tween<double>(begin: -0.14, end: 0.14).animate(_controller);
    _loadCartItems();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _loadCartItems() async {
    final cartData = widget.sharedPreferences.getStringList('cartItems');
    if (cartData != null) {
      setState(() {
        cartItems = cartData.map((json) {
          final data = jsonDecode(json);
          final product = products.firstWhere(
            (product) => product.name == data['name'],
          );
          return CartItem(
            product: product,
            quantity: data['quantity'],
          );
        }).toList();
      });
    }
  }

  Future<void> _saveCartItems(List<CartItem> items) async {
    final cartData = items.map((item) {
      return jsonEncode({'name': item.product.name, 'quantity': item.quantity});
    }).toList();
    await widget.sharedPreferences.setStringList('cartItems', cartData);
  }

  Color hexToColor(String hexString) {
    String formattedHexString = hexString.replaceAll("#", "");
    Color colorValue = Color(int.parse(formattedHexString, radix: 16) | 0xFF000000);
    return colorValue;
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<CartBloc>(
      create: (context) => CartBloc(),
      child: Scaffold(
        body: Builder(
            builder: (context) {
              final cartBloc = BlocProvider.of<CartBloc>(context);
              return Stack(
              children: [
                Positioned.fill(
                  child: Container(
                    width: double.infinity,
                    height: double.infinity,
                    color: const Color(0xFFF6C90E),
                    transform: Matrix4.skewY(-0.14)..translate(-0.5, 0),
                    child: null,
                  ),
                ),Container(
                    child:Center(
                      child: Container(
                        constraints: BoxConstraints(maxWidth: 760),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                color: Colors.white,
                                boxShadow: [
                                  BoxShadow(
                                    color: Color.fromRGBO(0, 0, 0, 0.1),
                                    blurRadius: 10,
                                    offset: Offset(0, 2),
                                  ),
                                ],
                                borderRadius: BorderRadius.circular(30),
                              ),
                              height: 600,
                              width: 360,
                              padding: EdgeInsets.symmetric(horizontal: 28),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  margin: EdgeInsets.only(top: 12, bottom: 12),
                                  child: Image.network(
                                    '../assets/nike.png',
                                    width: 50,
                                  ),
                                ),
                                Container(
                                  margin: EdgeInsets.only(top: 12, bottom: 12),
                                  child: Text(
                                    'Our Products',
                                    style: TextStyle(
                                      fontSize: 24,
                                      fontWeight: FontWeight.w900,
                                      fontFamily: 'Rubik, sans-serif',
                                    ),
                                  ),
                                ),
                                Expanded(
                                  child: ListView.builder(
                                    itemCount: products.length,
                                    itemBuilder: (context, index) {
                                      final product = products[index];
                                      final isAddedToCart = cartItems.any(
                                        (item) => item.product == product,
                                      );

                                      EdgeInsets padding;
                                      if (index == 0) {
                                        padding = EdgeInsets.fromLTRB(0, 0, 0, 40);
                                      } else {
                                        padding = EdgeInsets.fromLTRB(0, 20, 0, 40);
                                      }

                                      return Padding(
                                        padding: padding,
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Container(
                                              decoration: BoxDecoration(
                                                color: hexToColor(product.color),
                                                borderRadius: BorderRadius.circular(30),
                                              ),
                                              height: 380,
                                              child: LayoutBuilder(
                                                builder: (BuildContext context, BoxConstraints constraints) {
                                                  return Transform.rotate(
                                                    angle: -24 * 3.14159 / 180,
                                                    child: Stack(
                                                      children: [
                                                        Transform.translate(
                                                          offset: Offset(-16, 0),
                                                          child: Image.network(
                                                            product.imageUrl,
                                                            width: constraints.maxWidth,
                                                            height: constraints.maxHeight,
                                                            // fit: BoxFit.cover,
                                                            // filterQuality: FilterQuality.high,
                                                          ),
                                                        ),
                                                        
                                                      ],
                                                    ),
                                                  );
                                                },
                                              ),
                                            ),
                                            Container(
                                              margin: const EdgeInsets.fromLTRB(0, 26, 0, 20),
                                              child: Text(
                                                product.name,
                                                style: TextStyle(
                                                  fontSize: 20,
                                                  fontWeight: FontWeight.w700,
                                                  height: 1.5,
                                                  fontFamily: 'Rubik,sans-serif',
                                                ),
                                              ),
                                            ),
                                            Container(
                                              margin: const EdgeInsets.fromLTRB(0, 0, 0, 20),
                                              child: Text(
                                                product.description,
                                                style: TextStyle(
                                                  fontSize: 13,
                                                  color: Colors.grey,
                                                ),
                                              ),
                                            ),
                                            
                                            Row(
                                              mainAxisSize: MainAxisSize.max,
                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              children: [
                                                Text(
                                                  '\$${product.price}',
                                                  style: TextStyle(
                                                    fontSize: 18,
                                                    fontWeight: FontWeight.w700,
                                                  ),
                                                ),
                                                if (isAddedToCart)
                                                  Container(
                                                    padding: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                                                    decoration: BoxDecoration(
                                                      shape: BoxShape.circle,
                                                      color: const Color(0xFFF6C90E),
                                                    ),
                                                    child: Image.asset(
                                                      '../assets/check.png',
                                                      height: 20,
                                                    ),
                                                  )
                                                else
                                                  ElevatedButton(
                                                    onPressed: () {
                                                      final cartBloc = BlocProvider.of<CartBloc>(context);
                                                      cartBloc.add(AddToCartEvent(product));
                                                      setState(() {
                                                        cartItems.add(CartItem(product: product));
                                                      });
                                                      _saveCartItems(cartItems);
                                                    },
                                                    style: ButtonStyle(
                                                      backgroundColor: MaterialStateProperty.all<Color>(Color(0xFFF6C90E)),
                                                      foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
                                                      textStyle: MaterialStateProperty.all<TextStyle>(
                                                        TextStyle(
                                                          fontWeight: FontWeight.w700,
                                                          fontSize: 14,
                                                          color: Color(0x303841)
                                                        ),
                                                      ),
                                                      minimumSize: MaterialStateProperty.all<Size>(Size(46, 46)),
                                                      padding: MaterialStateProperty.all<EdgeInsetsGeometry>(
                                                        EdgeInsets.symmetric(vertical: 16, horizontal: 20),
                                                      ),
                                                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                                                        RoundedRectangleBorder(
                                                          borderRadius: BorderRadius.circular(100),
                                                        ),
                                                      ),
                                                    ),
                                                    child: const Text('ADD TO CART'),
                                                  ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      );
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(width: 20), // Add spacing between the two containers
                          Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              boxShadow: [
                                BoxShadow(
                                  color: Color.fromRGBO(0, 0, 0, 0.1),
                                  blurRadius: 10,
                                  offset: Offset(0, 2),
                                ),
                              ],
                              borderRadius: BorderRadius.circular(30),
                            ),
                            height: 600,
                            width: 360,
                            padding: EdgeInsets.symmetric(horizontal: 28),
                            
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  margin: EdgeInsets.only(top: 12, bottom: 12),
                                  child: Image.asset(
                                    '../assets/nike.png',
                                    width: 50,
                                  ),
                                ),
                                Container(
                                  margin: EdgeInsets.symmetric(vertical: 16),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      DefaultTextStyle(
                                        style: TextStyle(
                                          fontSize: 24,
                                          fontWeight: FontWeight.bold,
                                        ),
                                        child: Text('Your Cart'),
                                      ),
                                      DefaultTextStyle(
                                        style: TextStyle(
                                          fontSize: 24,
                                          fontWeight: FontWeight.bold,
                                        ),
                                        child:
                                          Column(
                                            children: [
                                              BlocBuilder<CartBloc, CartState>(
                                                builder: (context, state) {
                                                  double totalPrice = 0;
                                                  for (var item in cartItems) {
                                                    totalPrice += item.product.price * item.quantity;
                                                  }
                                                  return Text(
                                                    '\$${totalPrice.toStringAsFixed(2)}',
                                                  );
                                                },
                                              ),
                                            ]
                                          )
                                      ),
                                    ],
                                  ),
                                ),
                                if (cartItems.isEmpty)
                                  ListTile(
                                    title: Text.rich(
                                      TextSpan(
                                        text: 'Your cart is empty.',
                                        style: const TextStyle(fontSize: 14),
                                      ),
                                    ),
                                  )
                                else
                                  Expanded(
                                    child:
                                    ListView.builder(
                                      shrinkWrap: true,
                                      
                                      itemCount: cartItems.length,
                                      itemBuilder: (context, index) {
                                        final item = cartItems[index];
                                        return Padding(
                                          padding: EdgeInsets.fromLTRB(0, 20, 0, 20),
                                          child: Row(
                                            mainAxisSize: MainAxisSize.max,
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [
                                            Container(
                                                decoration: BoxDecoration(
                                                  color: hexToColor(item.product.color),
                                                  borderRadius: BorderRadius.circular(100),
                                                ),
                                                width: 90,  // Adjust the width to your desired value
                                                height: 90,
                                                child: LayoutBuilder(
                                                  builder: (BuildContext context, BoxConstraints constraints) {
                                                    return Transform.scale(
                                                      scale: 1.7, // Tỷ lệ phóng to của hình ảnh
                                                      child: Transform.rotate(
                                                        angle: -24 * 3.14159 / 180,
                                                        child: Stack(
                                                          children: [
                                                            Transform.translate(
                                                              offset: Offset(5, -10),
                                                              child: Image.network(
                                                                item.product.imageUrl,
                                                                width: constraints.maxWidth,
                                                                height: constraints.maxHeight,
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    );
                                                  },
                                                ),
                                              ),
                                            Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Container(
                                                  margin: const EdgeInsets.fromLTRB(0, 0, 0, 16),
                                                  width: 170,
                                                  child: Text(
                                                    item.product.name,
                                                    style: TextStyle(
                                                      fontSize: 14,
                                                      fontWeight: FontWeight.w700,
                                                      height: 1.5,
                                                    ),
                                                  ),
                                                ),
                                                Container(
                                                  margin: const EdgeInsets.fromLTRB(0, 0, 0, 16),
                                                  width: 170,
                                                  child: Text(
                                                    '\$${item.product.price}',
                                                    style: TextStyle(
                                                      fontSize: 20,
                                                      fontWeight: FontWeight.w700,
                                                      height: 1.5,
                                                    ),
                                                  ),
                                                ),
                                                Row(
                                                  mainAxisSize: MainAxisSize.max,
                                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                  children: [
                                                    Row(
                                                    mainAxisSize: MainAxisSize.min,
                                                    children: [
                                                      IconButton(
                                                        onPressed: () {
                                                          final cartBloc =
                                                              BlocProvider.of<CartBloc>(context);
                                                          cartBloc.add(DecreaseQuantityEvent(item));
                                                          setState(() {
                                                            cartItems[index].quantity--;
                                                          });
                                                          if (cartItems[index].quantity <= 0) {
                                                            setState(() {
                                                              cartItems.removeAt(index);
                                                            });
                                                          }
                                                          _saveCartItems(cartItems);
                                                        },
                                                        icon: const Icon(Icons.remove,size: 15,),
                                                      ),
                                                      Container(
                                                        margin: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                                                        child: Text(
                                                          item.quantity.toString(),
                                                          style: TextStyle(
                                                            fontSize: 14,
                                                          ),
                                                        ),
                                                      ),
                                                      IconButton(
                                                        onPressed: () {
                                                          final cartBloc =
                                                              BlocProvider.of<CartBloc>(context);
                                                          cartBloc.add(IncreaseQuantityEvent(item));
                                                          setState(() {
                                                            cartItems[index].quantity++;
                                                          });
                                                          _saveCartItems(cartItems);
                                                        },
                                                        icon: const Icon(Icons.add, size: 15,),
                                                      ),
                                                    ],
                                                  ),
                                                  SizedBox(width: 30,),
                                                  InkWell(
                                                        onTap: () {
                                                          final cartBloc = BlocProvider.of<CartBloc>(context);
                                                          cartBloc.add(RemoveFromCartEvent(item));
                                                          setState(() {
                                                            cartItems.removeAt(index);
                                                          });
                                                          _saveCartItems(cartItems);
                                                        },
                                                        child: Container(
                                                          padding: EdgeInsets.symmetric(vertical: 5, horizontal: 5),
                                                          decoration: BoxDecoration(
                                                            shape: BoxShape.circle,
                                                            color: const Color(0xFFF6C90E),
                                                          ),
                                                          child: Image.network(
                                                            '../assets/trash.png',
                                                            height: 18,
                                                          ),
                                                        ),
                                                      ),
                                                  ]
                                                )
                                              ]
                                            )
                                          ],)
                                        );
                                      },
                                    ),
                                  ),
                                
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ]
            );
          }
        )
      )
    );
  }
}