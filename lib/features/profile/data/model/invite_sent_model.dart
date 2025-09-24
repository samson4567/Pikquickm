import 'package:pikquick/features/profile/domain/entities/invite_sent_entity.dart'
    show InviteSentToRunnerEntity;

class InviteSentToRunnerModel extends InviteSentToRunnerEntity {
  const InviteSentToRunnerModel({super.runnerId});

  factory InviteSentToRunnerModel.fromJson(Map<String, dynamic> json) {
    return InviteSentToRunnerModel(
      runnerId: json['runner_id'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'runner_id': runnerId,
    };
  }
}
