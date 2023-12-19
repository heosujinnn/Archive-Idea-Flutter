import 'package:archive_idea_flutter/data/idea_info.dart';
import 'package:archive_idea_flutter/database/database_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:intl/intl.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  var dbHelper= DatabaseHelper(); // db접근을 용이하게 해주는 유틸 객체
  List<IdeaInfo> lstIdeaInfo=[];  // 아이디어 목록 데이터들이 담길 공간

  @override
  void initState() {
    super.initState();

    //아이디어 목록을 가져오기
    //getIdeaInfo();

    //(임시)
    //setInsertIdeaInfo();
  }

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
          itemCount: lstIdeaInfo.length,
          itemBuilder: (context, index) {
            return listItem(index);
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: (){
          // 새 아이디어 작성화면 이동
          Navigator.pushNamed(context,'/edit');
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
              lstIdeaInfo[index].title,
              style: TextStyle(fontSize: 16),
            ),
          ),

          /// 일시
          Align( // 위치 조정
            alignment: Alignment.bottomRight,
            child: Container(
              margin: EdgeInsets.only(right: 16, bottom: 8),
              child: Text(
                // createAt -> intl
                DateFormat("yyyy.MM.dd HH:mn").format(DateTime.fromMillisecondsSinceEpoch(lstIdeaInfo[index].createdAt)),
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
              initialRating: lstIdeaInfo[index].priority.toDouble(),
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

  Future<void> getIdeaInfo() async {
    await dbHelper.initDatabase();
    //idea 정보를 가지고와서 멤버 전역변수 리스트 객체에 담기
    lstIdeaInfo=await dbHelper.getAllIdeaInfo();
    lstIdeaInfo.sort((a, b) => b.createdAt.compareTo(a.createdAt),); // b생성일자와 a생성일자를 비교
    setState(() {}); // 리스트 갱신해주기

  }

  Future<void> setInsertIdeaInfo() async {
    await dbHelper.initDatabase();
    await dbHelper.insertIdeaInfo(IdeaInfo(
      title: '#환경 보존',
      motive: '쓰레기줍다가..',
      content: 'test',
      priority: 5,
      feedback: 'feedback test',
      createdAt: DateTime.now().millisecondsSinceEpoch,
    ),);
  }
}
