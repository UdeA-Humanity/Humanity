class Customer {
  var _uid;
  var _idnumber;
  var _name;
  var _surname;
  var _email;
  var _password;
  var _birthday;
  var _profilePic;

  Customer.Empty();

  Map<String, dynamic> toJson() => {
        "uid": _uid,
        "idnumber": _idnumber,
        "name": _name,
        "surname": _surname,
        "email": _email,
        "password": _password,
        "bornDate": _birthday,
        "profilePic": _profilePic,
      };

  Customer.fromJson(Map<String, dynamic> json)
      : _uid = json['uid'],
        _idnumber = json['idnumber'],
        _name = json['name'],
        _surname = json['surname'],
        _email = json['email'],
        _password = json['password'],
        _birthday = json['birthday'],
        _profilePic = json['profilePic'];

  get name => _name;

  set name(value) {
    _name = value;
  }

  get surname => _surname;

  set surname(value) {
    _surname = value;
  }

  get email => _email;

  get birthday => _birthday;

  set birthday(value) {
    _birthday = value;
  }

  get password => _password;

  set password(value) {
    _password = value;
  }

  set email(value) {
    _email = value;
  }

  Customer(
      this._uid,
      this._idnumber,
      this._name,
      this._surname,
      this._email,
      this._password,
      this._birthday,
      this._profilePic);

  get profilePic => _profilePic;

  set profilePic(value) {
    _profilePic = value;
  }

  get uid => _uid;

  set uid(value) {
    _uid = value;
  }

  get idnumber => _idnumber;

  set idnumber(value) {
    _idnumber = value;
  }
}