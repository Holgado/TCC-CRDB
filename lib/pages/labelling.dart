import 'package:crdb_v2/models/app_values.dart';
import 'package:crdb_v2/pages/page_folder_class.dart';
import 'package:crdb_v2/pages/page_selection_from.dart';
import 'package:flutter/material.dart';

class Labelling extends StatefulWidget {
  final String type_ofModel;

  Labelling({Key? key, required this.type_ofModel});

  @override
  _LabellingState createState() => _LabellingState();
}

class _LabellingState extends State<Labelling> {
  final TextEditingController _tag_nameController = TextEditingController();
  final TextEditingController _brand_nameController = TextEditingController();
  late AppValues _appValues;

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: AppBar(
        title: Text('Labelling'),
      ),
      body: new Column(children: <Widget>[
        _TextField('Nome da tag', 'Nome do produto', _tag_nameController),
        _TextField('Nome da marca', 'Nome da marca', _brand_nameController),
        _DeFaultAppButtton(
            'Confirmar', true, _tag_nameController, _brand_nameController),
        _DeFaultAppButtton(
            'Pular', false, _tag_nameController, _brand_nameController)
      ]),
    );
  }

  _TextField(
      String txt_label, String txt_hint, TextEditingController controller) {
    return (new Flexible(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(10, 10, 20, 10),
        child: TextField(
          style: TextStyle(fontSize: 16.0),
          decoration: InputDecoration(
            labelText: txt_label,
            hintText: txt_hint,
            filled: false,
          ),
          keyboardType: TextInputType.text,
          controller: controller,
        ),
      ),
    ));
  }

  _DeFaultAppButtton(String name_button, bool create,
      TextEditingController cll_title, TextEditingController cll_subtitle) {
    return (Card(
      child: ListTile(
          tileColor: Colors.blue,
          hoverColor: Colors.blueAccent,
          onTap: () {
            var route;
            _appValues = AppValues.att(
                widget.type_ofModel, cll_title.text, cll_subtitle.text, '');
            if (create) {
              route = new MaterialPageRoute(
                builder: (BuildContext context) => new PageFolderClass(
                  folder_title: cll_title.text,
                  folder_subtitle: cll_subtitle.text,
                  create_folder: create,
                  appValues: _appValues,
                ),
              );
            } else {
              route = new MaterialPageRoute(
                builder: (BuildContext context) => new PageFolderClass(
                  folder_title: cll_title.text,
                  folder_subtitle: cll_subtitle.text,
                  create_folder: create,
                  appValues: _appValues,
                ),
              );
            }

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
