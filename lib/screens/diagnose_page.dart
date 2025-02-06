import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';

Future<Map<String, dynamic>> _sendImageToServer(String imagePath) async {

  //final url = Uri.parse('http://3.143.25.27:5000/process');
  final url = Uri.parse('https://560a-38-9-115-101.ngrok-free.app/process');
  //final url = Uri.parse('http://192.168.2.6:5000/process');
  print(imagePath);
  try {
    print(imagePath);
    print(url.runtimeType);
    final request = http.MultipartRequest('POST', url);
    request.files.add(await http.MultipartFile.fromPath('image', imagePath));

    final response = await http.Response.fromStream(await request.send());
    if (response.statusCode == 400){
      print("ERROR BAD REQUEST");
    }

    if (response.statusCode == 200) {
      print(json.decode(response.body));
      print(response.body);
      return json.decode(response.body);
    }else {
      throw Exception(
          'Erro do servidor: ${response.statusCode} - ${response.reasonPhrase}');
    }

  } catch (e) {

    throw Exception('Erro na conexão: $e');
  }
}

class DiagnosePage extends StatelessWidget {
  final List<File> files;

  DiagnosePage({super.key, required dynamic inputFiles})
      : files = inputFiles is File ? [inputFiles] : List<File>.from(inputFiles);

  Future<Map<String, dynamic>> _processFile(File file) async {
    try {

      final filePath = file.path;
      print("Entrou1");
      if (!filePath.contains('Results')) {
        print("Entra");
        // Se for da pasta Gallery, envia para o servidor
        var data = await _sendImageToServer(filePath);

        final directory = await getApplicationDocumentsDirectory();
        final galleryDir = Directory(directory.path);
        // String nameFile = filePath;
        // Recupera a imagem de 'data' e salva no diretório
        if (data.containsKey('image')) {
          var strName = data['ints'].toString().replaceAll(', ', "_");
          strName = strName.substring(1, strName.length - 1);

          final imageBytes = base64Decode(data['image']);
          final fileName =
              'result_$strName${DateTime.now().millisecondsSinceEpoch}.jpg';

          String filePath = '${galleryDir.path}/Results/$fileName';

          data['title'] = fileName;
          print(filePath);
          final resultsDirectory = Directory('${galleryDir.path}/Results');
          if (!resultsDirectory.existsSync()) {
            resultsDirectory.createSync(recursive: true);
          }

          // Salva a imagem no diretório
          final file = File(filePath);
          await file.writeAsBytes(imageBytes);
        }
        return data;
      } else {

        String nameFile = file.path.split('/').last;


        nameFile = nameFile.substring(7, nameFile.length - 13 - 4).toString();
        List<String> listInt = nameFile.split(r'_');

        return {
          'image': base64Encode(file.readAsBytesSync()),
          'title': file.path.split('/').last,
          'ints': listInt,
        };
      }
    } catch (e) {

      List<String> listInt = ['0','0','0','0','0'];
      print(file.path);
      return {
        'title': file.path.split('/').last,
        'image': base64Encode(file.readAsBytesSync()),
        'ints': listInt,
      };

      throw Exception('Erro ao processar o arquivo: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
         leading: BackButton(),
          title: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Flexible(
                child: Text(
                  "Diagnostico Realizado",
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
              ),
              Image.asset(
                'assets/logo1.png',
                height: 24,
              ),
            ],

          ),

          centerTitle: true,
      ),
      body: PageView.builder(
        itemCount: files.length,
        itemBuilder: (context, index) {
          final file = files[index];
          // final fileName = file.path.split(Platform.pathSeparator).last;

          return FutureBuilder<Map<String, dynamic>>(
            future: _processFile(file),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                // Registrar o erro no console para depuração
                debugPrint('Erro no FutureBuilder: ${snapshot.error}');
                return Center(child: Text('Erro: ${snapshot.error}'));
              } else if (!snapshot.hasData || snapshot.data == null) {
                return const Center(child: Text('Nenhum dado disponível.'));
              }

              // Processar os dados retornados normalmente
              final data = snapshot.data!;
              final returnedImage = base64Decode(data['image']);
              List<String> returnedInts;
              try {
                returnedInts = (data['ints'] as List<dynamic>).cast<String>();
                if (returnedInts.length < 5){
                  returnedInts = ["0","0","0","0","0"];
                }
              } on RangeError catch(e){
                returnedInts = ["0","0","0","0","0"];
              }

              final title = data['title'];

              return FilePageDiagnose(
                returnedImage: returnedImage,
                listStrings: [
                  'Rust',
                  'Miner',
                  "Phoma",
                  'Cercospora',
                  "Região Doente"
                ],
                listInts: returnedInts,
                title: title,
              );
            },
          );
        },
      ),
    );
  }
}

class FilePageDiagnose extends StatelessWidget {
  final String title;
  final List<String> listStrings;
  final List<String> listInts;
  final Uint8List returnedImage;

  const FilePageDiagnose({
    super.key,
    required this.title,
    required this.returnedImage,
    required this.listStrings,
    required this.listInts,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
        padding: const EdgeInsets.all(8.0),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(
            title,
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 3),
          Center(
              child: InteractiveViewer(
            child: Container(
              height: 420,
              width: double.infinity,
              decoration:
                  BoxDecoration(borderRadius: BorderRadius.circular(8.0)),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8.0),
                child: Image.memory(
                  returnedImage,
                  fit: BoxFit.contain,
                ),
              ),
            ),
          )),
          const SizedBox(height: 24),
          Center(
            child: const Text(
              "DIAGNOSTICO",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
          const SizedBox(height: 8),
          Container(
            padding: EdgeInsets.all(16),
            child: Table(
              border: TableBorder.all(color: Colors.black, width: 1),
              children: [
                TableRow(
                  children: [
                    Center(
                        child: Text('Doenças',
                            style: TextStyle(fontWeight: FontWeight.bold))),
                    Center(
                        child: Text('Quantidade',
                            style: TextStyle(fontWeight: FontWeight.bold))),
                  ],
                ),
                TableRow(
                  children: [
                    Center(child: Text(listStrings[0])),
                    Center(child: Text(listInts[0])),
                  ],
                ),
                TableRow(
                  children: [
                    Center(child: Text(listStrings[1])),
                    Center(child: Text(listInts[1])),
                  ],
                ),
                TableRow(
                  children: [
                    Center(child: Text(listStrings[2])),
                    Center(child: Text(listInts[2])),
                  ],
                ),
                TableRow(
                  children: [
                    Center(child: Text(listStrings[3])),
                    Center(child: Text(listInts[3])),
                  ],
                ),
                TableRow(
                  children: [
                    Center(child: Text(listStrings[4])),
                    Center(child: Text(listInts[4])),
                  ],
                ),
              ],
            ),
          ),
          Image.asset('assets/logo1.png')
        ]));
  }
}
