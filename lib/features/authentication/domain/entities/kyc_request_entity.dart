import 'dart:io';

import 'package:equatable/equatable.dart';

class KycRequestEntity extends Equatable {
   String? documentTypeId;
   String? documentNumber;
   String? documentName;

  //  String password;
   String? expiryDate;

   File? file;
  //  String password;

   KycRequestEntity({
    this.documentTypeId,
    this.documentNumber,
    this.documentName,
    this.expiryDate,
    this.file,
  });

  @override
  List<Object?> get props => [
        documentTypeId,
        documentNumber,
        documentName,
        expiryDate,
        file,
      ];
}
