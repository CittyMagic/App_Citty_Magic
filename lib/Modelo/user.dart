
class Usuario{
  var _id;
  var _nombre;
  var _apellidos;
  var _departamento;
  var _direccion;
  var _celular;
  var _correo;
  var _password;

  get id => _id;

  set id(value) {
    _id = value;
  }

  get password => _password;

  set password(value) {
    _password = value;
  }

  get correo => _correo;

  set correo(value) {
    _correo = value;
  }

  get celular => _celular;

  set celular(value) {
    _celular = value;
  }

  get direccion => _direccion;

  set direccion(value) {
    _direccion = value;
  }

  get ciudad => _departamento;

  set ciudad(value) {
    _departamento = value;
  }

  get apellido => _apellidos;

  set apellido(value) {
    _apellidos = value;
  }

  get nombre => _nombre;

  set nombre(value) {
    _nombre = value;
  }

  Usuario(this._id, this._nombre, this._apellidos, this._departamento, this._direccion,
      this._celular, this._correo, this._password);

  Usuario.Empty();

  Usuario.fromJson(Map<String,  dynamic>json):
  _id=json["id"],
  _nombre=json["Nombre"],
  _apellidos=json["Apellidos"],
  _departamento=json["Departamento"],
  _direccion=json["Dirección"],
  _correo=json["Correo"],
  _password=json["Contraseña"],
  _celular=json["N° Celular"];

  Map<String,dynamic> convertir() => {
    "id":_id,
    "Nombre":_nombre,
    "Apellidos":_apellidos,
    "Ciudad":_departamento,
    "Dirección":_direccion,
    "Correo":_correo,
    "Contraseña":_password,
    "N° Celular":_celular
  };
}