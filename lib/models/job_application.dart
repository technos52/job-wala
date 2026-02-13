import 'package:cloud_firestore/cloud_firestore.dart';

class JobApplication {
  final String id;
  final String jobId;
  final String jobTitle;
  final String companyName;
  final String employerId;
  final String candidateId;
  final DateTime appliedAt;
  final String status;
  final DateTime createdAt;
  final DateTime updatedAt;
  final Map<String, dynamic>? additionalData;

  JobApplication({
    required this.id,
    required this.jobId,
    required this.jobTitle,
    required this.companyName,
    required this.employerId,
    required this.candidateId,
    required this.appliedAt,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
    this.additionalData,
  });

  factory JobApplication.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;

    return JobApplication(
      id: doc.id,
      jobId: data['jobId'] ?? '',
      jobTitle: data['jobTitle'] ?? '',
      companyName: data['companyName'] ?? '',
      employerId: data['employerId'] ?? '',
      candidateId: data['candidateId'] ?? '',
      appliedAt: (data['appliedAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
      status: data['status'] ?? 'pending',
      createdAt: (data['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
      updatedAt: (data['updatedAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
      additionalData: data['additionalData'] as Map<String, dynamic>?,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'jobId': jobId,
      'jobTitle': jobTitle,
      'companyName': companyName,
      'employerId': employerId,
      'candidateId': candidateId,
      'appliedAt': Timestamp.fromDate(appliedAt),
      'status': status,
      'createdAt': Timestamp.fromDate(createdAt),
      'updatedAt': Timestamp.fromDate(updatedAt),
      if (additionalData != null) 'additionalData': additionalData,
    };
  }

  JobApplication copyWith({
    String? id,
    String? jobId,
    String? jobTitle,
    String? companyName,
    String? employerId,
    String? candidateId,
    DateTime? appliedAt,
    String? status,
    DateTime? createdAt,
    DateTime? updatedAt,
    Map<String, dynamic>? additionalData,
  }) {
    return JobApplication(
      id: id ?? this.id,
      jobId: jobId ?? this.jobId,
      jobTitle: jobTitle ?? this.jobTitle,
      companyName: companyName ?? this.companyName,
      employerId: employerId ?? this.employerId,
      candidateId: candidateId ?? this.candidateId,
      appliedAt: appliedAt ?? this.appliedAt,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      additionalData: additionalData ?? this.additionalData,
    );
  }

  @override
  String toString() {
    return 'JobApplication(id: $id, jobTitle: $jobTitle, companyName: $companyName, status: $status)';
  }
}

enum ApplicationStatus {
  pending,
  reviewed,
  accepted,
  rejected,
  withdrawn;

  String get displayName {
    switch (this) {
      case ApplicationStatus.pending:
        return 'Pending';
      case ApplicationStatus.reviewed:
        return 'Under Review';
      case ApplicationStatus.accepted:
        return 'Accepted';
      case ApplicationStatus.rejected:
        return 'Rejected';
      case ApplicationStatus.withdrawn:
        return 'Withdrawn';
    }
  }
}
