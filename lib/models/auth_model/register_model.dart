part of 'index.dart';

class RegisterModel {
  // Required (business-wise, but nullable here)
  final String? email;
  final String? phoneNumber;
  final String? serialNumber;
  final String? firstName;
  final String? lastName;
  final int? age;
  final String? gender;
  final String? address;
  final String? pinCode;
  final String? state;
  final String? startDate;
  final String? aadharNumber;

  // Files
  final File? photo;
  final File? aadharUpload;

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
    this.email,
    this.phoneNumber,
    this.serialNumber,
    this.firstName,
    this.lastName,
    this.age,
    this.gender,
    this.address,
    this.pinCode,
    this.state,
    this.startDate,
    this.aadharNumber,
    this.photo,
    this.aadharUpload,
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

  /// 🔐 SAFE: No null values go into Map<String, String>
  Map<String, String> toFields() {
    final Map<String, String> data = {};

    void add(String key, String? value) {
      if (value != null && value.isNotEmpty) {
        data[key] = value;
      }
    }

    add('email', email);
    add('phone_number', phoneNumber);
    add('serial_number', serialNumber);
    add('first_name', firstName);
    add('last_name', lastName);
    if (age != null) data['age'] = age!.toString();
    add('gender', gender);
    add('address', address);
    add('pin_code', pinCode);
    add('state', state);
    add('start_date', startDate);
    add('aadhar_number', aadharNumber);

    add('otp', otp);
    add('health_conditions', healthConditions);
    add('medicines', medicines);

    if (isReferrer != null) {
      data['is_referrer'] = isReferrer! ? 'true' : 'false';
    }

    add('referral_code', referralCode);
    add('coupon_code', couponCode);

    add('bank_account_number', bankAccountNumber);
    add('bank_name', bankName);
    add('bank_branch', bankBranch);
    add('ifsc_code', ifscCode);

    add('spouse_name', spouseName);
    add('spouse_mobile', spouseMobile);
    add('relative_name', relativeName);
    add('relative_mobile', relativeMobile);

    add('friend1_name', friend1Name);
    add('friend1_mobile', friend1Mobile);
    add('friend2_name', friend2Name);
    add('friend2_mobile', friend2Mobile);
    add('friend3_name', friend3Name);
    add('friend3_mobile', friend3Mobile);

    return data;
  }

  /// 🛠️ SAFE UPDATE: Only editable + non-null fields
  Map<String, String> toUpdateFields() {
    final Map<String, String> data = {};

    void add(String key, String? value) {
      if (value != null && value.isNotEmpty) {
        data[key] = value;
      }
    }

    add('first_name', firstName);
    add('last_name', lastName);
    if (age != null) data['age'] = age!.toString();
    add('gender', gender);
    add('address', address);
    add('pin_code', pinCode);
    add('state', state);

    add('health_conditions', healthConditions);
    add('medicines', medicines);

    add('bank_account_number', bankAccountNumber);
    add('bank_name', bankName);
    add('bank_branch', bankBranch);
    add('ifsc_code', ifscCode);

    add('spouse_name', spouseName);
    add('spouse_mobile', spouseMobile);
    add('relative_name', relativeName);
    add('relative_mobile', relativeMobile);

    add('friend1_name', friend1Name);
    add('friend1_mobile', friend1Mobile);
    add('friend2_name', friend2Name);
    add('friend2_mobile', friend2Mobile);
    add('friend3_name', friend3Name);
    add('friend3_mobile', friend3Mobile);

    return data;
  }

  /// 📎 SAFE: Only non-null files are added
  Map<String, File> toFiles() {
    final files = <String, File>{};

    if (photo != null) {
      files['photo'] = photo!;
    }
    if (aadharUpload != null) {
      files['aadhar_upload'] = aadharUpload!;
    }

    return files;
  }

  Map<String, File> toUpdateFiles() {
    final files = <String, File>{};

    if (photo != null) {
      files['photo'] = photo!;
    }

    if (aadharUpload != null) {
      files['aadhar_upload'] = aadharUpload!;
    }

    return files;
  }
}
