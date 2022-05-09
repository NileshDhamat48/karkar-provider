import 'package:karkar_provider_app/constants/all_imports.dart';

class IconButton1 extends StatelessWidget {
  final IconData icon;
  final double height;
  final double width;
  final VoidCallback onpressed;
  final double iconsize;
  const IconButton1({
    Key? key,
    required this.icon,
    required this.height,
    required this.width,
    required this.onpressed,
    required this.iconsize,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      width: width,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(50),
        gradient: const LinearGradient(
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
            colors: [Colors.green, Colors.blue]),
      ),
      child: MaterialButton(
        onPressed: onpressed,
        textColor: Colors.white,
        child: Icon(
          icon,
          size: iconsize,
        ),
      ),
    );
  }
}
