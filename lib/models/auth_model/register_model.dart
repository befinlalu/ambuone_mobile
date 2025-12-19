part of 'index.dart';

class RegisterModel {
  // Required
  final String email;
  final String phoneNumber;
  final String serialNumber;
  final String firstName;
  final String lastName;
  final int age;
  final String gender;
  final String address;
  final String pinCode;
  final String state;
  final String startDate;
  final String aadharNumber;
  final File photo;
  final File aadharUpload;

  // Optional
  final String? otp;
  final String? healthConditions;
  final String? medicines;
  final bool? isReferrer;
  final String? referralCode;
  final String? couponCode;

  final String? bankAccountNumber;
  final String? bankName;
  final String? bankBranch;
  final String? ifscCode;

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

  RegisterModel({
    // Required
    required this.email,
    required this.phoneNumber,
    required this.serialNumber,
    required this.firstName,
    required this.lastName,
    required this.age,
    required this.gender,
    required this.address,
    required this.pinCode,
    required this.state,
    required this.startDate,
    required this.aadharNumber,
    required this.photo,
    required this.aadharUpload,

    // Optional
    this.otp,
    this.healthConditions,
    this.medicines,
    this.isReferrer,
    this.referralCode,
    this.couponCode,
    this.bankAccountNumber,
    this.bankName,
    this.bankBranch,
    this.ifscCode,
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
  });

  Map<String, String> toFields() {
    return {
      // Required
      'email': email,
      'phone_number': phoneNumber,
      'serial_number': serialNumber,
      'first_name': firstName,
      'last_name': lastName,
      'age': age.toString(),
      'gender': gender,
      'address': address,
      'pin_code': pinCode,
      'state': state,
      'start_date': startDate,
      'aadhar_number': aadharNumber,

      // Optional
      if (otp != null) 'otp': otp!,
      if (healthConditions != null) 'health_conditions': healthConditions!,
      if (medicines != null) 'medicines': medicines!,
      if (isReferrer != null) 'is_referrer': isReferrer.toString(),
      if (referralCode != null) 'referral_code': referralCode!,
      if (couponCode != null) 'coupon_code': couponCode!,
      if (bankAccountNumber != null) 'bank_account_number': bankAccountNumber!,
      if (bankName != null) 'bank_name': bankName!,
      if (bankBranch != null) 'bank_branch': bankBranch!,
      if (ifscCode != null) 'ifsc_code': ifscCode!,
      if (spouseName != null) 'spouse_name': spouseName!,
      if (spouseMobile != null) 'spouse_mobile': spouseMobile!,
      if (relativeName != null) 'relative_name': relativeName!,
      if (relativeMobile != null) 'relative_mobile': relativeMobile!,
      if (friend1Name != null) 'friend1_name': friend1Name!,
      if (friend1Mobile != null) 'friend1_mobile': friend1Mobile!,
      if (friend2Name != null) 'friend2_name': friend2Name!,
      if (friend2Mobile != null) 'friend2_mobile': friend2Mobile!,
      if (friend3Name != null) 'friend3_name': friend3Name!,
      if (friend3Mobile != null) 'friend3_mobile': friend3Mobile!,
    };
  }

  Map<String, File> toFiles() {
    return {'photo': photo, 'aadhar_upload': aadharUpload};
  }
}
