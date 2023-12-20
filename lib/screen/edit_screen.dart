import 'package:archive_idea_flutter/database/database_helper.dart';
import 'package:flutter/material.dart';

import '../data/idea_info.dart';

class EditScreen extends StatefulWidget {
  IdeaInfo? ideaInfo;

  EditScreen({super.key, this.ideaInfo});

  @override
  State<EditScreen> createState() => _EditScreenState();
}

class _EditScreenState extends State<EditScreen> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _motiveController = TextEditingController();
  final TextEditingController _contentController = TextEditingController();
  final TextEditingController _feedbackController = TextEditingController();

  // 아이디어 중요도 점수 container 클릭 상태 관리 변수
  bool isClickPoint1 = false;
  bool isClickPoint2 = false;
  bool isClickPoint3 = true; //초기값
  bool isClickPoint4 = false;
  bool isClickPoint5 = false;

  // 아이디어 선택된 현재 중요도 점수( default value = 3 )
  int priorityPoint = 3;

  // 데이터베이스 Helper
  final dbHelper = DatabaseHelper();

  @override
  void initState() {
    super.initState();

    // 기존 데이터를 수정할 경우 수정의 편의를 위해 기존 데이터를 입력 자동으로 기입되도록
    if (widget.ideaInfo != null) {
      _titleController.text = widget.ideaInfo!.title;
      _motiveController.text = widget.ideaInfo!.motive;
      _contentController.text = widget.ideaInfo!.content;
      // 피드백 (선택) 값이 비어있는지 확인함.
      if (widget.ideaInfo!.feedback.isNotEmpty) {
        _feedbackController.text = widget.ideaInfo!.feedback;
      }

      //아이디어 중요도 점수 셋팅
      initClickStatus(); // 중요도 초기화하는 함수
      switch (widget.ideaInfo!.priority) {
        case 1:
          isClickPoint1 = true;
          break;
        case 2:
          isClickPoint2 = true;
          break;
        case 3:
          isClickPoint3 = true;
          break;
        case 4:
          isClickPoint4 = true;
          break;
        case 5:
          isClickPoint5 = true;
          break;
      }
      priorityPoint = widget.ideaInfo!.priority;
    }
  }

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
          // 아이디어데이터가 원래 없었으면(main에서 들어가면) title에 새 아이디어 작성이고,
          // (edit 아이디어 편집으로 들어가면) 원래 데이터가 있으면 아이디어편집으로 쓰여짐
          widget.ideaInfo == null ? '새 아이디어 작성' : '아이디어 편집',
          style: TextStyle(color: Colors.black, fontSize: 16),
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          margin: EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /// 제목
              Text('제목'),
              Container(
                margin: EdgeInsets.only(top: 8),
                height: 41,
                child: TextField(
                  textInputAction: TextInputAction.next,
                  decoration: InputDecoration(
                    contentPadding:
                        EdgeInsets.symmetric(vertical: 0, horizontal: 16),
                    border: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Color(0xffd9d9d9),
                      ),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    hintText: '아이디어 제목',
                    hintStyle: TextStyle(
                      color: Color(0xffb4b4b4),
                    ),
                  ),
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.black,
                  ),
                  controller: _titleController,
                ),
              ),

              /// 아이디어를 이용한 계기
              SizedBox(
                height: 16,
              ), // 간격 박스
              Text('아이디어를 떠올린 계기'),
              Container(
                margin: EdgeInsets.only(top: 8),
                height: 41,
                child: TextField(
                  textInputAction: TextInputAction.next,
                  decoration: InputDecoration(
                    contentPadding:
                        EdgeInsets.symmetric(vertical: 0, horizontal: 16),
                    border: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Color(0xffd9d9d9),
                      ),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    hintText: '내용입력',
                    hintStyle: TextStyle(
                      color: Color(0xffb4b4b4),
                    ),
                  ),
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.black,
                  ),
                  controller: _motiveController,
                ),
              ),
              SizedBox(
                height: 16,
              ),

              /// 아이디어 내용
              Text('아이디어 내용'),
              Container(
                margin: EdgeInsets.only(top: 8),
                child: TextField(
                  textInputAction: TextInputAction.next,
                  maxLines: 5,
                  maxLength: 500,
                  decoration: InputDecoration(
                    contentPadding:
                        EdgeInsets.symmetric(vertical: 16, horizontal: 16),
                    border: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Color(0xffd9d9d9),
                      ),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    hintText: '생각나는 아이디어를 자세하게 적어주세요..',
                    hintStyle: TextStyle(
                      color: Color(0xffb4b4b4),
                    ),
                  ),
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.black,
                  ),
                  controller: _contentController,
                ),
              ),

              /// 아이디어 중요도 점수
              SizedBox(
                height: 16,
              ),
              Text('아이디어 중요도 점수'),
              Container(
                margin: EdgeInsets.only(top: 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  // 균일하게 배치됨 children 끼리
                  children: [
                    GestureDetector(
                      child: Container(
                        alignment: Alignment.center,
                        width: 50,
                        height: 40,
                        decoration: ShapeDecoration(
                            color: isClickPoint1
                                ? Color(0xffd6d6d6)
                                : Colors.white, // 1번버튼이 클릭되면 색상 바꾸고 그렇지 않다면 흰색
                            shape: RoundedRectangleBorder(
                              side: BorderSide(width: 1, color: Colors.black),
                              borderRadius: BorderRadius.circular(10),
                            )),
                        child: Text(
                          '1',
                          style: TextStyle(
                              fontSize: 14,
                              color: Colors.black,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                      onTap: () {
                        //1. 모든 버튼 값 초기화
                        initClickStatus();
                        //2. 선택된 버튼에 대한 변수 값 및 위젯 업데이트
                        setState(() {
                          priorityPoint = 1;
                          isClickPoint1 = true;
                        });
                      },
                    ),
                    GestureDetector(
                      child: Container(
                        alignment: Alignment.center,
                        width: 50,
                        height: 40,
                        decoration: ShapeDecoration(
                            color: isClickPoint2
                                ? Color(0xffd6d6d6)
                                : Colors.white,
                            shape: RoundedRectangleBorder(
                              side: BorderSide(width: 1, color: Colors.black),
                              borderRadius: BorderRadius.circular(10),
                            )),
                        child: Text(
                          '2',
                          style: TextStyle(
                              fontSize: 14,
                              color: Colors.black,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                      onTap: () {
                        //1. 모든 버튼 값 초기화
                        initClickStatus();
                        //2. 선택된 버튼에 대한 변수 값 및 위젯 업데이트
                        setState(() {
                          priorityPoint = 1;
                          isClickPoint2 = true;
                        });
                      },
                    ),
                    GestureDetector(
                      child: Container(
                        alignment: Alignment.center,
                        width: 50,
                        height: 40,
                        decoration: ShapeDecoration(
                            color: isClickPoint3
                                ? Color(0xffd6d6d6)
                                : Colors.white,
                            shape: RoundedRectangleBorder(
                              side: BorderSide(width: 1, color: Colors.black),
                              borderRadius: BorderRadius.circular(10),
                            )),
                        child: Text(
                          '3',
                          style: TextStyle(
                              fontSize: 14,
                              color: Colors.black,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                      onTap: () {
                        //1. 모든 버튼 값 초기화
                        initClickStatus();
                        //2. 선택된 버튼에 대한 변수 값 및 위젯 업데이트
                        setState(() {
                          priorityPoint = 1;
                          isClickPoint3 = true;
                        });
                      },
                    ),
                    GestureDetector(
                      child: Container(
                        alignment: Alignment.center,
                        width: 50,
                        height: 40,
                        decoration: ShapeDecoration(
                            color: isClickPoint4
                                ? Color(0xffd6d6d6)
                                : Colors.white,
                            shape: RoundedRectangleBorder(
                              side: BorderSide(width: 1, color: Colors.black),
                              borderRadius: BorderRadius.circular(10),
                            )),
                        child: Text(
                          '4',
                          style: TextStyle(
                              fontSize: 14,
                              color: Colors.black,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                      onTap: () {
                        //1. 모든 버튼 값 초기화
                        initClickStatus();
                        //2. 선택된 버튼에 대한 변수 값 및 위젯 업데이트
                        setState(() {
                          priorityPoint = 1;
                          isClickPoint4 = true;
                        });
                      },
                    ),
                    GestureDetector(
                      child: Container(
                        alignment: Alignment.center,
                        width: 50,
                        height: 40,
                        decoration: ShapeDecoration(
                            color: isClickPoint5
                                ? Color(0xffd6d6d6)
                                : Colors.white,
                            shape: RoundedRectangleBorder(
                              side: BorderSide(width: 1, color: Colors.black),
                              borderRadius: BorderRadius.circular(10),
                            )),
                        child: Text(
                          '5',
                          style: TextStyle(
                              fontSize: 14,
                              color: Colors.black,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                      onTap: () {
                        //1. 모든 버튼 값 초기화
                        initClickStatus();
                        //2. 선택된 버튼에 대한 변수 값 및 위젯 업데이트
                        setState(() {
                          priorityPoint = 1;
                          isClickPoint5 = true;
                        });
                      },
                    ),
                  ],
                ),
              ),

              /// 아이디어 중요도 점수
              SizedBox(
                height: 16,
              ),
              Text('유저 피드백 사항 (선택)'),
              Container(
                margin: EdgeInsets.only(top: 8),
                child: TextField(
                  textInputAction: TextInputAction.next,
                  maxLines: 5,
                  maxLength: 500,
                  decoration: InputDecoration(
                    contentPadding:
                        EdgeInsets.symmetric(vertical: 16, horizontal: 16),
                    border: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Color(0xffd9d9d9),
                      ),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    hintText: '아이디어를 보고 떠오르시는 피드백을 적어주세요.',
                    hintStyle: TextStyle(
                      color: Color(0xffb4b4b4),
                    ),
                  ),
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.black,
                  ),
                  controller: _feedbackController,
                ),
              ),
              SizedBox(
                height: 16,
              ),
              GestureDetector(
                  child: Container(
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
                    //작성 처리(insert)
                    String titleValue = _titleController.text.toString();
                    String motiveValue = _motiveController.text.toString();
                    String contentValue = _contentController.text.toString();
                    String feedbackValue = _feedbackController.text.toString();

                    // 유효성 검사 ( 비어있는 필수 입력 값에 대해)
                    if (titleValue.isEmpty ||
                        motiveValue.isEmpty ||
                        contentValue.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('비어있는 입력값이 존재한다.'),
                          duration: Duration(seconds: 2),
                        ),
                      );
                      return;
                    }
                    // 아이디어 정보 클래스 인스턴스 생성 후 db 삽입
                    if (widget.ideaInfo == null) {
                      var ideaInfo = IdeaInfo(
                        title: titleValue,
                        motive: motiveValue,
                        content: contentValue,
                        priority: priorityPoint,
                        feedback: feedbackValue.isNotEmpty ? feedbackValue : '',
                        // 비어있어도 가능이기에
                        createdAt: DateTime.now().millisecondsSinceEpoch,
                      );

                      await setInsertIdeaInfo(ideaInfo);
                      if (mounted) {
                        Navigator.pop(context);
                      }
                    }
                  }),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> setInsertIdeaInfo(IdeaInfo ideaInfo) async {
    await dbHelper.initDatabase();
    await dbHelper.insertIdeaInfo(ideaInfo);
  }

  void initClickStatus() {
    //클릭 상태를 초기화 해주는 함수(해줘야함)
    isClickPoint1 = false;
    isClickPoint2 = false;
    isClickPoint3 = false;
    isClickPoint4 = false;
    isClickPoint5 = false;
  }
}
