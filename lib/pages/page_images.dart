import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'dart:io';

class PageImagesFromMem extends StatefulWidget {
  final List<File>? listImages;
  final String labelName;
  final String model;
  final String path;

  // preciso do modelo escolhido object detec ou image classification
  // preciso do nome anotado pelo usuário

  PageImagesFromMem(
      {Key? key,
      required this.listImages,
      required this.labelName,
      required this.model,
      required this.path
      });

  @override
  _PageImagesFromMemState createState() => _PageImagesFromMemState();
}

class _PageImagesFromMemState extends State<PageImagesFromMem> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(widget.labelName),
        ),
        body: SafeArea(
          child: Column(
            children: [
              Expanded(
                child: GridView.builder(
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2),
                    itemCount: widget.listImages!.length,
                    itemBuilder: (BuildContext context, int index) {
                      return Padding(
                        padding: const EdgeInsets.all(2.0),
                        child: Stack(
                          fit: StackFit.expand,
                          children: [
                            Image.file(
                              File(widget.listImages!
                                  .elementAt(index)
                                  .path
                                  .toString()),
                              fit: BoxFit.cover,
                            ),
                            Positioned(
                                right: -4,
                                top: -4,
                                child: Container (
                                  color: Color.fromRGBO(255, 255, 255, 0.7),
                                  child: IconButton(
                                    onPressed: () {
                                      final dFile = Directory(widget.path + '/' + widget.listImages!.elementAt(index).path.split('/').last);
                                      widget.listImages!.removeAt(index);
                                      try{
                                        dFile.deleteSync(recursive: true);
                                      } on Exception catch (e) {
                                        print('Erro ao excluir $e');
                                      }
                                      setState(() {
                                      });
                                    },
                                    icon: Icon(Icons.delete),
                                    color: Colors.red[500],
                                  ),
                                ),
                            ),
                          ],
                        ),
                      );
                    }),
              ),
            ],
          ),
        ),
    );
  }
}
