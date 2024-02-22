class Objetivo {
  int id;
  String objetivo;
  String descricao;
  bool concluido;
  bool arquivado;
  int prioridade;
  int parentId;
  int userId;
  String updatedAt;
  String createdAt;
  String? deletedAt;

  Objetivo({
    required this.id,
    required this.objetivo,
    required this.descricao,
    required this.concluido,
    required this.arquivado,
    required this.prioridade,
    required this.parentId,
    required this.userId,
    required this.updatedAt,
    required this.createdAt,
    this.deletedAt,
  });

  factory Objetivo.fromJson(Map<String, dynamic> json) {
    return Objetivo(
      id: json['id'],
      objetivo: json['objetivo'],
      descricao: json['descricao'],
      concluido: json['concluido'] == 1 ? true : false,
      arquivado: json['arquivado'] == 1 ? true : false,
      prioridade: json['prioridade'],
      parentId: json['parent_id'],
      userId: json['user_id'],
      updatedAt: json['updated_at'],
      createdAt: json['created_at'],
      deletedAt: json['deleted_at'],
    );
  }
}
