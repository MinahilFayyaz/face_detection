import 'package:http/http.dart' as http;

class ApiClient {

  static const apiKey = "1HCbPyVi2jtqMG8o2tpxAgr6";
  static var baseUrl = Uri.parse("https://api.remove.bg/v1.0/removebg");

  static removebg(String imgPath) async{

    var request = http.MultipartRequest("POST", baseUrl);
    request.headers.addAll({"X-API-Key": apiKey});
    request.files.add(await http.MultipartFile.fromPath("image_file", imgPath));
    final response = await request.send();
    if (response.statusCode == 200) {
      http.Response img = await http.Response.fromStream(response);
      return img.bodyBytes;
    } else {
      throw Exception("Error occurred with response ${response.statusCode}");
    }
  }
}

