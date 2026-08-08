import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/app_state.dart';

class ProfileScreen extends StatelessWidget {
  static const routeName = '/profile';
  @override
  Widget build(BuildContext context) {
    final app = Provider.of<AppState>(context);

    String level() {
      if (app.ecoXp >= 1000) return 'ECO MASTER';
      if (app.ecoXp >= 600) return 'Guardião do Consumo';
      if (app.ecoXp >= 300) return 'Consumidor Sustentável';
      if (app.ecoXp >= 100) return 'Consumidor Consciente';
      return 'Consumidor Iniciante';
    }

    return Scaffold(
      appBar: AppBar(title: Text('Perfil')),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            CircleAvatar(radius: 36, child: Icon(Icons.person)),
            SizedBox(height: 12),
            Text('Usuário', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            SizedBox(height: 6),
            Text(level()),
            SizedBox(height: 16),
            ListTile(title: Text('ECO XP'), trailing: Text('${app.ecoXp}')),
            ListTile(title: Text('Dinheiro preservado'), trailing: Text('${app.moneyPreserved.toStringAsFixed(2)}')),
            ListTile(title: Text('Compras evitadas'), trailing: Text('${app.purchasesAvoided}')),
          ],
        ),
      ),
    );
  }
}
