//teacherModel
class Teacher {
  String teacherEmail;
  String name;
  String teacherId;

  // Constructor
  Teacher({
    required this.teacherEmail,
    required this.name,
    required this.teacherId,
  });

  // Factory method to create a Teacher instance from a Map
  factory Teacher.fromJson(Map<String, dynamic> json) {
    return Teacher(
      teacherEmail:
          json['teacherEmail'] ?? '', // Replace with your actual field name
      name: json['name'] ?? '',
      teacherId: json['teacherId'] ?? '',
    );
  }

  // Method to convert Teacher instance to a Map
  Map<String, dynamic> toJson() {
    return {
      'teacherEmail': teacherEmail,
      'name': name,
      'teacherId': teacherId,
    };
  }
}
//Student model
class Student {
  String email;
  String name;
  String regNo;

  // Constructor
  Student({
    required this.email,
    required this.name,
    required this.regNo,
  });

  // Convert class instance to JSON
  Map<String, dynamic> toJson() {
    return {
      'email': email,
      'name': name,
      'regNo': regNo,
    };
  }

  // Create class instance from JSON
  factory Student.fromJson(Map<String, dynamic> json) {
    return Student(
      email: json['email'],
      name: json['name'],
      regNo: json['regNo'],
    );
  }
}

class StudyMaterial {
  late String sem;
  late String subject;
  late String title;
  late String file;

  // Constructor
  StudyMaterial({
    required this.sem,
    required this.subject,
    required this.title,
    required this.file,
  });

  // Factory method to create an instance from a JSON object
  factory StudyMaterial.fromJson(Map<String, dynamic> json) {
    return StudyMaterial(
      sem: json['sem'] ?? '',
      subject: json['subject'] ?? '',
      title: json['title'] ?? '',
      file: json['file'] ?? '',
    );
  }

  // Method to convert an instance to a JSON object
  Map<String, dynamic> toJson() {
    return {
      'sem': sem,
      'subject': subject,
      'title': title,
      'file': file,
    };
  }
}



class Notification {
  String title;
  String body;
  DateTime timestamp;

  Notification({
    required this.title,
    required this.body,
    required this.timestamp,
  });
}

