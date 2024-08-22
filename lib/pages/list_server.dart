import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../components/server_card.dart';
import '../provider/server_list_provider.dart';

class ListServer extends StatefulWidget {
  const ListServer({Key? key}) : super(key: key);

  @override
  _ListServerState createState() => _ListServerState();
}

class _ListServerState extends State<ListServer> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() =>
        Provider.of<ServerListProvider>(context, listen: false).fetchServers());
  }

  @override
  Widget build(BuildContext context) {
    final serverListProvider = Provider.of<ServerListProvider>(context);

    return RefreshIndicator(
      onRefresh: serverListProvider.refreshServers,
      child: Center(
        child: serverListProvider.isLoading
            ? const CircularProgressIndicator()
            : serverListProvider.error != null
                ? Text('Error: ${serverListProvider.error}')
                : serverListProvider.servers == null ||
                        serverListProvider.servers!.isEmpty
                    ? const Text('No servers available')
                    : ListView.builder(
                        itemCount: serverListProvider.servers!.length,
                        itemBuilder: (context, index) {
                          return ServerCard(
                            server: serverListProvider.servers![index],
                            onUpdate: serverListProvider.refreshServers,
                          );
                        },
                      ),
      ),
    );
  }
}
