import 'package:flutter/material.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:widgets_screens/widgets/bottomAppBar.dart';

import 'diagnose_page.dart';

class GalleryScreen extends StatefulWidget {
  const GalleryScreen({super.key});

  @override
  State<GalleryScreen> createState() => _GalleryScreenState();
}

class _GalleryScreenState extends State<GalleryScreen> {
  final List<File> _images = [];
  final List<File> _selectedImages = [];
  late Directory _imageDirectory;
  final _picker = ImagePicker();
  bool _isSelecting = false;

  @override
  void initState() {
    super.initState();
    _initializeGalleryDirectory();
  }

  Future<void> _pickImage(ImageSource source) async {
    final pickedFile = await _picker.pickImage(source: source);
    if (pickedFile != null) {
      final newImage = File(pickedFile.path);
      final targetPath =
          '${_imageDirectory.path}/${DateTime.now().millisecondsSinceEpoch}.jpg';

      print(targetPath);
      final savedImage = await newImage.copy(targetPath);
      setState(() {
        _images.add(File(pickedFile.path));
      });
    }
  }

  Future<void> _initializeGalleryDirectory() async {
    try {
      final directory = await getApplicationDocumentsDirectory();
      final galleryDir = Directory('${directory.path}/Gallery');
      if (!await galleryDir.exists()) {
        await galleryDir.create(recursive: true);
      }
      // print("ASASDLAS<DL<ASLD<LASD<LAS<DLASD<AL $galleryDir");
      setState(() {
        _imageDirectory = galleryDir;
      });
      await _loadImages();
    } catch (e) {
      debugPrint('Erro ao inicializar o diretório da galeria: $e');
    }
  }

  Future<void> _loadImages() async {
    try {
      print("IMAGEM AMSDAS DM AS DIRetoriO $_imageDirectory");
      final images = _imageDirectory.listSync().where((file) => file is File).map((file) => File(file.path)).toList(); //&&
              //(file.path.endsWith('.jpg') || file.path.endsWith('.png')))
          //.map((file) => File(file.path))
          //.toList();
      setState(() {
        _images.clear();
        _images.addAll(images);
      });
    } catch (e) {
      debugPrint('Erro ao carregar imagens: $e');
    }
  }

  Future<void> _importImages() async {
    final picker = ImagePicker();
    final pickedImages = await picker.pickMultiImage();

    for (var pickedImage in pickedImages) {
      final file = File(pickedImage.path);
      final newFile = await file.copy(
        '${_imageDirectory.path}/${DateTime.now().millisecondsSinceEpoch}.jpg',
      );
      setState(() {
        _images.add(newFile);
      });
    }
  }

  void _deleteSelectedImages() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Confirmação'),
          content: const Text(
              'Você tem certeza que deseja deletar as imagens selecionadas?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancelar'),
            ),
            TextButton(
              onPressed: () {
                for (var image in _selectedImages) {
                  image.deleteSync();
                  setState(() {
                    _images.remove(image);
                  });
                }
                setState(() {
                  _selectedImages.clear();
                });
                Navigator.pop(context);
              },
              child: const Text('Deletar'),
            ),
          ],
        );
      },
    );
  }

  void _expandImage(BuildContext context, int initialIndex) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent, // Fundo transparente
      builder: (_) {
        return GestureDetector(
          onTap: () {
            Navigator.pop(context);
          },
          child: Container(
            color: Colors.black.withOpacity(0.5), // Fundo escurecido
            child: Column(
              children: [
                Expanded(
                  child: PageView.builder(
                    controller: PageController(initialPage: initialIndex),
                    itemCount: _images.length,
                    itemBuilder: (context, index) {
                      final image = _images[index];
                      return GestureDetector(
                        onTap: () {},
                        // Impede propagação para fechar ao tocar na imagem
                        child: Image.file(
                          image,
                          fit: BoxFit.contain,
                        ),
                      );
                    },
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: const Text("Voltar")),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context);
                        setState(() {
                          _images.removeAt(initialIndex);
                        });
                      },
                      child: const Text('Deletar'),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context);
                        // _sendImage(_images[initialIndex]);
                        _sendSelectedImages(context, _images, initialIndex);
                      },
                      child: const Text('Diagnosticar'),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
              ],
            ),
          ),
        );
      },
    );
  }

  void _sendSelectedImages(BuildContext context, List<File> images,
      [int? index]) {
    if (index != null) {
      Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => DiagnosePage(
                inputFiles: images[index],
              )));
    } else {
      Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => DiagnosePage(
                inputFiles: images,
              )));
    }
  }

  void _toggleSelection(File image) {
    setState(() {
      if (_selectedImages.contains(image)) {
        _selectedImages.remove(image);
        if (_selectedImages.isEmpty) {
          _isSelecting = false;
        }
      } else {
        _selectedImages.add(image);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(
          child: Column(
            children: [
              Text(
                "Galeria",
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
      body: Column(
        children: [
          // Botões de ação no topo
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: _importImages,
                  child: const Text('Importar'),
                ),
                ElevatedButton(
                  onPressed:
                      _selectedImages.isEmpty ? null : _deleteSelectedImages,
                  child: const Text('Deletar'),
                ),
                ElevatedButton(
                  onPressed: _selectedImages.isEmpty
                      ? null
                      : () => _sendSelectedImages(context, _selectedImages),
                  child: const Text('Diagnosticar'),
                ),
              ],
            ),
          ),
          // Espaço restante para o GridView
          Expanded(
            child: GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                crossAxisSpacing: 1.0,
                mainAxisSpacing: 1.0,
              ),
              itemCount: _images.length,
              itemBuilder: (context, index) {
                final image = _images[index];
                final isSelected = _selectedImages.contains(image);
                return GestureDetector(
                  onTap: () {
                    if (_isSelecting) {
                      _toggleSelection(image);
                    } else {
                      _expandImage(context, index);
                    }
                  },
                  onLongPress: () {
                    setState(() {
                      _isSelecting = true;
                      _toggleSelection(image);
                    });
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: isSelected ? Colors.blue : Colors.transparent,
                        width: 2,
                      ),
                    ),
                    child: Stack(
                      alignment: Alignment.center, // Centraliza a imagem
                      children: [
                        Center(
                          child: Image.file(
                            image,
                            fit: BoxFit.contain, // Garante proporção da imagem
                          ),
                        ),
                        if (isSelected)
                          Container(
                            color: Colors.black.withOpacity(0.5),
                            child: const Icon(Icons.check, color: Colors.white),
                          ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomAppBarCoffeApp(),
      floatingActionButton: ElevatedButton(
          onPressed: () => _pickImage(ImageSource.camera),
          child: Icon(Icons.camera)),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }
}
