import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../utils/custom_colors.dart';
import '../Api/config.dart';
import '../Api/data_store.dart';

class HealthCampEvent {
  final int id;
  final String title;
  final String date;
  final String time;
  final String location;
  final String icon;
  final String color;
  final String badge;
  final String badgeColor;
  final int slots;
  int registered;
  final double registrationFee;

  HealthCampEvent({
    required this.id,
    required this.title,
    required this.date,
    required this.time,
    required this.location,
    required this.icon,
    required this.color,
    required this.badge,
    required this.badgeColor,
    required this.slots,
    required this.registered,
    required this.registrationFee,
  });

  factory HealthCampEvent.fromJson(Map<String, dynamic> json) {
    return HealthCampEvent(
      id: int.tryParse(json['id']?.toString() ?? '0') ?? 0,
      title: json['title'] ?? '',
      date: json['camp_date'] ?? '',
      time: json['camp_time'] ?? '',
      location: json['location'] ?? '',
      icon: json['icon'] ?? 'local_activity',
      color: json['color'] ?? '',
      badge: json['badge'] ?? 'Free',
      badgeColor: json['badge_color'] ?? '',
      slots: int.tryParse(json['slots']?.toString() ?? '0') ?? 0,
      registered: int.tryParse(json['registered']?.toString() ?? '0') ?? 0,
      registrationFee: double.tryParse(json['registration_fee']?.toString() ?? '0') ?? 0,
    );
  }
}

class GalleryItem {
  final int id;
  final String image;
  final String label;
  final String location;
  final String attended;
  final String month;
  final bool isFeatured;

  GalleryItem({
    required this.id,
    required this.image,
    required this.label,
    required this.location,
    required this.attended,
    required this.month,
    required this.isFeatured,
  });

  factory GalleryItem.fromJson(Map<String, dynamic> json) {
    return GalleryItem(
      id: int.tryParse(json['id']?.toString() ?? '0') ?? 0,
      image: json['image'] ?? '',
      label: json['label'] ?? '',
      location: json['location'] ?? '',
      attended: json['attended']?.toString() ?? '0',
      month: json['month_year'] ?? '',
      isFeatured: (json['is_featured']?.toString() ?? '0') == '1',
    );
  }
}

class HealthCampScreen extends StatefulWidget {
  const HealthCampScreen({super.key});

  @override
  State<HealthCampScreen> createState() => _HealthCampScreenState();
}

class _HealthCampScreenState extends State<HealthCampScreen> {
  List<HealthCampEvent> camps = [];
  List<GalleryItem> gallery = [];
  bool isLoading = true;
  int? registeringCampId;

  int upcomingCount = 0;
  int peopleServedTotal = 0;
  int uniqueLocations = 0;

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  String getFullImageUrl(String path) {
    if (path.isEmpty) return 'https://images.unsplash.com/photo-1584308666744-24d5c474f2ae?w=300&q=80';
    if (path.startsWith('http')) return path;
    return '${Config.socketUrlDoctor}/uploads/health_camp/$path';
  }

  Future<void> fetchData() async {
    try {
      // 1. Ensure tables exist (optional, safety sync as React does)
      await http.post(Uri.parse('${Config.socketUrlDoctor}/customer/create_health_camp_tables'));

      // 2. Fetch Camps
      final campsRes = await http.post(Uri.parse('${Config.socketUrlDoctor}/customer/health_camps'));
      if (campsRes.statusCode == 200) {
        final data = json.decode(campsRes.body);
        if (data['ResponseCode'] == 200 && data['camp_list'] != null) {
          final List<dynamic> list = data['camp_list'];
          camps = list.map((e) => HealthCampEvent.fromJson(e)).toList();
        }
      }

      // 3. Fetch Gallery
      final galleryRes = await http.post(Uri.parse('${Config.socketUrlDoctor}/customer/health_camp_gallery'));
      if (galleryRes.statusCode == 200) {
        final data = json.decode(galleryRes.body);
        if (data['ResponseCode'] == 200 && data['gallery_list'] != null) {
          final List<dynamic> list = data['gallery_list'];
          gallery = list.map((e) => GalleryItem.fromJson(e)).toList();
        }
      }

      calculateStats();

      setState(() {
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
    }
  }

  void calculateStats() {
    upcomingCount = camps.length;
    
    int attendedTotal = 0;
    for (var g in gallery) {
      int c = int.tryParse(g.attended.replaceAll(',', '').replaceAll('+', '')) ?? 0;
      attendedTotal += c;
    }
    peopleServedTotal = attendedTotal;

    Set<String> locations = {};
    for (var c in camps) {
      if (c.location.isNotEmpty) locations.add(c.location);
    }
    for (var g in gallery) {
      if (g.location.isNotEmpty) locations.add(g.location);
    }
    uniqueLocations = locations.length;
  }

  Future<void> handleRegisterClick(HealthCampEvent camp) async {
    final userLogin = getData.read("UserLogin");
    if (userLogin != null) {
      String name = userLogin['name']?.toString() ?? "User";
      String phone = userLogin['mobile']?.toString() ?? userLogin['phone']?.toString() ?? "";
      String email = userLogin['email']?.toString() ?? "";
      if (name.isNotEmpty || phone.isNotEmpty) {
        await processRegistration(camp, name: name, phone: phone, email: email);
        return;
      }
    }
    
    // Otherwise open modal/dialog to get info
    _showRegistrationDialog(camp);
  }

  Future<void> processRegistration(HealthCampEvent camp, {required String name, required String phone, required String email}) async {
    setState(() {
      registeringCampId = camp.id;
    });

    try {
      final customerId = getData.read("UserLogin")?['id']?.toString() ?? '0';

      final res = await http.post(
        Uri.parse('${Config.socketUrlDoctor}/customer/register_health_camp'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'camp_id': camp.id.toString(),
          'customer_id': customerId,
          'full_name': name,
          'phone': phone,
          'email': email,
        }),
      );

      final resData = json.decode(res.body);
      if (resData['ResponseCode'] == 200) {
        setState(() {
          camp.registered += 1;
        });
        Get.snackbar(
          "Success", 
          "Successfully registered for ${camp.title}!",
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green.shade600,
          colorText: Colors.white,
          margin: const EdgeInsets.all(15)
        );
      } else {
        Get.snackbar(
          "Registration Failed", 
          resData['message'] ?? 'Unable to register at this time.',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.redAccent,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      Get.snackbar(
        "Error", 
        "An error occurred during registration.",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.redAccent,
        colorText: Colors.white,
      );
    } finally {
      if (mounted) {
        setState(() {
          registeringCampId = null;
        });
      }
    }
  }

  void _showRegistrationDialog(HealthCampEvent camp) {
    String name = "";
    String phone = "";
    String email = "";

    Get.dialog(
      Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(child: Text("Register for ${camp.title}", style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold))),
                    IconButton(icon: const Icon(Icons.close), onPressed: () => Get.back()),
                  ],
                ),
                const SizedBox(height: 15),
                TextField(
                  decoration: InputDecoration(labelText: 'Full Name', border: OutlineInputBorder(borderRadius: BorderRadius.circular(12))),
                  onChanged: (val) => name = val,
                ),
                const SizedBox(height: 15),
                TextField(
                  decoration: InputDecoration(labelText: 'Phone Number', border: OutlineInputBorder(borderRadius: BorderRadius.circular(12))),
                  keyboardType: TextInputType.phone,
                  onChanged: (val) => phone = val,
                ),
                const SizedBox(height: 15),
                TextField(
                  decoration: InputDecoration(labelText: 'Email (Optional)', border: OutlineInputBorder(borderRadius: BorderRadius.circular(12))),
                  keyboardType: TextInputType.emailAddress,
                  onChanged: (val) => email = val,
                ),
                const SizedBox(height: 25),
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: primeryColor,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    onPressed: () {
                      if (name.isEmpty || phone.isEmpty) {
                        Get.snackbar("Required", "Name and Phone are required", backgroundColor: Colors.orange, colorText: Colors.white);
                        return;
                      }
                      Get.back(); // close dialog
                      processRegistration(camp, name: name, phone: phone, email: email);
                    },
                    child: Text(
                      camp.registrationFee > 0 ? "Confirm & Pay ₹${camp.registrationFee.toStringAsFixed(0)}" : "Confirm Registration",
                      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      )
    );
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return Scaffold(
        appBar: AppBar(
          backgroundColor: primeryColor,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () => Get.back(),
          ),
          title: const Text("Health Camps", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        ),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FD),
      appBar: AppBar(
        backgroundColor: primeryColor,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Get.back(),
        ),
        title: const Text("Health Camps", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Hero
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [primeryColor, Colors.teal.shade600],
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                ),
              ),
              child: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.local_activity, color: Colors.white, size: 16),
                        SizedBox(width: 6),
                        Text("UPCOMING EVENTS", style: TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold, letterSpacing: 1.2)),
                      ],
                    ),
                  ),
                  const SizedBox(height: 15),
                  const Text("Health Camps", style: TextStyle(color: Colors.white, fontSize: 32, fontWeight: FontWeight.w900)),
                  const SizedBox(height: 10),
                  const Text(
                    "Join our free community health camps for screenings, vaccinations, and wellness checkups — all at no cost.",
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.white70, fontSize: 14, height: 1.5),
                  )
                ],
              ),
            ),

            // Stats
            Transform.translate(
              offset: const Offset(0, -20),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  children: [
                    Expanded(child: _statCard(Icons.event, "Upcoming Camps", "$upcomingCount")),
                    const SizedBox(width: 10),
                    Expanded(child: _statCard(Icons.people, "People Served", "$peopleServedTotal")),
                    const SizedBox(width: 10),
                    Expanded(child: _statCard(Icons.location_on, "Locations", "$uniqueLocations")),
                  ],
                ),
              ),
            ),

            // Camps List
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text("Upcoming Health Camps", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black87)),
                  const SizedBox(height: 15),
                  if (camps.isEmpty)
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(30),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: Colors.grey.shade200),
                      ),
                      child: Column(
                        children: [
                          Icon(Icons.event_busy, size: 50, color: Colors.grey.shade300),
                          const SizedBox(height: 15),
                          const Text("No upcoming health camps at the moment.", style: TextStyle(color: Colors.grey, fontWeight: FontWeight.bold)),
                          const SizedBox(height: 5),
                          Text("Please check back later for updates.", style: TextStyle(color: Colors.grey.shade400, fontSize: 12)),
                        ],
                      ),
                    )
                  else
                    ...camps.map((camp) => _campCard(camp)),
                ],
              ),
            ),

            // Gallery
            if (gallery.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(left: 20, right: 20, top: 30, bottom: 40),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text("Previous Health Camps", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black87)),
                    const SizedBox(height: 4),
                    Text("Glimpses of the impact we've made together", style: TextStyle(color: Colors.grey.shade500, fontSize: 13, fontWeight: FontWeight.w500)),
                    const SizedBox(height: 20),
                    
                    if (gallery.where((g) => g.isFeatured).isNotEmpty)
                      _featuredGalleryCard(gallery.firstWhere((g) => g.isFeatured))
                    else
                      _featuredGalleryCard(gallery.first),

                    const SizedBox(height: 15),
                    
                    GridView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: 15,
                        mainAxisSpacing: 15,
                        childAspectRatio: 1.1,
                      ),
                      itemCount: gallery.where((g) => !g.isFeatured).length,
                      itemBuilder: (context, index) {
                        final g = gallery.where((g) => !g.isFeatured).toList()[index];
                        return _galleryGridItem(g);
                      },
                    )
                  ],
                ),
              )
          ],
        ),
      ),
    );
  }

  Widget _statCard(IconData icon, String label, String value) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(color: Colors.grey.withOpacity(0.1), blurRadius: 10, offset: const Offset(0, 5))
        ],
        border: Border.all(color: Colors.grey.shade100),
      ),
      child: Column(
        children: [
          Icon(icon, color: primeryColor, size: 28),
          const SizedBox(height: 8),
          Text(value, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w900, color: Colors.black87)),
          const SizedBox(height: 4),
          Text(label, style: TextStyle(fontSize: 10, color: Colors.grey.shade500, fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }

  Widget _campCard(HealthCampEvent camp) {
    double pct = 0;
    if (camp.slots > 0) {
      pct = (camp.registered / camp.slots).clamp(0.0, 1.0);
    }
    bool isFull = camp.registered >= camp.slots;
    bool isAlmostFull = pct > 0.9 && !isFull;
    bool isRegistering = registeringCampId == camp.id;

    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(color: Colors.grey.withOpacity(0.05), blurRadius: 8, offset: const Offset(0, 4))
        ],
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 50, height: 50,
                decoration: BoxDecoration(
                  color: Colors.blue.shade50,
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Icon(Icons.water_drop, color: Colors.blue.shade600, size: 28), // using placeholder icon
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                decoration: BoxDecoration(
                  color: Colors.blue.shade50,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(camp.badge, style: TextStyle(color: Colors.blue.shade700, fontSize: 10, fontWeight: FontWeight.bold)),
              )
            ],
          ),
          const SizedBox(height: 15),
          Text(camp.title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w800, color: Colors.black87)),
          const SizedBox(height: 12),
          _iconText(Icons.calendar_today, camp.date),
          const SizedBox(height: 6),
          _iconText(Icons.schedule, camp.time),
          const SizedBox(height: 6),
          _iconText(Icons.location_on, camp.location),
          const SizedBox(height: 20),
          
          // Progress Bar
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("${camp.registered} registered", style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Colors.grey.shade600)),
              Text("${camp.slots} slots", style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Colors.grey.shade600)),
            ],
          ),
          const SizedBox(height: 8),
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: LinearProgressIndicator(
              value: pct,
              minHeight: 8,
              backgroundColor: Colors.grey.shade100,
              color: isAlmostFull || isFull ? Colors.redAccent : primeryColor,
            ),
          ),
          if (isAlmostFull)
            Padding(
              padding: const EdgeInsets.only(top: 8),
              child: Row(
                children: const [
                  Icon(Icons.warning, size: 14, color: Colors.redAccent),
                  SizedBox(width: 4),
                  Text("Almost Full!", style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Colors.redAccent)),
                ],
              ),
            ),
            
          const SizedBox(height: 20),
          
          Row(
            children: [
              Expanded(
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade50,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: Colors.grey.shade200)
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("REGISTERED", style: TextStyle(fontSize: 9, fontWeight: FontWeight.bold, color: Colors.grey.shade400)),
                      const SizedBox(width: 6),
                      Text("${camp.registered}/${camp.slots}", style: TextStyle(fontSize: 12, fontWeight: FontWeight.w900, color: Colors.grey.shade700)),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  decoration: BoxDecoration(
                    color: primeryColor.withOpacity(0.05),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: primeryColor.withOpacity(0.1))
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("FEE", style: TextStyle(fontSize: 9, fontWeight: FontWeight.bold, color: primeryColor.withOpacity(0.6))),
                      const SizedBox(width: 6),
                      Text(camp.registrationFee > 0 ? "₹${camp.registrationFee.toStringAsFixed(0)}" : "Free", style: TextStyle(fontSize: 12, fontWeight: FontWeight.w900, color: primeryColor)),
                    ],
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          
          SizedBox(
            width: double.infinity,
            height: 48,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: isFull ? Colors.grey.shade200 : primeryColor,
                elevation: isFull ? 0 : 4,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              onPressed: isFull || isRegistering ? null : () => handleRegisterClick(camp),
              child: isRegistering 
                  ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                  : Text(
                      isFull ? "Fully Booked" : "Register Now",
                      style: TextStyle(
                        fontSize: 14, 
                        fontWeight: FontWeight.bold, 
                        color: isFull ? Colors.grey.shade500 : Colors.white
                      ),
                    ),
            ),
          )
        ],
      ),
    );
  }

  Widget _iconText(IconData icon, String text) {
    return Row(
      children: [
        Icon(icon, size: 14, color: primeryColor),
        const SizedBox(width: 8),
        Expanded(child: Text(text, style: TextStyle(fontSize: 13, color: Colors.grey.shade600, fontWeight: FontWeight.w600))),
      ],
    );
  }

  Widget _featuredGalleryCard(GalleryItem g) {
    return Container(
      height: 250,
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.white, width: 4),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 15, offset: const Offset(0, 8))
        ],
        image: DecorationImage(
          image: NetworkImage(getFullImageUrl(g.image)),
          fit: BoxFit.cover,
        ),
      ),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          gradient: LinearGradient(
            colors: [Colors.black.withOpacity(0.8), Colors.black.withOpacity(0.1), Colors.transparent],
            begin: Alignment.bottomCenter,
            end: Alignment.topCenter,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(g.month.toUpperCase(), style: TextStyle(color: Colors.tealAccent.shade400, fontSize: 10, fontWeight: FontWeight.w900, letterSpacing: 2)),
            const SizedBox(height: 6),
            Text(g.label, style: const TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.w900, height: 1.2)),
            const SizedBox(height: 8),
            Row(
              children: [
                Icon(Icons.location_on, color: Colors.tealAccent.shade400, size: 14),
                const SizedBox(width: 4),
                Text(g.location, style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w600)),
                const SizedBox(width: 10),
                const Text("•", style: TextStyle(color: Colors.white70, fontSize: 12, fontWeight: FontWeight.w600)),
                const SizedBox(width: 10),
                Icon(Icons.people, color: Colors.tealAccent.shade400, size: 14),
                const SizedBox(width: 4),
                Text("${g.attended} attended", style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w600)),
              ],
            )
          ],
        ),
      ),
    );
  }

  Widget _galleryGridItem(GalleryItem g) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white, width: 3),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.08), blurRadius: 10, offset: const Offset(0, 5))
        ],
        image: DecorationImage(
          image: NetworkImage(getFullImageUrl(g.image)),
          fit: BoxFit.cover,
        ),
      ),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(13),
          gradient: LinearGradient(
            colors: [Colors.black.withOpacity(0.8), Colors.transparent],
            begin: Alignment.bottomCenter,
            end: Alignment.topCenter,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(g.month.toUpperCase(), style: TextStyle(color: Colors.tealAccent.shade400, fontSize: 8, fontWeight: FontWeight.w900, letterSpacing: 1.5)),
            const SizedBox(height: 4),
            Text(g.label, maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.w900)),
            const SizedBox(height: 4),
            Row(
              children: [
                Expanded(child: Text(g.location, maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(color: Colors.white70, fontSize: 9, fontWeight: FontWeight.w600))),
              ],
            )
          ],
        ),
      ),
    );
  }
}
