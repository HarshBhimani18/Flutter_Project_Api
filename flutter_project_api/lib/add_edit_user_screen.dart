import 'package:flutter_project_api/api_services/api_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_project_api/utils/helpers.dart';
import 'package:intl/intl.dart';

class UserEntryPage extends StatefulWidget {
  Map<String, dynamic>? userDetails = {};

  UserEntryPage({super.key, this.userDetails});

  @override
  State<UserEntryPage> createState() => _UserEntryPageState();
}

class _UserEntryPageState extends State<UserEntryPage> {
  List<String> cities = ["Rajkot", "Ahmedabad", "Bhavnagar", "Vadodra"];
  List<String> genders = ["Male", "Female", "Other"];
  Map<String, int> hobbies = Map.from(Helpers.hobbies);
  bool isLoading = true;

  Map<int, String> categoryHobbyMap = {
    1: 'Sports',
    2: 'Gaming',
    3: 'Traveling',
    4: 'Music',
    5: 'Reading',
  };

  String selectedCity = '';
  List<dynamic> selectedHobbies = ['Sports','Gaming','Traveling','Reading','Music'];
  bool isEditPage = false;
  String selectedGender = 'Male';
  DateTime? selectedDate;
  DateTime? date;

  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController mobileNumberController = TextEditingController();
  TextEditingController dobController = TextEditingController();
  TextEditingController cityController = TextEditingController();
  TextEditingController hobbiesController = TextEditingController();
  TextEditingController castController = TextEditingController();


  final GlobalKey<FormState> _formKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    isEditPage = widget.userDetails != null;

    selectedCity = widget.userDetails?['city'] ?? cities[0];
    selectedGender = widget.userDetails?['gender'] ?? genders[0];
    nameController.text = widget.userDetails?['name'] ?? '';
    emailController.text = widget.userDetails?['email'] ?? '';
    mobileNumberController.text = widget.userDetails?['mobile'] ?? '';
    dobController.text = widget.userDetails?['dob'] ?? '';
    castController.text = widget.userDetails?['cast'] ?? '';

    print("::: from init state of add_edit_user :::");
    print(widget.userDetails);
    // Initialize hobbies
    selectedHobbies = widget.userDetails?['hobbies'] != null
        ? List<dynamic>.from(widget.userDetails!['hobbies'])
        : [];
  }



  void handleSubmitForm() async {
    ApiService apiService = ApiService();
    if (!_formKey.currentState!.validate()) return;

    Map<String, dynamic> user = {
      "name": nameController.text.trim(),
      "email": emailController.text.trim(),
      "mobile": mobileNumberController.text.trim(),
      "dob": dobController.text.trim(),
      "cast": castController.text.trim(),
      "gender": selectedGender,
      "city": selectedCity,
      "hobbies": selectedHobbies,
      "isFavorite": widget.userDetails?['isFavorite'] ?? false,
    };

    setState(() => isLoading = true);

    try {
      if (isEditPage) {
        await apiService.updateUser(widget.userDetails!['id'], user);
      } else {
        await apiService.addUser(user);
      }
      Navigator.pop(context, user);
    } catch (e) {
      print("Error submitting form: $e");
    } finally {
      setState(() => isLoading = false);
    }
  }
  void _selectDate(BuildContext context) async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: selectedDate ?? DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (pickedDate != null) {
      setState(() {
        selectedDate = pickedDate;
        dobController.text = DateFormat('dd MMM yyyy').format(pickedDate);
      });
    }
  }

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    mobileNumberController.dispose();
    dobController.dispose();
    cityController.dispose();
    hobbiesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.pink[100],
      appBar: AppBar(
        title: Text(
          isEditPage ? "Edit Profile" : "Create Profile",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        backgroundColor: Colors.pink,
        elevation: 0,
      ),
      body: Container(
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  Card(
                    elevation: 8,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Personal Information",
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.pink,
                            ),
                          ),
                          SizedBox(height: 16),
                          inputTextField(
                            text: "Full Name",
                            controller: nameController,
                            forWhatValue: "name",
                            regxPattern: r"^[a-zA-Z\s'-]{2,50}$",
                            icon: Icons.person,
                            textInputType: TextInputType.text,
                            inputFormatters: [
                              FilteringTextInputFormatter.allow(
                                  RegExp(r'[a-zA-Z\s]')),
                            ],
                          ),
                          inputTextField(
                            text: "Email Address",
                            controller: emailController,
                            forWhatValue: "Email",
                            regxPattern:
                            r"^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$",
                            icon: Icons.email,
                            textInputType: TextInputType.emailAddress,
                            inputFormatters: [
                              FilteringTextInputFormatter.deny(RegExp(r'\s')),
                            ],
                          ),
                          inputTextField(
                            text: "Mobile Number",
                            controller: mobileNumberController,
                            forWhatValue: "Mobile Number",
                            regxPattern: r"^\+?[0-9]{10,15}$",
                            textInputType: TextInputType.number,
                            inputFormatters: [
                              FilteringTextInputFormatter.digitsOnly
                            ],
                            icon: Icons.phone,
                            maxLength: 10,
                          ),
                          inputTextField(
                            text: "Cast",
                            controller: castController,
                            forWhatValue: "Cast",
                            regxPattern: r"^[a-zA-Z\s'-]{2,50}$",
                            icon: Icons.person,
                            textInputType: TextInputType.text,
                          ),
                          buildDatePicker(),
                          buildGenderDropdown(),
                          buildCityDropdown(),
                          SizedBox(height: 16),
                          Text(
                            "Hobbies & Interests",
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.pink,
                            ),
                          ),
                          SizedBox(height: 8),
                          buildHobbiesSection(),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 24),
                  LayoutBuilder(
                    builder: (context, constraints) {
                      if (constraints.maxWidth > 600) {
                        // For wider screens, keep the buttons side by side
                        return Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            _buildSubmitButton(),
                            SizedBox(width: 16),
                            _buildResetButton(),
                          ],
                        );
                      } else {
                        // For narrower screens, stack the buttons vertically
                        return Column(
                          children: [
                            _buildSubmitButton(),
                            SizedBox(height: 16),
                            _buildResetButton(),
                          ],
                        );
                      }
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget inputTextField({
    required String text,
    TextEditingController? controller,
    String? forWhatValue,
    String? regxPattern,
    IconData? icon,
    TextInputType? textInputType,
    List<TextInputFormatter>? inputFormatters,
    int? maxLength,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextFormField(
        validator: (value) {
          if (value!.isEmpty) {
            return 'Enter Valid $forWhatValue';
          }
          if (!RegExp(regxPattern ?? '').hasMatch(value)) {
            return 'Enter Valid $forWhatValue';
          }
          return null;
        },
        controller: controller,
        decoration: InputDecoration(
          hintText: text,
          labelText: text,
          prefixIcon: Icon(icon, color: Colors.pink),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: Colors.red.shade700),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: Colors.red.shade700, width: 2),
          ),
          filled: true,
          fillColor: Colors.white,
        ),
        keyboardType: textInputType,
        inputFormatters: inputFormatters,
        maxLength: maxLength,
      ),
    );
  }

  Widget buildDatePicker() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: InkWell(
        onTap: () => _selectDate(context),
        child: InputDecorator(
          decoration: InputDecoration(
            labelText: "Date of Birth",
            prefixIcon: Icon(Icons.calendar_today, color: Colors.pink),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
          ),
          child: Text(
            dobController.text.isEmpty ? "Select Date" : dobController.text,
            style: TextStyle(fontSize: 16),
          ),
        ),
      ),
    );
  }


  Widget buildHobbiesSection() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Hobbies & Interests",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.pink,
            ),
          ),
          SizedBox(height: 8),
          Wrap(
            spacing: 8.0,
            runSpacing: 8.0,
            children: hobbies.entries.map((entry) {
              return FilterChip(
                label: Text(entry.key),
                selected: selectedHobbies.contains(entry.key),
                onSelected: (bool selected) {
                  setState(() {
                    if(selected){
                      selectedHobbies.add(entry.key);
                    }
                    else{
                      selectedHobbies.remove(entry.key);
                    }
                  });
                },
                backgroundColor: Colors.pink[100], // Default unselected color
                selectedColor: Colors.pink, // Color when selected
                labelStyle: TextStyle(
                  color: entry.value == 1 ? Colors.white : Colors.black,
                  fontWeight: entry.value == 1 ? FontWeight.bold : FontWeight.normal,
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }


  Widget buildGenderDropdown() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: DropdownButtonFormField<String>(
        value: genders.contains(selectedGender) ? selectedGender : null,
        decoration: InputDecoration(
          labelText: "Gender",
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
        ),
        items: genders.map((gender) {
          return DropdownMenuItem(value: gender, child: Text(gender));
        }).toList(),
        onChanged: (value) {
          setState(() => selectedGender = value ?? genders[0]);
        },
      ),
    );
  }


  Widget buildCityDropdown() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: DropdownButtonFormField<String>(
        value: cities.contains(selectedCity) ? selectedCity : null,
        decoration: InputDecoration(
          labelText: "City",
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
        ),
        items: cities.map((city) {
          return DropdownMenuItem(value: city, child: Text(city));
        }).toList(),
        onChanged: (value) {
          setState(() => selectedCity = value ?? cities[0]);
        },
      ),
    );
  }


  List<Widget> getCheckBox() {
    return hobbies.entries.map((entry) {
      return Container(
        decoration: BoxDecoration(
          border: Border.all(color: Colors.pink,),
          borderRadius: BorderRadius.circular(20),
        ),
        child: InkWell(
          onTap: () {
            setState(() {
              hobbies[entry.key] = hobbies[entry.key] == 1 ? 0 : 1;
            });
          },
          child: Padding(
            padding:
            const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  hobbies[entry.key] == 1
                      ? Icons.check_circle
                      : Icons.circle_outlined,
                  color: Colors.pink,
                  size: 20,
                ),
                SizedBox(width: 8),
                Text(
                  entry.key,
                  style: TextStyle(
                    fontSize: 14,
                    color: hobbies[entry.key] == 1
                        ? Colors.red.shade700
                        : Colors.black87,
                    fontWeight: hobbies[entry.key] == 1
                        ? FontWeight.bold
                        : FontWeight.normal,
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }).toList();
  }

  void resetForm() {
    setState(() {
      // Reset text controllers
      nameController.clear();
      emailController.clear();
      mobileNumberController.clear();
      dobController.clear();
      cityController.clear();
      hobbiesController.clear();

      // Reset dropdown selections
      selectedCity = cities[0];
      selectedGender = genders[0];

      // Reset date to 18 years ago
      date = DateTime(DateTime.now().year - 18);

      // Reset all hobbies to false
      hobbies.forEach((key, value) {
        hobbies[key] = 0;
      });

      // Reset form validation state
      // _formKey.currentState?.reset();

    });
  }

  Widget _buildSubmitButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.pink,
          padding: EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
        ),
        onPressed: handleSubmitForm,
        child: Text(
          isEditPage ? "Update Profile" : "Create Profile",
          style: const TextStyle(
            color: Colors.white,
            fontSize: 18,
          ),
        ),
      ),
    );
  }

  Widget _buildResetButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.grey[300],
          foregroundColor: Colors.red.shade700,
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
          elevation: 2,
        ),
        onPressed: resetForm,
        child: const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.refresh, size: 20),
            SizedBox(width: 8),
            Text(
              "Reset",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}