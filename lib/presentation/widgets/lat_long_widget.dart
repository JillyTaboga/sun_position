import 'package:flutter/material.dart';
import 'package:sun_position/data/location_data/locatio_data_source.dart';
import 'package:sun_position/presentation/location_providers.dart';

class LatLongWidget extends StatelessWidget {
  const LatLongWidget({
    super.key,
    required this.autoLocation,
  });

  final AutoLocationState autoLocation;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 100,
      height: 60,
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(
          color: Colors.grey.shade600,
          width: 0.1,
        ),
        borderRadius: BorderRadius.circular(50),
        boxShadow: [
          BoxShadow(
            color: Colors.black12.withOpacity(0.03),
            blurRadius: 5,
            spreadRadius: 10,
          ),
          BoxShadow(
            color: Colors.black12.withOpacity(0.03),
            blurRadius: 3,
            spreadRadius: 5,
          ),
        ],
      ),
      child: Center(
        child: FittedBox(
          child: Text(
            switch (autoLocation) {
              AutoLocationData state =>
                '${state.data.$1.toStringAsFixed(2)}\n${state.data.$2.toStringAsFixed(2)}',
              AutoLocationError state => switch (state.error) {
                  LocationErrors.notAvaible => 'Indisponível',
                  LocationErrors.notPermited => 'Permissão negada',
                  LocationErrors.unknown => 'Erro desconhecido',
                },
              AutoLocationLoading _ => 'Carregando...',
            },
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }
}
