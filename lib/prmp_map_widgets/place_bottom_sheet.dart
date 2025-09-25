import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:pikquick/prmp_map_widgets/prmp_map_cubit.dart';
import 'package:pikquick/prmp_map_widgets/prmp_map_state.dart';

class PlaceBottomSheet extends StatefulWidget {
  const PlaceBottomSheet({super.key});

  @override
  State<PlaceBottomSheet> createState() => _PlaceBottomSheetState();
}

class _PlaceBottomSheetState extends State<PlaceBottomSheet> {
  final _searchController = TextEditingController();
  Timer? _debounce;
  late final PrmpMapCubit _cubit;

  @override
  void initState() {
    super.initState();
    _cubit = context.read<PrmpMapCubit>();
  }

  @override
  void dispose() {
    _debounce?.cancel();
    _searchController.dispose();
    super.dispose();
  }

  void _onSearchChanged(String input) {
    if (_debounce?.isActive ?? false) _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () {
      _cubit.autocompleteSearch(input);
    });
  }

  @override
  Widget build(BuildContext context) {
    final space = SizedBox(height: 12);

    return DraggableScrollableSheet(
      initialChildSize: 0.3,
      minChildSize: 0.25,
      maxChildSize: 0.6,
      snap: false,
      expand: false,
      builder: (context, controller) {
        return SafeArea(
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 24),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black26,
                  blurRadius: 6,
                  offset: const Offset(0, -2),
                ),
              ],
            ),
            child: ListView(
              controller: controller,
              shrinkWrap: true,
              children: [
                space,
                Center(
                  child: Container(
                    height: 4,
                    width: 80,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        color: Colors.black.withOpacity(.2)),
                  ),
                ),
                space,
                Center(
                  child: Text(
                    'Set your location',
                    style: TextStyle(fontWeight: FontWeight.w500),
                  ),
                ),
                space,
                Center(
                  child: Text('Tap a point on the map to select the location'),
                ),
                space,
                Divider(
                  height: 1,
                  color: Colors.grey.withOpacity(.3),
                ),
                space,
                SizedBox(
                  height: 40,
                  child: TextField(
                    controller: _searchController,
                    cursorColor: Colors.blueAccent,
                    decoration: InputDecoration(
                      hintText: "Enter pickup location",
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(
                          color: Colors.grey.withOpacity(.3),
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(
                          color: Colors.grey.withOpacity(.3),
                        ),
                      ),
                      suffixIcon: Icon(Icons.search),
                      contentPadding: EdgeInsets.symmetric(
                        horizontal: 10,
                      ),
                    ),
                    onChanged: _onSearchChanged,
                  ),
                ),
                space,
                BlocConsumer<PrmpMapCubit, PrmpMapState>(
                    listenWhen: (previous, current) =>
                        previous.address != current.address,
                    listener: (context, state) {
                      _searchController.text = state.address?.fullAddress ?? '';
                    },
                    builder: (context, state) {
                      return Column(
                        children: [
                          ...ListTile.divideTiles(
                              color: Colors.grey.withOpacity(.3),
                              // withOpacity( .3),
                              tiles: [
                                ...state.places.map((data) {
                                  final place = data as Map<String, dynamic>;
                                  final selected = place['description'] ==
                                      state.address?.description;

                                  return ListTile(
                                    title: Text(place['description']),
                                    selected: selected,
                                    selectedColor: Colors.blueAccent,
                                    onTap: () => _cubit.selectPlace(
                                      place['place_id'],
                                      place['description'],
                                    ),
                                  );
                                }),
                              ])
                        ],
                      );
                    }),
                space,
                BlocBuilder<PrmpMapCubit, PrmpMapState>(
                    builder: (context, state) {
                  return MaterialButton(
                    onPressed: state.address != null
                        ? () {
                            context.pop(state.address);
                            context.pop(state.address);
                            _cubit.clear();
                          }
                        : null,
                    height: 45,
                    disabledColor: Colors.blueAccent.withOpacity(.4),
                    color: Colors.blueAccent,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                    child: Text(
                      'Confirm Location',
                      style: TextStyle(color: Colors.white),
                    ),
                  );
                })
              ],
            ),
          ),
        );
      },
    );
  }
}
