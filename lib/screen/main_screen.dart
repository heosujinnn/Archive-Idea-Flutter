import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0, //입체감
        title: Text(
          'Archive Idea',
          style: TextStyle(
            color: Colors.black,
            fontSize: 32,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Container(
        margin: EdgeInsets.all(16), // 전체 마진
        child: ListView.builder(
          itemCount: 10,
          itemBuilder: (context, index) {
            return listItem(index);
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: (){
          // 새 아이디어 작성화면 이동
        },
        child: Image.asset('assets/idea.png',width: 48,height: 48,),
        backgroundColor: Color(0xff7f52fd).withOpacity(0.7), //Floating 버튼 색상,투명도
      ),
    );
  }

  Widget listItem(int index) {
    return Container(
      // 둥그런 컨테이너
      height: 82,
      margin: EdgeInsets.only(top: 16),
      decoration: ShapeDecoration(
        shape: RoundedRectangleBorder(
          side: BorderSide(color: Color(0xffd9d9d9), width: 1),
          borderRadius: BorderRadius.circular(10),
        ),
      ),
      child: Stack(
        // stack : 쌓아 올릴 수 있다(겹칠수도있다) 컬럼이랑 로우랑 좀 다른
        alignment: Alignment.centerLeft,
        children: [
          /// 아이디어 제목
          Container(
            margin: EdgeInsets.only(left: 16, bottom: 16),
            child: Text(
              '# 환경보존 문제해결 앱 아이디어',
              style: TextStyle(fontSize: 16),
            ),
          ),

          /// 일시
          Align( // 위치 조정
            alignment: Alignment.bottomRight,
            child: Container(
              margin: EdgeInsets.only(right: 16, bottom: 8),
              child: Text(
                '2023.11.27 03:50',
                style: TextStyle(color: Color(0xffaeaeae), fontSize: 10),
              ),
            ),
          ),

          /// 아이디어 중요도(별 중요도)
          Align(
            alignment: Alignment.bottomLeft,
            child:Container(
              margin: EdgeInsets.only(left: 16,bottom: 8),
              child: RatingBar.builder(
              initialRating: 3, //별이 3개 기본
              minRating: 1, //최소 한개
              itemCount: 5, // 최대 다섯개
              direction: Axis.horizontal, //가로 정렬
              itemSize: 16,
              itemPadding: EdgeInsets.symmetric(horizontal: 0),
              itemBuilder: (context,index){
                return Icon(Icons.star, color: Colors.amber,);
              },
              ignoreGestures: true,
              updateOnDrag: false,
              onRatingUpdate: (value) {

              },),
            ),)

        ],
      ),
    );
  }
}
