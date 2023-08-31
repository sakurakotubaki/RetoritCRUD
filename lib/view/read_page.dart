import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:retrofit_crud/model/shop.dart';
import 'package:retrofit_crud/repository/api_repository.dart';

final apiServiceProvider = Provider<ApiRepository>((ref) {
  final dio = Dio();
  dio.interceptors
      .add(LogInterceptor(responseBody: true, requestBody: true)); // ここに追加
  return ApiRepository(dio);
});

class ReadPage extends ConsumerWidget {
  const ReadPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final fetchApi = ref.watch(apiFutureProvider);
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
              onPressed: () async {
                final apiService = ref.read(apiServiceProvider);
                final newShop = Shop(
                    postName: 'post test',
                    postAddress: 'post address',
                    created_at: DateTime.now(),
                    updated_at: DateTime.now());
                final response = await apiService.postShop(newShop);

                print("Successfully posted the shop: ${response.postName}");
                // ignore: unused_result
                ref.refresh(apiFutureProvider);
              },
              icon: const Icon(Icons.add))
        ],
        title: const Text('Read Page'),
      ),
      body: Center(
        child: fetchApi.when(
          data: (data) {
            return ListView.builder(
              itemCount: data.length,
              itemBuilder: (context, index) {
                return Container(
                  margin: const EdgeInsets.all(10),
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Column(
                    children: [
                      Text(data[index].postName),
                      Text(data[index].postAddress),
                      Text(data[index].created_at!.toIso8601String()),
                      Text(data[index].updated_at!.toIso8601String()),
                      Row(
                        children: [
                          IconButton(
                            onPressed: () async {
                              // final apiService = ref.read(apiServiceProvider);
                              // try {
                              //   final putShop = Shop(
                              //       postName: '2222!!!',
                              //       postAddress: '444444!!!',
                              //       created_at: DateTime.now(),
                              //       updated_at: DateTime.now());
                              //   await ref
                              //       .read(apiServiceProvider)
                              //       .putShop(data[index].postID, putShop);

                              //   print('送信');
                              //   // ignore: unused_result
                              //   ref.refresh(apiFutureProvider);
                              // } catch (e) {
                              //   print('-------------');
                              //   if (e is DioException) {
                              //     print("Error: ${e.message}");
                              //     print("Error: ${e.error}");
                              //     print(e.response!.data);
                              //     print(e.response!.headers);
                              //     print(e.response!.requestOptions);
                              //   }
                              // }
                              try {
                                final newShop = Shop(
                                    postName: 'put 000000000',
                                    postAddress: 'put 0000000000',
                                    created_at: DateTime.now(),
                                    updated_at: DateTime.now());

                                final response = await ref
                                    .read(apiServiceProvider)
                                    .putShop(data[index].postID, newShop);
                                // ignore: unused_result
                                await ref.refresh(apiFutureProvider);
                                if (response is Map<String, dynamic>) {
                                  print(
                                      "Successfully updated the shop: ${response.postName}");
                                } else {
                                  print("Unexpected response: $response");
                                }
                              } catch (e) {
                                print('Error while updating the shop: $e');
                              }
                            },
                            icon: const Icon(Icons.edit),
                          ),
                          IconButton(
                            onPressed: () async {
                              try {
                                await ref
                                    .read(apiServiceProvider)
                                    .deleteShop(data[index].postID);
                                // ignore: unused_result
                                ref.refresh(apiFutureProvider);
                              } catch (e) {
                                throw e.toString();
                              }
                            },
                            icon: const Icon(Icons.delete),
                          ),
                        ],
                      ),
                    ],
                  ),
                );
              },
            );
          },
          loading: () => const CircularProgressIndicator(),
          error: (error, stackTrace) => Text(error.toString()),
        ),
      ),
    );
  }
}
