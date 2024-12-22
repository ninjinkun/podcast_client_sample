import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:provider/provider.dart';
import '../providers/podcast_provider.dart';
import '../widgets/podcast_list_item.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _searchController = TextEditingController();
  String _searchTerm = 'technology';

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<PodcastProvider>(context, listen: false)
          .searchPodcasts(_searchTerm);
    });
  }

  void _search() {
    setState(() {
      _searchTerm = _searchController.text.trim();
    });
    Provider.of<PodcastProvider>(context, listen: false)
        .searchPodcasts(_searchTerm);
  }

  @override
  Widget build(BuildContext context) {
    return PlatformScaffold(
      appBar: PlatformAppBar(
        title: Text('Podcast Client'),
      ),
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.all(8.0),
            child: PlatformTextField(
              controller: _searchController,
              material: (_, __) => MaterialTextFieldData(
                decoration: InputDecoration(
                  labelText: 'Search Podcasts',
                  suffixIcon: IconButton(
                    icon: Icon(Icons.search),
                    onPressed: _search,
                  ),
                ),
              ),
              cupertino: (_, __) => CupertinoTextFieldData(
                placeholder: 'Search Podcasts',
                suffix: IconButton(
                  icon: Icon(CupertinoIcons.search),
                  onPressed: _search,
                ),
              ),
            ),
          ),
          Expanded(
            child: Consumer<PodcastProvider>(
              builder: (context, provider, child) {
                if (provider.isLoading) {
                  return Center(child: PlatformCircularProgressIndicator());
                } else if (provider.errorMessage.isNotEmpty) {
                  return Center(child: Text(provider.errorMessage));
                } else if (provider.podcasts.isEmpty) {
                  return Center(child: Text('No podcasts found.'));
                } else {
                  return ListView.builder(
                    itemCount: provider.podcasts.length,
                    itemBuilder: (context, index) {
                      return PodcastListItem(podcast: provider.podcasts[index]);
                    },
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}