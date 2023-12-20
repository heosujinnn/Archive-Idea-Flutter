import 'package:archive_idea_flutter/database/database_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

import '../data/idea_info.dart';

class DetailScreen extends StatelessWidget {
  IdeaInfo? ideaInfo;
  final dbHelper = DatabaseHelper();

  DetailScreen({super.key, this.ideaInfo});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: GestureDetector(
          child: Icon(
            Icons.arrow_back_ios_new,
            size: 24,
            color: Colors.black,
          ),
          onTap: () {
            Navigator.pop(context);
          },
        ),
        title: Text(
          ideaInfo!.title,
          style: TextStyle(color: Colors.black, fontSize: 16),
        ),
        actions: [
          TextButton(
            onPressed: () {
              // 팝업창 : 진짜 삭제할 것인지 물어봄
              showDialog(
                context: context,
                builder: (context) {
                  return AlertDialog(
                    title: Text('주의'),
                    content: Text('아이디어를 삭제하시겠습니까?'),
                    actions: [
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pop(); // 다이어로그 끄기
                        },
                        child: Text(
                          '취소',
                          style: TextStyle(color: Colors.grey),
                        ),
                      ),
                      TextButton(
                        onPressed: () async {
                          //삭제하기 위해 db상에서 삭제하고 이 화면 빠져나가기
                          // async 로 await 해서 순차적으로 처리하기 위해 db제거 후에 화면으로 복기해야함.
                          await setDeleteIdeaInfo(ideaInfo!
                              .id!); // 아이디 값도 존재하고 데이터 타입도 맞춰주기 위해 ! 씀.
                          if (context.mounted) {
                            Navigator.of(context).pop();
                            Navigator.pop(context);
                          }
                        },
                        child: Text(
                          '확인',
                          style: TextStyle(color: Colors.red),
                        ),
                      ),
                    ],
                  );
                },
              );
            },
            child: Text(
              '삭제',
              style: TextStyle(color: Colors.red, fontSize: 16),
            ),
          )
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 비율 1 최대한 꽉차게 하고 버튼을 밀어내게~~
          Expanded(flex:1, child: SingleChildScrollView(
            child: Container(
              margin: EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  /// 아이디어를 떠올린 계기
                  Text(
                    '아이디어를 떠올린 계기',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    ideaInfo!.motive,
                    style: TextStyle(
                      color: Color(0xffa5a5a5),
                    ),
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  // 마진
                  /// 아이디어 내용
                  Text(
                    '아이디어 내용',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    ideaInfo!.content,
                    style: TextStyle(
                      color: Color(0xffa5a5a5),
                    ),
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  // 마진
                  /// 아이디어 중요도 점수
                  Text(
                    '아이디어 중요도 점수',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  RatingBar.builder(
                    initialRating: ideaInfo!.priority.toDouble(),
                    minRating: 1,
                    //최소 한개
                    itemCount: 5,
                    // 최대 다섯개
                    direction: Axis.horizontal,
                    //가로 정렬
                    itemSize: 35,
                    itemPadding: EdgeInsets.symmetric(horizontal: 0),
                    itemBuilder: (context, index) {
                      return Icon(
                        Icons.star,
                        color: Colors.amber,
                      );
                    },
                    ignoreGestures: true,
                    updateOnDrag: false,
                    onRatingUpdate: (value) {},
                  ),
                  SizedBox(
                    height: 30,
                  ),

                  /// 유저 피드백 사항
                  Text(
                    '유저 피드백 사항',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    ideaInfo!.feedback,
                    style: TextStyle(
                      color: Color(0xffa5a5a5),
                    ),
                  ),
                  SizedBox(
                    height: 30,
                  ),
                ],
              ),
            ),
          ),),
          /// 내용 편집하기 버튼
          GestureDetector(
              child: Container(
                margin: EdgeInsets.symmetric(vertical: 16, horizontal: 16),
                alignment: Alignment.center,
                height: 65,
                child: Text('아이디어 작성 완료'),
                decoration: ShapeDecoration(
                  color: Colors.white,
                  shape: RoundedRectangleBorder(
                    side: BorderSide(
                      width: 1,
                      color: Colors.black,
                    ),
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
              onTap: () async {
                //아이디어 수정화면으로 이동
                Navigator.pushNamed(context, '/edit',arguments: ideaInfo);
              },),
        ],
      ),
    );
  }

  Future setDeleteIdeaInfo(int id) async {
    // 기존 아이디어 제거를 위해 database_helper 안에 deleteIndeaInfo로 id를 넘기고 제거하는 함수
    await dbHelper.initDatabase();
    await dbHelper.deleteIdeaInfo(id);
  }
}
