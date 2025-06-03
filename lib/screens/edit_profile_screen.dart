import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import '../services/profile_service.dart';
import '../services/auth_service.dart';
import '../models/user_profile.dart';
import '../widgets/custom_textfield.dart';
import '../widgets/custom_button.dart';

class EditProfileScreen extends StatefulWidget {
  final UserProfile? userProfile;

  const EditProfileScreen({super.key, this.userProfile});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  final ProfileService _profileService = ProfileService();
  final ImagePicker _imagePicker = ImagePicker();

  // Text Controllers
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _nationalIdController = TextEditingController();
  final _birthDateController = TextEditingController();
  final _addressController = TextEditingController();

  UserProfile? _userProfile;
  File? _imageFile;
  DateTime? _selectedDate;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _userProfile = widget.userProfile;
    if (_userProfile != null) {
      _populateFields();
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    // If we don't have a profile from constructor, check arguments
    if (_userProfile == null) {
      final args = ModalRoute.of(context)?.settings.arguments;
      if (args is UserProfile) {
        _userProfile = args;
        _populateFields();
      }
    }
  }

  void _populateFields() {
    if (_userProfile != null) {
      _nameController.text = _userProfile!.name;
      _emailController.text = _userProfile!.email;
      _phoneController.text = _userProfile!.phone;
      _nationalIdController.text = _userProfile!.nationalId;
      _addressController.text = _userProfile!.address;

      try {
        _selectedDate = DateTime.parse(_userProfile!.birthDate);
        _birthDateController.text = DateFormat(
          'yyyy-MM-dd',
        ).format(_selectedDate!);
      } catch (e) {
        _birthDateController.text = _userProfile!.birthDate;
      }
    }
  }

  Future<void> _pickImage() async {
    try {
      final pickedFile = await _imagePicker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 80,
      );

      if (pickedFile != null) {
        setState(() {
          _imageFile = File(pickedFile.path);
        });
      }
    } catch (e) {
      _showErrorSnackBar('Failed to pick image: $e');
    }
  }

  Future<void> _selectDate() async {
    final DateTime now = DateTime.now();
    final DateTime initialDate = _selectedDate ?? now;
    final DateTime firstDate = DateTime(1950);
    final DateTime lastDate = now;

    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: firstDate,
      lastDate: lastDate,
      builder: (context, child) {
        return Theme(
          data: ThemeData.light().copyWith(
            colorScheme: ColorScheme.light(
              primary: Colors.indigo.shade700,
              onPrimary: Colors.white,
              onSurface: Colors.black,
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
        _birthDateController.text = DateFormat('yyyy-MM-dd').format(picked);
      });
    }
  }

  Future<void> _updateProfile() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final token = await AuthService().getToken();
      if (token == null) {
        throw Exception('No authentication token found');
      }

      final data = {
        'name': _nameController.text.trim(),
        'email': _emailController.text.trim(),
        'phone': _phoneController.text.trim(),
        'national_id': _nationalIdController.text.trim(),
        'birth_date': _birthDateController.text.trim(),
        'address': _addressController.text.trim(),
        if (_imageFile?.path != null) 'image': _imageFile!.path,
      };

      await _profileService.updateProfile(token: token, data: data);

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Profile updated successfully'),
          backgroundColor: Colors.green,
        ),
      );

      // Return to profile screen
      Navigator.pop(context, true);
    } catch (e) {
      if (!mounted) return;

      _showErrorSnackBar('Failed to update profile: $e');
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _nationalIdController.dispose();
    _birthDateController.dispose();
    _addressController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Profile'),
        backgroundColor: Colors.indigo,
      ),
      body:
          _userProfile == null
              ? const Center(child: CircularProgressIndicator())
              : SingleChildScrollView(
                padding: const EdgeInsets.all(16.0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      // Profile Image
                      Center(
                        child: Stack(
                          children: [
                            CircleAvatar(
                              radius: 60,
                              backgroundColor: Colors.indigo.shade100,
                              backgroundImage:
                                  _imageFile != null
                                      ? FileImage(_imageFile!)
                                      : _userProfile?.image != null
                                      ? NetworkImage(_userProfile!.image!)
                                      : null,
                              child:
                                  (_imageFile == null &&
                                          _userProfile?.image == null)
                                      ? Text(
                                        _userProfile?.name.isNotEmpty == true
                                            ? _userProfile!.name[0]
                                                .toUpperCase()
                                            : 'S',
                                        style: TextStyle(
                                          fontSize: 40,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.indigo.shade800,
                                        ),
                                      )
                                      : null,
                            ),
                            Positioned(
                              bottom: 0,
                              right: 0,
                              child: Container(
                                padding: const EdgeInsets.all(4),
                                decoration: BoxDecoration(
                                  color: Colors.indigo,
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    color: Colors.white,
                                    width: 2,
                                  ),
                                ),
                                child: IconButton(
                                  icon: const Icon(
                                    Icons.camera_alt,
                                    color: Colors.white,
                                    size: 20,
                                  ),
                                  onPressed: _pickImage,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 30),

                      // Form Fields
                      CustomTextField(
                        controller: _nameController,
                        labelText: 'Full Name',
                        prefixIcon: Icons.person,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your name';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),

                      CustomTextField(
                        controller: _emailController,
                        labelText: 'Email',
                        prefixIcon: Icons.email,
                        keyboardType: TextInputType.emailAddress,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your email';
                          }
                          if (!RegExp(
                            r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$',
                          ).hasMatch(value)) {
                            return 'Please enter a valid email';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),

                      CustomTextField(
                        controller: _phoneController,
                        labelText: 'Phone Number',
                        prefixIcon: Icons.phone,
                        keyboardType: TextInputType.phone,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your phone number';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),

                      CustomTextField(
                        controller: _nationalIdController,
                        labelText: 'National ID',
                        prefixIcon: Icons.badge,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your national ID';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),

                      // Birth Date Picker
                      GestureDetector(
                        onTap: _selectDate,
                        child: AbsorbPointer(
                          child: CustomTextField(
                            controller: _birthDateController,
                            labelText: 'Birth Date',
                            prefixIcon: Icons.calendar_today,
                            suffixIcon: const Icon(Icons.arrow_drop_down),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please select your birth date';
                              }
                              return null;
                            },
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),

                      CustomTextField(
                        controller: _addressController,
                        labelText: 'Address',
                        prefixIcon: Icons.location_on,
                        maxLines: 3,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your address';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 30),

                      // Update Button
                      CustomButton(
                        text: 'Update Profile',
                        onPressed: _isLoading ? null : _updateProfile,
                        isLoading: _isLoading,
                      ),
                      const SizedBox(height: 20),

                      // Cancel Button
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: Text(
                          'Cancel',
                          style: TextStyle(
                            color: Colors.grey.shade700,
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
    );
  }
}
