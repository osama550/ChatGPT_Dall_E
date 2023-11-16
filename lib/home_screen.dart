import 'package:animate_do/animate_do.dart';
import 'package:chat_gpt/component/color/color.dart';
import 'package:chat_gpt/component/component/component.dart';
import 'package:chat_gpt/openAI_services.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:speech_to_text/speech_recognition_result.dart';
import 'package:speech_to_text/speech_to_text.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final speechToText = SpeechToText();
  final OpenAIService openAIService = OpenAIService();
  String lastWords = '';
  final flutterTts=FlutterTts();
  String? generatedImageUrl;
  String? generatedContent;
  int start = 200;
  int delay = 200;



  @override

  void initState() {
    super.initState();
    initSpeechToText();
   initTextToSpeech();
  }
  Future<void> initTextToSpeech() async {
    await flutterTts.setSharedInstance(true);
    setState(() {});
  }

  Future<void> initSpeechToText() async {
    await speechToText.initialize();
    setState(() {});
  }

  Future<void> startListening() async {
    await speechToText.listen(onResult: onSpeechResult);
    setState(() {});
  }

  Future<void> stopListening() async {
    await speechToText.stop();
    setState(() {});
  }

  void onSpeechResult(SpeechRecognitionResult result) {
    setState(() {
      lastWords = result.recognizedWords;
      print(lastWords);
    });
  }
Future<void>systemSpeak(String content) async{
   await flutterTts.speak(content);
}

  @override
  void dispose() {
    super.dispose();
    speechToText.stop();
    flutterTts.stop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: color.whiteColor,
      appBar: AppBar(
        // backgroundColor: color.whiteColor,
        leading: const Icon(
          Icons.menu,
          // color: color.blackColor
        ),
        title: BounceInDown(
          child: const Text(
            "Osama",
            // style: TextStyle(color: color.blackColor)
          ),
        ),
        centerTitle: true,
        //  elevation: 0,
      ),
      body: SingleChildScrollView(
        physics:  const BouncingScrollPhysics(),
        child: Column(
          children: [
            ZoomIn(
              child: Stack(
                children: [
                  Center(
                    child: Container(
                      height: 120,
                      width: 120,
                      margin: const EdgeInsets.only(top: 4),
                      decoration: const BoxDecoration(
                          color: colors.assistantCircleColor,
                          shape: BoxShape.circle),
                    ),
                  ),
                  Container(
                    height: 123,
                    decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        image: DecorationImage(
                          image: AssetImage('assets/images/virtualAssistant.png'),
                        )),
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 30,
            ),
            FadeInRight(
              child: Visibility(
                visible:generatedImageUrl==null,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    vertical: 10,
                    horizontal: 20,
                  ),
                  margin: const EdgeInsets.symmetric(horizontal: 35),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20).copyWith(
                        topLeft: Radius.zero,
                      ),
                      color: colors.borderColor),
                  child:  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10.0),
                    child:  Text(
                      generatedContent==null? 'Good Morning, what task can i do for you':generatedContent!,
                      style: TextStyle(
                        fontFamily: 'Cera Pro',
                        color: colors.mainFontColor,
                        fontSize:generatedContent==null? 25:18,
                      ),
                    ),
                  ),
                ),
              ),
            ),
            if(generatedImageUrl!=null) Padding(
              padding: const EdgeInsets.all(12.0),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                  child: Image.network(generatedImageUrl!)),
            ),
            SlideInLeft(
              child: Visibility(
                visible: generatedContent==null&&generatedImageUrl==null,
                child: Container(
                  padding: const EdgeInsets.all(10),
                  alignment: Alignment.centerLeft,
                  margin: const EdgeInsets.only(top: 10, left: 22),
                  child: const Text(
                    "Here are a few features",
                    style: TextStyle(
                      color: colors.mainFontColor,
                      fontFamily: 'Cera Pro',
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
            Visibility(
              visible: generatedContent==null&&generatedImageUrl==null,
              child: Column(
                children: [
                  SlideInLeft(
                    delay: Duration(milliseconds: start),
                    child: defaultFeatures(
                        color: colors.firstSuggestionBoxColor,
                        headText: 'ChatGPT',
                        text:
                            'A smarter way to stay organized and informed with ChatGPT'),
                  ),
                  SlideInLeft(
                    delay: Duration(milliseconds: start + delay),
                    child: defaultFeatures(
                        color: colors.secondSuggestionBoxColor,
                        headText: 'Dall-E',
                        text:
                            'Get inspired and stay creative with your personal assistant powered by Dall-E'),
                  ),
                  SlideInLeft(
                    delay: Duration(milliseconds: start + 2 * delay),
                    child: defaultFeatures(
                        color: colors.thirdSuggestionBoxColor,
                        headText: 'Smart Voice Assistant',
                        text:
                            'Get the best of both worlds with a voice assistant powered by Dall-E and ChatGPT'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: ZoomIn(
        delay: Duration(milliseconds: start + 3 * delay),
        child: FloatingActionButton(
          onPressed: () async {
            if (await speechToText.hasPermission && speechToText.isNotListening) {
              await startListening();
            } else if (speechToText.isListening) {
              final speech = await openAIService.isArtPromptAPI(lastWords);
              if (speech.contains('https')) {
                generatedImageUrl = speech;
                generatedContent = null;
                setState(() {});
              } else {
                generatedImageUrl = null;
                generatedContent = speech;
                setState(() {});
                await systemSpeak(speech);
              }
              await stopListening();
            } else {
              initSpeechToText();
            }
          },
          backgroundColor: colors.firstSuggestionBoxColor,
          child:  Icon(
            speechToText.isListening ? Icons.stop : Icons.mic,
        ),
        ),
      ),
    );
  }
}
