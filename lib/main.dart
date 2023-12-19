import 'package:archive_idea_flutter/data/idea_info.dart';
import 'package:archive_idea_flutter/screen/edit_screen.dart';
import 'package:archive_idea_flutter/screen/main_screen.dart';
import 'package:archive_idea_flutter/screen/splash_screen.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Archive Idea App',
      debugShowCheckedModeBanner: false,
        initialRoute: '/',
        routes: {
          '/': (context) => SplashScreen(),
          '/main': (context) => MainScreen(),
        },
      onGenerateRoute:(settings){
        if(settings.name=='/edit'){
          //1.아이디어 기록 값을 넘기지 못한다면: 작성 시나리오

          //2.아이디어 기록 값을 넘긴다면: 수정 시나리오
          final IdeaInfo? ideaInfo=settings.arguments as IdeaInfo?;
          return MaterialPageRoute(builder: (context){
            return EditScreen(ideaInfo: ideaInfo,);
          },);
        }
      },);
  }
}
