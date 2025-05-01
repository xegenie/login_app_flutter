import 'package:flutter/material.dart';

class CommonBottomNavigationBar extends StatelessWidget {

  // state
  final int currentIndex;

  const CommonBottomNavigationBar({
    Key? key,
    required this.currentIndex,
    }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
        type: BottomNavigationBarType.fixed, // 4개 이상이면 필요
        selectedItemColor: Colors.blue, // 선택된 아이템 컬러
        unselectedItemColor: Theme.of(context).primaryColor,                // 선택 X 아이템 컬러
        currentIndex: currentIndex,
        onTap: (index) {
          switch (index) {
            case 0: Navigator.pushReplacementNamed(context, '/'); break;
            case 1: Navigator.pushReplacementNamed(context, '/user/search'); break;
            case 2: Navigator.pushReplacementNamed(context, '/user/product'); break;
            case 3: Navigator.pushReplacementNamed(context, '/user/cart'); break;
            case 4: Navigator.pushReplacementNamed(context, '/mypage/profile'); break;
            default:
          }
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: "홈",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.search),
            label: "검색",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.category),
            label: "상품",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_cart),
            label: "장바구니",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: "마이",
          )
        ]
      );
  }
}