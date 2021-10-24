// Classe que contem metodos e veriaveis que sao utilizados para criacao da
// Tela 1, que representa a selecao do tipo de modelo que o user usara
// Opcao 1: Classificacao de imagem Opcao 2: Deteccao de objetos

import 'package:crdb_v2/pages/labelling.dart';
import 'package:flutter/material.dart';
import 'package:crdb_v2/pages/page_selection_from.dart';

class PageSelectionModel extends StatefulWidget {
  @override
  _PageSelectionModel createState() => _PageSelectionModel();
}

class _PageSelectionModel extends State<PageSelectionModel> {
  bool _opcao = true;

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        appBar: AppBar(
          title: Text('Custom Reatil Dataset Builder'),
          centerTitle: true,
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Card(
                child: ListTile(
                    title: Image(image: AssetImage('assets/images/logo.png'))),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                    side: BorderSide(
                      color: Colors.blue,
                      width: 2.0,
                    )),
                margin: EdgeInsets.fromLTRB(40, 0, 40, 40),
              ),
              _DeFaultAppButtton('Reconhecimento de produtos'),
              _DeFaultAppButtton('Detecção de produtos'),
            ],
          ),
        ));
  }

  _DeFaultAppButtton(String name_button) {
    return (Card(
      child: ListTile(
          tileColor: Colors.blue,
          hoverColor: Colors.blueAccent,
          onTap: () {
            _opcao = true;

            var route = new MaterialPageRoute(
              builder: (BuildContext context) =>
                  new Labelling(type_ofModel: name_button,),
            );
            Navigator.of(context).push(route);
          },
          title: Text(
            name_button,
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.white),
          )),
      margin: EdgeInsets.fromLTRB(40, 20, 40, 20),
    ));
  }
}
