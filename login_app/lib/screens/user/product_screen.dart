import 'package:flutter/material.dart';
import 'package:login_app/widgets/common_bottom_navigation_bar.dart';
import 'package:login_app/widgets/custom_drawer.dart';

class ProductScreen extends StatefulWidget {
  const ProductScreen({super.key});

  @override
  State<ProductScreen> createState() => _ProductScreenState();
}

class _ProductScreenState extends State<ProductScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("상품"),
      ),
      body: Center(
        child: 
          const Text("상품 화면"),
      ),
      endDrawer: CustomDrawer(),
      bottomNavigationBar: CommonBottomNavigationBar(
        currentIndex: 2
      )
    );;
  }
}