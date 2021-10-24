import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'package:camera/camera.dart';
import 'package:crdb_v2/models/app_values.dart';
import 'package:crdb_v2/models/filesfolder_model.dart';
import 'package:crdb_v2/models/train_file.dart';
import 'package:crdb_v2/pages/page_selection_from.dart';
import 'package:crdb_v2/values/preferences_keys.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PageFolderClass extends StatefulWidget {
  final String folder_title;
  final String folder_subtitle;
  late bool create_folder;
  final AppValues appValues;

  PageFolderClass({
    Key? key,
    required this.folder_title,
    required this.folder_subtitle,
    required this.create_folder,
    required this.appValues,
  });

  @override
  _PageFolderClassState createState() => _PageFolderClassState();
}

class _PageFolderClassState extends State<PageFolderClass> {
  late TrainFile mTrainFile;
  List<String> _imageFileList = [];

  @override
  void initState() {
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        appBar: AppBar(
          title: Text('Classes'),
        ),
        body: new FutureBuilder<ListFolder?>(
          future: _listOfFolder(widget.folder_title, widget.folder_subtitle,
              widget.create_folder),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return _FolderWidget(snapshot);
            } else if (snapshot.hasError) {
              return Center(
                  child: Text('Ocorreu um erro: ${snapshot.error.toString()}'));
            } else {
              return Center(
                child: waitFolderCreate(snapshot),
              );
            }
          },
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () => saveClassesAndImages(),
          child: Icon(
            Icons.save,
          ),
        ));
  }

  Future<ListFolder?> _listOfFolder(
      String folder_title, String folder_subtitle, bool create) async {
    print('_listOfFolder()');

    if (create) {
      _createFolder(folder_title, folder_subtitle);
      widget.create_folder = false;
    }
    var listFoldersPreferences = await _LoadFolder();

    return listFoldersPreferences;
  }

  void _saveFolder(ListFolder folders) async {
    print('_saveFolder()');
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString(PreferencesKeys.preferedFolder, json.encode(folders));
  }

  Future<ListFolder?> _LoadFolder() async {
    print('_LoadFolder()');
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? jsonDataList = prefs.getString(PreferencesKeys.preferedFolder);
    if (jsonDataList != null) {
      Map<String, dynamic> mapDataList = json.decode(jsonDataList);
      ListFolder listFolder = ListFolder.fromJson(mapDataList);
      return listFolder;
    }
    return null;
  }

  void _createFolder(String folder_title, String folder_subtitle) async {
    print('_createFolder()');
    List<Folder> list = [];
    Folder newFolder = Folder(
      title: folder_title,
      subtitle: folder_subtitle,
      qntd: 0,
      uri: '/android/',
    );

    var newListFolder = await _LoadFolder();
    if (newListFolder == null) {
      list.add(newFolder);
      var listfoldernew = ListFolder(folder: list);
      _saveFolder(listfoldernew);
    }
    newListFolder!.folder.add(newFolder);
    _saveFolder(newListFolder);
    setState(() {});
  }

  Widget _FolderWidget(AsyncSnapshot<ListFolder?> listFoldersPreferences) {
    print('TESTE: ${widget.appValues.label}');
    return Column(
      children: [
        Expanded(
          child: SizedBox(
            height: 200.0,
            child: new ListView.builder(
              itemCount: listFoldersPreferences.data!.folder.length,
              itemBuilder: (context, int index) {
                return Container(
                  padding: EdgeInsets.fromLTRB(0, 0, 0, 1.5),
                  child: ListTile(
                    title: Text(
                      listFoldersPreferences.data!.folder
                          .elementAt(index)
                          .title,
                      style: TextStyle(color: Colors.white),
                    ),
                    subtitle: Text(
                      listFoldersPreferences.data!.folder
                          .elementAt(index)
                          .subtitle,
                      style: TextStyle(color: Colors.white),
                    ),
                    leading: Icon(
                      Icons.folder,
                      color: Colors.orange[200],
                      size: 60,
                    ),
                    tileColor: Colors.blueAccent,
                    onTap: () async {
                      var appValuesVar = AppValues();
                      appValuesVar.label = listFoldersPreferences.data!.folder
                          .elementAt(index)
                          .title;
                      appValuesVar.brand = listFoldersPreferences.data!.folder
                          .elementAt(index)
                          .subtitle;
                      appValuesVar.usertypeofModel =
                          widget.appValues.usertypeofModel;
                      appValuesVar.nameLastButtun = listFoldersPreferences
                          .data!.folder
                          .elementAt(index)
                          .title;

                      print('nameLastButtun ${appValuesVar.nameLastButtun}');
                      var route = new MaterialPageRoute(
                        builder: (BuildContext context) =>
                            new PageSelectionFrom(
                          value: true,
                          label: listFoldersPreferences.data!.folder
                              .elementAt(index)
                              .title,
                          appValues: appValuesVar,
                        ),
                      );
                      Navigator.of(context).push(route);
                    },
                  ),
                );
              },
            ),
          ),
        ),
      ],
    );
  }

  waitFolderCreate(AsyncSnapshot<ListFolder?> snapshot) {
    if (!snapshot.hasData) {
      return CircularProgressIndicator();
    }
  }

  void saveClassesAndImages() async {
    print('Arquivos salvos ');
    try {
      var appDocumentDirectory = await getExternalStorageDirectory();
      if (appDocumentDirectory != null) {
        File filetrain = File(appDocumentDirectory.path + '/train.txt');
        File filelabels = File(appDocumentDirectory.path + '/labels.txt');
        print('Diretorio ' + appDocumentDirectory.path);
        ListFolder? list = await _LoadFolder();
        String train_string = '';
        String labels_string = '';
        for (int i = 0; i < list!.folder.length; i++) {
          print('SIZE ${list.folder.length}');
          loadImagesFromMemory(list.folder.elementAt(i).title);
          labels_string = labels_string + list.folder.elementAt(i).title + '\n';
        }
        _imageFileList.forEach((path) {
          train_string = train_string + '/' + path + '\n';
        });
        filetrain.writeAsString(train_string);
        filelabels.writeAsString(labels_string);
      }
    } on Exception catch (e) {
      print('Não foi possivel salvar');
    }
  }

  void loadImagesFromMemory(String label) async {
    String filepath = await getFilePathAsync(label);
    int i = 0;
    final imagesDirectory = Directory(filepath).listSync();
    imagesDirectory.forEach((element) {
      _imageFileList.add(element.path);
    });
    setState(() {
      _imageFileList;
    });
  }

  Future<String> getFilePathAsync(String label) async {
    var appDocumentDirectory = await getExternalStorageDirectory();
    String appDocumentsPath = appDocumentDirectory!.path;
    String filePath = appDocumentsPath + '/train/' + label;

    return filePath;
  }

  // List<String> createStringListClasses() {
  //   // List<String> list = [];
  //   // for (int i = 0; i < _imageFileList.length; i++) {
  //   //   list.add(_imageFileList.elementAt(i).path.split('/').last);
  //   // }
  //   return ;
  // }

  int getMyRand(int length, int i) {
    Set<int> setOfInts = Set();
    setOfInts.add(Random().nextInt(length));
    return setOfInts.elementAt(0);
  }
}
