import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:retrofit/http.dart';
import 'package:retrofit_crud/model/shop.dart';
part 'api_repository.g.dart';

final apiFutureProvider = FutureProvider((ref) async {
  final apiService = ref.read(apiServiceProvider);
  return apiService.getShops();
});

final apiServiceProvider = Provider((ref) => ApiRepository(Dio(BaseOptions(contentType: "application/json"))));

@RestApi(baseUrl: 'http://localhost:3001/shop')
abstract class ApiRepository {
  factory ApiRepository(Dio dio, {String baseUrl}) = _ApiRepository;

  @GET('/')
  Future<List<Shop>> getShops();
  // エンドポイントに、nameとaddressを送信する
  @POST('/')
  Future<Shop> postShop(@Body() Shop shop);

  // 更新するメソッド
  @PUT('/{id}')
  Future<Shop> putShop(@Path('id') int postID, @Body() Shop shop);

  // 削除するメソッド
  @DELETE('/{id}')
  Future<void> deleteShop(@Path('id') int postID);
}