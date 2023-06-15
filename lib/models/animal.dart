class Animal {
  final String gender;
  final String birthday;
  final String breed;
  final String id;
  final String idDevice;
  String nickname;
  final String uidUser;
  final String weight;
  String status;
  int heartRate;

  Animal({
    required this.gender, 
    required this.birthday, 
    required this.breed, 
    required this.id,
    required this.idDevice, 
    this.nickname = '', 
    required this.uidUser, 
    required this.weight, 
    this.status = 'calmo',
    this.heartRate = 0,
    });

  Map<String, dynamic> toMap() {
    return {
      'gender': gender,
      'birthday': birthday,
      'breed': breed,
      'id': id,
      'idDevice': idDevice,
      'nickname': nickname == '' ? 'Animal ${id.substring(0, id.length < 3 ? id.length : 3)}' : nickname,
      'uidUser': uidUser,
      'weight': weight,
      'status': status,
      'heartRate': heartRate,
    };
  }
}
