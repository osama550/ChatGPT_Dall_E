import 'package:chat_gpt/component/component/constant.dart';
import 'package:dio/dio.dart';

class OpenAIService {
  final List<Map<String, String>> messages = [];
   static Dio? dio;

  static init() {
    dio = Dio(
      BaseOptions(
        baseUrl: 'https://api.openai.com/v1/',
        receiveDataWhenStatusError: true,
      ),
    );
  }


  Future<String> isArtPromptAPI(String prompt) async {
    print('The First Line In Api Function Here...');
    try {
      final response = await dio!.post(
        'chat/completions',
        data: {
          "model": "gpt-3.5-turbo",
          "messages": [
            {
              'role': 'user',
              'content': prompt,
                  // 'Does this message want to generate an AI picture, image, art or anything similar? $prompt . Simply answer with a yes or no.',
            }
          ],
        },
        options: Options(
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $keyApi',
          },
        ),
      );

      print('-----------------------------------------------------------');
      print(response.data);
      print('-----------------------------------------------------------');

      if (response.statusCode == 200) {
        String content = response.data['choices'][0]['message']['content'];
        content = content.trim();

        switch (content) {
          case 'Yes':
          case 'yes':
          case 'Yes.':
          case 'yes.':
            final res = await dallEAPI(prompt);
            return res;
          default:
            final res = await chatGPTAPI(prompt);
            return res;
        }
      }
      return 'An internal error occurred';
    } catch (e) {
      print('Error When Try To Get Answer From API =========> ${e.toString()}');
      return e.toString();
    }
  }

  Future<String> chatGPTAPI(String prompt) async {
    messages.add({
      'role': 'user',
      'content': prompt,
    });

    try {
      final response = await dio!.post(
        'chat/completions',
        data: {
          "model": "gpt-3.5-turbo",
          "messages": messages,
        },
        options: Options(
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $keyApi',
          },
        ),
      );

      if (response.statusCode == 200) {
        String content = response.data['choices'][0]['message']['content'];
        content = content.trim();

        messages.add({
          'role': 'assistant',
          'content': content,
        });
        return content;
      }
      return 'An internal error occurred';
    } catch (e) {
      return e.toString();
    }
  }

  Future<String> dallEAPI(String prompt) async {
    messages.add({
      'role': 'user',
      'content': prompt,
    });

    try {
      final response = await dio!.post(
        'images/generations',
        data: {
          'prompt': prompt,
          'n': 1,
        },
        options: Options(
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $keyApi',
          },
        ),
      );

      if (response.statusCode == 200) {
        String imageUrl = response.data['data'][0]['url'];
        imageUrl = imageUrl.trim();

        messages.add({
          'role': 'assistant',
          'content': imageUrl,
        });
        return imageUrl;
      }
      return 'An internal error occurred';
    } catch (e) {
      return e.toString();
    }
  }
}
