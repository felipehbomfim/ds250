class UserModel {
  final int id;
  final int id_veiculo;
  final String name;
  final String cpf;
  final String cnh;
  final String validade;
  final String telefone;
  final bool manter_logado;
  final String foto;
  final String foto_url;
  final String email;
  final String token;

  UserModel({
    required this.id,
    required this.id_veiculo,
    required this.name,
    required this.cpf,
    required this.cnh,
    required this.validade,
    required this.telefone,
    required this.manter_logado,
    required this.foto,
    required this.foto_url,
    required this.email,
    required this.token
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'id_veiculo': id_veiculo,
      'name': name,
      'cpf': cpf,
      'cnh': cnh,
      'validade': validade,
      'telefone': telefone,
      'manter_logado': manter_logado,
      'foto': foto,
      'foto_url': foto_url,
      'email': email,
      'token': token,
    };
  }

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
        id: json['id'],
        id_veiculo: json['id_veiculo'],
        name: json['name'],
        cpf: json['cpf'],
        cnh: json['cnh'],
        validade: json['validade'],
        telefone: json['telefone'],
        manter_logado: json['manter_logado'],
        foto: json['foto'],
        foto_url: json['foto_url'],
        email: json['email'],
        token: json['token']
    );
  }
}