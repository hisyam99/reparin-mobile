import 'package:flutter/material.dart';

class SearchResultsView extends StatelessWidget {
  final String query;
  final List<Map<String, dynamic>> services;

  const SearchResultsView({
    super.key, 
    required this.query, 
    required this.services
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Search Results for "$query"'),
        backgroundColor: const Color(0xFF0093B7),
      ),
      body: services.isEmpty 
        ? Center(
            child: Text(
              'No services found in $query',
              style: const TextStyle(fontSize: 18),
            ),
          )
        : ListView.builder(
            itemCount: services.length,
            itemBuilder: (context, index) {
              var service = services[index];
              return ListTile(
                leading: Image.asset(
                  service['image'], 
                  width: 60, 
                  height: 60, 
                  fit: BoxFit.cover
                ),
                title: Text(service['title']),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(service['provider']),
                    Text(service['address'], 
                      style: const TextStyle(color: Colors.grey),
                    ),
                    Text(service['price'], 
                      style: const TextStyle(color: Colors.green),
                    ),
                  ],
                ),
                onTap: () {
                  // Optional: Navigate to service detail page
                },
              );
            },
          ),
    );
  }
}