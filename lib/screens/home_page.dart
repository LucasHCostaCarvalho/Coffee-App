import 'package:flutter/material.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:widgets_screens/screens/diagnose_page.dart';

// import 'package:widgets_screens/screens/image_process_screen.dart';
import 'package:widgets_screens/widgets/bottomAppBar.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class CardsDiagnose extends StatefulWidget {
  const CardsDiagnose({
    super.key,
    required this.imageFile,
    required this.title,
    required this.listAmountDiagnose,
    this.shape,
    required this.diseases,
    required this.onDelete,
  });

  static const double maxWidth = 640;
  static const double height = 200;
  final File imageFile;
  final ShapeBorder? shape;
  final List<String> listAmountDiagnose;
  final String title;
  final List<String> diseases;
  final VoidCallback onDelete;

  @override
  State<CardsDiagnose> createState() => _CardsDiagnoseState();
}

class _CardsDiagnoseState extends State<CardsDiagnose> {
  @override
  Widget build(BuildContext context) {
    String diseasesAmount;
    try {
      diseasesAmount = widget.listAmountDiagnose
          .asMap()
          .entries
          .where((entry) => (int.parse(entry.value) > 0))
          .map((entry) => "${widget.diseases[entry.key]}:${entry.value}")
          .join(', ');
    } catch(e) {
      diseasesAmount = '';
    }
    if (widget.listAmountDiagnose.length < 5) {
      widget.listAmountDiagnose.add('0');
    }

    return SafeArea(
      top: false,
      bottom: false,
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: CardsDiagnose.maxWidth),
          child: Padding(
            padding: const EdgeInsets.all(1.0),
            child: Semantics(
              label: "CardDiagnose",
              child: SizedBox(
                height: CardsDiagnose.height,
                child: Card(
                  clipBehavior: Clip.antiAlias,
                  shape: widget.shape ??
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                  child: InkWell(
                    onTap: () {
                      // Lógica ao clicar no card
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) =>
                              DiagnosePage(inputFiles: widget.imageFile)));
                    },
                    splashColor: Theme.of(context)
                        .colorScheme
                        .onSurface
                        .withOpacity(0.12),
                    highlightColor: Colors.transparent,
                    child: Stack(
                      children: [
                        // Imagem de fundo
                        Image.file(
                          widget.imageFile,
                          fit: BoxFit.cover,
                          width: double.infinity,
                          height: double.infinity,
                        ),
                        // Fundo semitransparente com o título
                        Align(
                          alignment: Alignment.bottomCenter,
                          child: Container(
                            height: CardsDiagnose.height * 0.4,
                            width: double.infinity,
                            color: Colors.black.withOpacity(0.5),
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              children: [
                                Center(
                                  child: Text(
                                    widget.title,
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                                Center(
                                  child: Text(
                                    diseasesAmount,
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Positioned(
                          top: 8.0,
                          right: 8.0,
                          child: IconButton(
                            onPressed: () {
                              showDialog(
                                context: context,
                                builder: (context) {
                                  return AlertDialog(
                                    title: const Text('Confirmação'),
                                    content: const Text(
                                        'Você tem certeza que deseja deletar a imagem selecionada?'),
                                    actions: [
                                      TextButton(
                                        onPressed: () => Navigator.pop(context),
                                        child: const Text('Cancelar'),
                                      ),
                                      TextButton(
                                        onPressed: () {
                                          widget.imageFile.deleteSync();
                                          widget.onDelete();
                                          Navigator.pop(context);
                                        },
                                        child: const Text('Deletar'),
                                      ),
                                    ],
                                  );
                                },
                              );
                            },
                            icon: const Icon(Icons.delete),
                            color: Colors.red,
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _HomePageState extends State<HomePage> {
  final List<File> _images = [];
  final _picker = ImagePicker();
  late Directory _imageDirectoryHomePage;

  @override
  void initState() {
    super.initState();
    _initializeGalleryDirectory();
  }

  Future<void> _initializeGalleryDirectory() async {
    try {
      final directory = await getApplicationDocumentsDirectory();
      final galleryDir = Directory('${directory.path}/Results');
      if (!await galleryDir.exists()) {
        await galleryDir.create(recursive: true);
      }
      setState(() {
        _imageDirectoryHomePage = galleryDir;
      });
      await _loadImages();
    } catch (e) {
      debugPrint('Erro ao inicializar o diretório da galeria: $e');
    }
  }

  Future<void> _loadImages() async {
    try {
      // Lista todos os arquivos no diretório
      final images = _imageDirectoryHomePage
          .listSync()
          .where((file) =>
              file is File)
          .map((file) => File(file.path))
          .toList();

      images.sort((a, b) => b.lastModifiedSync().compareTo(a.lastModifiedSync()));

      setState(() {
        _images.clear();
        _images.addAll(images.take(100));
      });
    } catch (e) {
      debugPrint('Erro ao carregar imagens: $e');
    }
  }


  Future<void> _pickImage(ImageSource source) async {
    try {
      final pickedFile = await _picker.pickImage(source: source, maxHeight: 640, maxWidth: 640);
      if (pickedFile != null) {
        final directory = await getApplicationDocumentsDirectory();
        final galleryDir = Directory('${directory.path}/Gallery');

        final nameImage = '${DateTime.now().millisecondsSinceEpoch}';

        final newImage = File(pickedFile.path.toString());
        final targetPath = '${galleryDir.path}' + '/' +'${newImage.toString().split(r'/').last}';
        // assert(targetPath == newImage);
        // print(targetPath);
        // print('DIRETORIO ESPERADO: /data/user/0/com.example.coffeeapp/app_flutter/Gallery');
        // print(pickedFile.path.toString());
        // print(galleryDir.path.toString());
        final savedImage = await newImage.copy(targetPath);

        await Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => DiagnosePage(inputFiles: newImage)));

      }
      } catch (e) {
      debugPrint('Erro ao capturar imagem: $e');
    }
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(
          child: Column(
            children: [
              Text(
                "Tela Inicial",
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              Image.asset('assets/logo1.png', height: 24,)
            ],
          ),
        ),
      ),
      body: _images.isNotEmpty
          ? ListView.separated(
              padding: const EdgeInsets.all(8.0),
              itemCount: _images.length,
              separatorBuilder: (context, index) => const SizedBox(height: 3),
              itemBuilder: (context, index) {
                final image = _images[index];
                // Logia para retirar os inteiros
                String nameFile = image.path.split('/').last;
                List<String> listInt;

                if (image.path.contains("Results")) {
                  print("Entrou");
                  try {
                    listInt =nameFile
                        .substring(7, nameFile.length -
                        13 - 4)
                        .toString()
                        .split(r'_');
                  } catch(e){
                    listInt =['0','0','0','0','0'];
                  }}else {
                  listInt =[
                    '0', '0', '0', '0', '0'];
                }

                // return CardsDiagnose(
                //     imageFile: image,
                //     title: "Diagnostico ${index + 1}",
                //     listAmountDiagnose: listInt,
                // diseases: [
                //   'Rust',
                //   'Miner',
                //   'Phoma',
                //   'Cercospora',
                //   'Região Doente'
                return CardsDiagnose(
                  imageFile: image,
                  title: "Diagnóstico ${index + 1}",
                  listAmountDiagnose: listInt,
                  diseases: [
                    'Rust',
                    'Miner',
                    'Phoma',
                    'Cercospora',
                    'Região Doente'
                  ],
                  onDelete: () {
                    setState(() {
                      // Atualize a lista de imagens no widget pai
                      _images.removeAt(index);
                    });
                  },
                );

                // ],);
              },
            )
          : const Center(
              child: Text(
                'Faça o envio de imagens para que sejam apresentados os últimos resultados das folhas diagnosticadas!',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16),
              ),
            ),
      bottomNavigationBar: BottomAppBarCoffeApp(),
      floatingActionButton: ElevatedButton(
        onPressed: () {
          _pickImage(ImageSource.camera);
        },
        child: Icon(Icons.camera),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }
}
