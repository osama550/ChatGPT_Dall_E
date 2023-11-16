import 'package:chat_gpt/component/color/color.dart';
import 'package:chat_gpt/home_screen.dart';
import 'package:chat_gpt/openAI_services.dart';
import 'package:flutter/material.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  OpenAIService.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return  MaterialApp(
      title: 'Chat GPT',
      debugShowCheckedModeBanner: false,
      theme: ThemeData.light(useMaterial3: true).copyWith(
        scaffoldBackgroundColor: colors.whiteColor,
        appBarTheme:const AppBarTheme(
          backgroundColor:colors.whiteColor
        )
      ),
      home: const HomeScreen(),
    );
  }
}

