class ListFolder {
  List<Folder> _folder = [];

  ListFolder({required List<Folder> folder}) {
    this._folder = folder;
  }

  List<Folder> get folder => _folder;
  set folder(List<Folder> folder) => _folder = folder;

  ListFolder.fromJson(Map<String, dynamic> json) {
    if (json['Folder'] != null) {
      json['Folder'].forEach((v) {
        _folder.add(new Folder.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this._folder != null) {
      data['Folder'] = this._folder.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Folder {
  String _title = '';
  String _subtitle = '';
  String _uri = '';
  int _qntd = 0;

  Folder({required String title, required String subtitle, required String uri, required int qntd}) {
    this._title = title;
    this._subtitle = subtitle;
    this._uri = uri;
    this._qntd = qntd;
  }

  String get title => _title;
  set title(String title) => _title = title;
  String get subtitle => _subtitle;
  set subtitle(String subtitle) => _subtitle = subtitle;
  String get uri => _uri;
  set uri(String uri) => _uri = uri;
  int get qntd => _qntd;
  set qntd(int qntd) => _qntd = qntd;

  Folder.fromJson(Map<String, dynamic> json) {
    _title = json['title'];
    _subtitle = json['subtitle'];
    _uri = json['uri'];
    _qntd = json['qntd'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['title'] = this._title;
    data['subtitle'] = this._subtitle;
    data['uri'] = this._uri;
    data['qntd'] = this._qntd;
    return data;
  }
}