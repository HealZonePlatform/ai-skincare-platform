# TODO - Mobile App (Flutter)

## Ki?n trúc ?ng d?ng
- [x] Tách riêng rõ ràng các layer (presentation, domain, data)
- [x] Thêm l?p use case trong domain layer theo clean architecture
- [x] T?o interface/abstract class cho các service d? d? test & mock

## X? lý token t? d?ng
- [x] Thêm interceptor t? d?ng g?n Authorization header
- [x] Tri?n khai co ch? refresh token t? d?ng khi access token h?t h?n
- [x] X? lý tru?ng h?p refresh token th?t b?i (dang xu?t ngu?i dùng)

## Qu?n lý API
- [x] Thay th? hard-code base URL b?ng c?u hình môi tru?ng linh ho?t
- [x] Thêm API interceptors d? x? lý request/response chung
- [x] Tri?n khai retry mechanism cho các request th?t b?i
- [x] Thêm c?u hình timeout linh ho?t cho các lo?i request khác nhau

## X? lý l?i toàn c?c
- [x] Thi?t k? h? th?ng x? lý l?i toàn c?c v?i UI thông báo thân thi?n
- [x] T?o custom exception handler cho các lo?i l?i khác nhau
- [x] Hi?n th? thông báo l?i phù h?p v?i t?ng ng? c?nh

## Ki?m th?
- [x] Thêm unit test cho các l?p business logic
- [x] Vi?t widget test cho các màn hình chính
- [x] T?o integration test cho các flow chính (dang nh?p, phân tích da, v.v.)
- [x] Thi?t l?p mock API cho vi?c test

## T?i uu hi?u su?t
- [x] Thêm lazy loading cho các danh sách dài (l?ch s? phân tích da)
- [x] T?i uu pagination cho danh sách l?ch s?
- [x] C?i thi?n hi?u su?t hi?n th? hình ?nh l?n
- [x] Áp d?ng caching hi?u qu? hon cho d? li?u thu?ng xuyên truy c?p

## Ki?m tra và xác th?c d?u vào
- [x] Thêm h? th?ng validation t?p trung cho form
- [x] Xác th?c d? li?u d?u vào tru?c khi g?i lên API
- [x] Hi?n th? thông báo l?i validation thân thi?n v?i ngu?i dùng

## Logging và giám sát
- [x] Thêm h? th?ng logging toàn c?c
- [x] Tích h?p analytics (Google Analytics) d?ng lightweight
- [x] Ghi log l?i và hành vi ngu?i dùng d? phân tích
- [x] Thi?t l?p crash reporting (Firebase Crashlytics)

## C?u hình môi tru?ng
- [x] Thêm co ch? c?u hình riêng cho các môi tru?ng dev/staging/prod
- [x] T?o file c?u hình riêng bi?t cho t?ng môi tru?ng
- [x] T? d?ng ch?n API base URL theo môi tru?ng

## Tái s? d?ng mã ngu?n
- [x] Thi?t k? l?i m?t s? widget d? tang kh? nang tái s? d?ng
- [x] T?o thu vi?n widget chung cho toàn ?ng d?ng
- [x] Tái s? d?ng các component UI gi?a các màn hình

## Tính nang m?i c?n phát tri?n
- [x] Thêm tính nang da ngôn ng? (i18n)
- [x] C?i thi?n tr?i nghi?m ngu?i dùng v?i animation/micro-interaction
- [x] Thêm co ch? offline-first cho m?t s? tính nang co b?n
- [x] Tri?n khai push notification cho l?i nh?c cham sóc da
- [x] Thêm tính nang chia s? k?t qu? phân tích da

## T?i uu UI/UX
- [x] C?i thi?n giao di?n màn hình loading
- [x] Thêm skeleton screen cho tr?i nghi?m mu?t mà hon
- [x] T?i uu layout cho các kích thu?c màn hình khác nhau
- [x] C?i thi?n tr?i nghi?m ngu?i dùng trong quá trình quét da

## B?o m?t
- [x] Ki?m tra l?i ti?m ?n có th? b? khai thác (insecure storage, v.v.)
- [x] Thêm ki?m tra b?o m?t cho các API endpoints
- [x] Ð?m b?o d? li?u nh?y c?m du?c mã hóa dúng cách
