import 'package:datalock/services/map_service.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geocoding/geocoding.dart';
import '../../data/models/addresses_model.dart';
import 'package:uuid/uuid.dart';

class SaveAddressScreen extends StatefulWidget {
  final LatLng location;
  final Address? addressToEdit;

  const SaveAddressScreen({
    Key? key,
    required this.location,
    this.addressToEdit,
  }) : super(key: key);

  @override
  State<SaveAddressScreen> createState() => _SaveAddressScreenState();
}

class _SaveAddressScreenState extends State<SaveAddressScreen> {
  String _selectedType = '';
  String _address = '';
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _getAddressFromLatLng();
  }

  Future<void> _getAddressFromLatLng() async {
    try {
      List<Placemark> placemarks = await placemarkFromCoordinates(
        widget.location.latitude,
        widget.location.longitude,
      );

      if (placemarks.isNotEmpty) {
        Placemark place = placemarks[0];
        setState(() {
          _address =
              "${place.street}, ${place.locality}, ${place.administrativeArea} ${place.postalCode}";
          _isLoading = false;
        });
      }
    } catch (e) {
      print("Error getting address: $e");
      setState(() {
        _address = "${widget.location.latitude}, ${widget.location.longitude}";
        _isLoading = false;
      });
    }
  }

  Widget _buildLocationTypeButton(String type, IconData icon) {
    bool isSelected = _selectedType == type;
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFF5F5F5),
        // borderRadius: BorderRadius.circular(16),
        border: isSelected
            ? Border.all(color: const Color(0xFF88C3C6), width: 2)
            : null,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            setState(() {
              _selectedType = type;
            });
          },
          // borderRadius: BorderRadius.circular(16),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 9),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: const BoxDecoration(
                    color: Color(0xFFD7ECED),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    icon,
                    color: const Color(0xFF5A9598),
                    size: 22,
                  ),
                ),
                const SizedBox(width: 12),
                Text(
                  type,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: Colors.black,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 24),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.35,
              child: GoogleMap(
                initialCameraPosition: CameraPosition(
                  target: widget.location,
                  zoom: 15,
                ),
                markers: {
                  Marker(
                    markerId: const MarkerId('selected'),
                    position: widget.location,
                  ),
                },
                liteModeEnabled: true,
                zoomControlsEnabled: false,
                scrollGesturesEnabled: false,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.arrow_back, color: Colors.black),
                        onPressed: () => Navigator.pop(context),
                      ),
                      const Text(
                        'Select Location',
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 15),
                  const Text(
                    'Your Location',
                    style: TextStyle(
                      color: Colors.grey,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 8),
                  if (_isLoading)
                    const CircularProgressIndicator()
                  else
                    Text(
                      _address,
                      style: const TextStyle(
                        fontSize: 16,
                        color: Colors.black87,
                      ),
                    ),
                  const SizedBox(height: 5),
                  const Divider(color: Colors.grey, height: 1),
                  const SizedBox(height: 24),
                  const Text(
                    'Save As',
                    style: TextStyle(
                      color: Colors.grey,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 11),
                  Row(
                    children: [
                      Expanded(
                        child: _buildLocationTypeButton(
                            'Home', Icons.home_outlined),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _buildLocationTypeButton(
                            'Office', Icons.business_outlined),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: _buildLocationTypeButton(
                            'Others', Icons.location_on_outlined),
                      ),
                      const Expanded(child: SizedBox()),
                    ],
                  ),
                  const SizedBox(height: 32),
                  SizedBox(
                    width: double.infinity,
                    height: 56,
                    child: ElevatedButton(
                      onPressed: _selectedType.isEmpty
                    ? null
                    : () async {
                        final mapService = MapService();
                        final result = await mapService.addFavoriteAddress(
                          label: _selectedType,
                          address: _address,
                          latitude: widget.location.latitude,
                          longitude: widget.location.longitude,
                        );

                        print(result);
                        print(_selectedType + "adress" + _address + "latitude" + widget.location.latitude.toString() + "longitude" + widget.location.longitude.toString());

                        if (result['status'] == '200') {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Address saved successfully')),
                          );
                          Navigator.pop(context, true);
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text(result['message'] ?? 'Failed to save address')),
                          );
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF88C3C6),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                        elevation: 0,
                        disabledBackgroundColor: Colors.grey[300],
                      ),
                      child: const Text(
                        'Save Address',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w500,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
