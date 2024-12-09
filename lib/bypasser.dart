import 'package:dio/dio.dart';
import 'infinitybypasser.dart';

final InfinityfreeBypasser bypasser = InfinityfreeBypasser();
final Dio dio = Dio();

Future<String?> bypassRequest(String url) async {
  // Calculate the bypass cookie
  await bypasser.bypass(url);

  if (bypasser.cookie != null) {
    try {
      // Make the request with the cookie
      final response = await dio.get(
        url,
        options: Options(
          headers: {
            'Cookie': bypasser.cookie,
          },
          responseType: ResponseType.plain,
        ),
      );
      return response.data; // Return the response data
    } catch (e) {
      return null; // Return null in case of an error
    }
  } else {
    return null; // Return null if bypass fails
  }
}
