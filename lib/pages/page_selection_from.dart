// Classe que contem metodos e variaveis que sao utilizados para criacao da
// Tela 2, neste classe o usuario tem opcao de escolher imagens de produtos
// da galeria ou tirar suas proprias imagens que serao armazenadas em um
// vetor para o pos processamento.
import 'package:crdb_v2/models/app_values.dart';
import 'package:crdb_v2/pages/page_images.dart';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:image/image.dart';
import 'dart:io';

class PageSelectionFrom extends StatefulWidget {
  final bool value;
  final String label;
  final AppValues appValues;

  PageSelectionFrom(
      {Key? key,
      required this.value,
      required this.label,
      required this.appValues})
      : super(key: key);

  @override
  _PageSelectionFromState createState() => _PageSelectionFromState();
}

class _PageSelectionFromState extends State<PageSelectionFrom> {
  late Future<File> imageFile;
  final ImagePicker _picker = ImagePicker();
  List<XFile>? _imageFileList = [];
  List<File>? _imageFileListNamed = [];
  late String pathFile;

  _takePictureAndIncrementArray() async {
    XFile? image = await _picker.pickImage(source: ImageSource.camera);
    _imageFileList!.add(image!);
    setState(() {
      _imageFileList;
      saveImagesInMemory();
    });
  }

  void selectImagens() async {
    final List<XFile>? selecetedImages = await _picker.pickMultiImage();
    if (selecetedImages!.isNotEmpty) {
      _imageFileList!.addAll(selecetedImages);
    }
    setState(() {
      _imageFileList;
      saveImagesInMemory();
    });
    print("Image List Lenght: " + _imageFileList!.length.toString());
  }
  @override
  void initState() {
    loadImagesFromMemory();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        appBar: AppBar(
          title: Text('Image Acquisition'),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Card(
                child: ListTile(
                    title: Text(
                  'Escolha as imagens para classe ${widget.appValues.nameLastButtun}',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 20),
                )),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                    side: BorderSide(
                      color: Colors.blue,
                      width: 2.0,
                    )),
                margin: EdgeInsets.fromLTRB(40, 0, 40, 40),
              ),
              _DeFaultAppButtton('Tirar Foto', 'camera'),
              _DeFaultAppButtton('Abrir da galeria', 'gallery'),
              _DeFaultAppButtton('Mostrar classe', 'view'),
            ],
          ),
        ));
  }

  _DeFaultAppButtton(String name_button, String op) {
    return (Card(
      child: ListTile(
          tileColor: Colors.blue,
          hoverColor: Colors.blueAccent,
          onTap: () {
            if (op == 'gallery') {
              selectImagens();
            }
            if (op == 'camera') {
              _takePictureAndIncrementArray();
            }
            if (op == 'view') {
              _popUpViewImages();
            }
          },
          title: Text(
            name_button,
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.white),
          )),
      margin: EdgeInsets.fromLTRB(40, 20, 40, 20),
    ));
  }

  _popUpViewImages() {
    var route = new MaterialPageRoute(
      builder: (BuildContext context) => new PageImagesFromMem(
        listImages: _imageFileListNamed,
        labelName: widget.label,
        model: widget.appValues.usertypeofModel,
        path: pathFile,
      ),
    );
    Navigator.of(context).push(route);
  }

  Future<String> getFilePathAsync() async {
    var appDocumentDirectory = await getExternalStorageDirectory();
    String appDocumentsPath = appDocumentDirectory!.path;
    String filePath = appDocumentsPath +'/train/'+ widget.appValues.label;
    pathFile = filePath;
    return filePath;
  }

  void saveImagesInMemory() async {
    List<File> listimgfiles = XfileToFile(_imageFileList!);
    String filepath = await getFilePathAsync();
    loadImagesFromMemory();
    _createDirectory(filepath);
    print('SALVANDO IMAGEM');
    for (int i=0;i<listimgfiles.length;i++) {
      try {
        var image = decodeImage(listimgfiles.elementAt(i).readAsBytesSync());
        var mImage = copyResize(image!, width: 250, height: 250);
        String imgType = listimgfiles.elementAt(i).path.split('.').last;
        String mPath = '${filepath}/image_${i}.$imgType';
        print('MEU PATH ' + mPath);
        final dFile = File(mPath);
        if (imgType == 'jpg' || imgType == 'jpeg') {
          dFile.writeAsBytesSync(encodeJpg(mImage), mode: FileMode.write);
          setState(() {
            _imageFileListNamed!.add(dFile);
          });
          print('Salvou como jpg');
        } else {
          dFile.writeAsBytesSync(encodePng(mImage), mode: FileMode.write);
          setState(() {
            _imageFileListNamed!.add(dFile);
          });
          print('Salvou como png');
        }
      } on Exception catch (e) {
        print(e.toString());
      }
    }
  }
  void loadImagesFromMemory() async {
    String filepath = await getFilePathAsync();
    print('loadImagesFromMemory() ${filepath}');
    int i =0;
    final imagesDirectory = Directory(filepath).listSync();
    imagesDirectory.forEach((element) {
      i++;
      print('${i} ${element.path}');
      _imageFileList!.add(XFile(element.path));
    });
    setState(() {
      _imageFileList;
    });
  }

  List<File> XfileToFile(List<XFile> adds) {
    List<File> listimgfiles = [];
    for (int i=0;i<adds.length;i++) {
      listimgfiles.add(File(adds.elementAt(i).path));
    }
    return listimgfiles;
  }

  void _createDirectory(String filepath) {
    new Directory(filepath).create(recursive: true)
    // The created directory is returned as a Future.
        .then((Directory directory) {
      print(directory.path);
    });
  }
}
