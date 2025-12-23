part of 'index.dart';

class UserDetails {
  final int? id;
  final String? email;
  final String? firstName;
  final String? lastName;
  final String? phoneNumber;
  final String? role;
  final UserProfile? profile;
  final QrCodeDetails? qrcode;

  UserDetails({
    this.id,
    this.email,
    this.firstName,
    this.lastName,
    this.phoneNumber,
    this.role,
    this.profile,
    this.qrcode,
  });

  factory UserDetails.fromJson(Map<String, dynamic> json) {
    return UserDetails(
      id: json['id'],
      email: json['email'],
      firstName: json['first_name'],
      lastName: json['last_name'],
      phoneNumber: json['phone_number'],
      role: json['role'],
      profile: json['profile'] != null
          ? UserProfile.fromJson(json['profile'])
          : null,
      qrcode: json['qrcode'] != null
          ? QrCodeDetails.fromJson(json['qrcode'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'first_name': firstName,
      'last_name': lastName,
      'phone_number': phoneNumber,
      'role': role,
      'profile': profile?.toJson(),
      'qrcode': qrcode?.toJson(),
    };
  }
}

class UserProfile {
  // Personal Details

  final String? photo;
  final String? startDate;
  final int? id;
  final String? endingDate;
  final String? address;
  final String? pinCode;
  final int? age;
  final String? gender;
  final String? state;

  // Identification Details
  final String? aadharUpload;
  final String? insuranceCardUpload;

  // Emergency Contacts
  final String? spouseName;
  final String? spouseMobile;
  final String? relativeName;
  final String? relativeMobile;
  final String? friend1Name;
  final String? friend1Mobile;
  final String? friend2Name;
  final String? friend2Mobile;
  final String? friend3Name;
  final String? friend3Mobile;

  // Medical Details
  final String? healthConditions;
  final String? medicines;

  final bool? isReferrer;
  final String? bankAccountNumber;
  final String? ifscCode;
  final String? bankName;
  final String? bankBranch;
  final String? referralCode;

  final int? user;
  final String? appliedCoupon;
  final String? referredBy;

  UserProfile({
    this.id,
    this.endingDate,
    this.address,
    this.pinCode,
    this.age,
    this.gender,
    this.state,
    this.spouseName,
    this.spouseMobile,
    this.relativeName,
    this.relativeMobile,
    this.friend1Name,
    this.friend1Mobile,
    this.friend2Name,
    this.friend2Mobile,
    this.friend3Name,
    this.friend3Mobile,
    this.healthConditions,
    this.medicines,
    this.photo,
    this.startDate,
    this.isReferrer,
    this.bankAccountNumber,
    this.ifscCode,
    this.bankName,
    this.bankBranch,
    this.referralCode,
    this.aadharUpload,
    this.insuranceCardUpload,
    this.user,
    this.appliedCoupon,
    this.referredBy,
  });

  factory UserProfile.fromJson(Map<String, dynamic> json) {
    return UserProfile(
      id: json['id'],
      endingDate: json['ending_date'],
      address: json['address'],
      pinCode: json['pin_code'],
      age: json['age'],
      gender: json['gender'],
      state: json['state'],
      spouseName: json['spouse_name'],
      spouseMobile: json['spouse_mobile'],
      relativeName: json['relative_name'],
      relativeMobile: json['relative_mobile'],
      friend1Name: json['friend1_name'],
      friend1Mobile: json['friend1_mobile'],
      friend2Name: json['friend2_name'],
      friend2Mobile: json['friend2_mobile'],
      friend3Name: json['friend3_name'],
      friend3Mobile: json['friend3_mobile'],
      healthConditions: json['health_conditions'],
      medicines: json['medicines'],
      photo: json['photo'],
      startDate: json['start_date'],
      isReferrer: json['is_referrer'],
      bankAccountNumber: json['bank_account_number'],
      ifscCode: json['ifsc_code'],
      bankName: json['bank_name'],
      bankBranch: json['bank_branch'],
      referralCode: json['referral_code'],
      aadharUpload: json['aadhar_upload'],
      insuranceCardUpload: json['insurance_card_upload'],
      user: json['user'],
      appliedCoupon: json['applied_coupon'],
      referredBy: json['referred_by'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'ending_date': endingDate,
      'address': address,
      'pin_code': pinCode,
      'age': age,
      'gender': gender,
      'state': state,
      'spouse_name': spouseName,
      'spouse_mobile': spouseMobile,
      'relative_name': relativeName,
      'relative_mobile': relativeMobile,
      'friend1_name': friend1Name,
      'friend1_mobile': friend1Mobile,
      'friend2_name': friend2Name,
      'friend2_mobile': friend2Mobile,
      'friend3_name': friend3Name,
      'friend3_mobile': friend3Mobile,
      'health_conditions': healthConditions,
      'medicines': medicines,
      'photo': photo,
      'start_date': startDate,
      'is_referrer': isReferrer,
      'bank_account_number': bankAccountNumber,
      'ifsc_code': ifscCode,
      'bank_name': bankName,
      'bank_branch': bankBranch,
      'referral_code': referralCode,
      'aadhar_upload': aadharUpload,
      'insurance_card_upload': insuranceCardUpload,
      'user': user,
      'applied_coupon': appliedCoupon,
      'referred_by': referredBy,
    };
  }
}

class QrCodeDetails {
  final int? id;
  final int? user;
  final String? serialNumber;
  final String? couponCode;
  final String? status;
  final String? qrCode;
  final int? job;
  final int? owner;

  QrCodeDetails({
    this.id,
    this.user,
    this.serialNumber,
    this.couponCode,
    this.status,
    this.qrCode,
    this.job,
    this.owner,
  });

  factory QrCodeDetails.fromJson(Map<String, dynamic> json) {
    return QrCodeDetails(
      id: json['id'],
      user: json['user'],
      serialNumber: json['serial_number'],
      couponCode: json['coupon_code'],
      status: json['status'],
      qrCode: json['qr_code'],
      job: json['job'],
      owner: json['owner'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user': user,
      'serial_number': serialNumber,
      'coupon_code': couponCode,
      'status': status,
      'qr_code': qrCode,
      'job': job,
      'owner': owner,
    };
  }
}
