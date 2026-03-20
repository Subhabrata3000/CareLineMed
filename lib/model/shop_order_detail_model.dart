// To parse this JSON data, do
//
//     final shopOrderDetailModel = shopOrderDetailModelFromJson(jsonString);

import 'dart:convert';

ShopOrderDetailModel shopOrderDetailModelFromJson(String str) => ShopOrderDetailModel.fromJson(json.decode(str));

String shopOrderDetailModelToJson(ShopOrderDetailModel data) => json.encode(data.toJson());

class ShopOrderDetailModel {
    int? responseCode;
    bool? result;
    String? message;
    OrderDetail? orderDetail;
    List<ProductList>? productList;

    ShopOrderDetailModel({
        this.responseCode,
        this.result,
        this.message,
        this.orderDetail,
        this.productList,
    });

    factory ShopOrderDetailModel.fromJson(Map<String, dynamic> json) => ShopOrderDetailModel(
        responseCode: json["ResponseCode"],
        result: json["Result"],
        message: json["message"],
        orderDetail: json["order_detail"] == null ? null : OrderDetail.fromJson(json["order_detail"]),
        productList: json["product_list"] == null ? [] : List<ProductList>.from(json["product_list"]!.map((x) => ProductList.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "ResponseCode": responseCode,
        "Result": result,
        "message": message,
        "order_detail": orderDetail?.toJson(),
        "product_list": productList == null ? [] : List<dynamic>.from(productList!.map((x) => x.toJson())),
    };
}

class OrderDetail {
    int? id;
    String? customerId;
    String? doctorId;
    List<dynamic>? medicinePrescription;
    String? status;
    int? totPrice;
    String? couponId;
    int? couponAmount;
    int? wallet;
    int? siteCommission;
    int? sitterAmount;
    String? paymentId;
    String? addressId;
    String? date;
    String? cancelReason;
    String? transactionId;
    String? paymentName;
    String? houseNo;
    String? address;
    String? landmark;
    int? onlineAmount;

    OrderDetail({
        this.id,
        this.customerId,
        this.doctorId,
        this.medicinePrescription,
        this.status,
        this.totPrice,
        this.couponId,
        this.couponAmount,
        this.wallet,
        this.siteCommission,
        this.sitterAmount,
        this.paymentId,
        this.addressId,
        this.date,
        this.cancelReason,
        this.transactionId,
        this.paymentName,
        this.houseNo,
        this.address,
        this.landmark,
        this.onlineAmount,
    });

    factory OrderDetail.fromJson(Map<String, dynamic> json) => OrderDetail(
        id: json["id"],
        customerId: json["customer_id"],
        doctorId: json["doctor_id"],
        medicinePrescription: json["medicine_prescription"] == null ? [] : List<dynamic>.from(json["medicine_prescription"]!.map((x) => x)),
        status: json["status"],
        totPrice: json["tot_price"],
        couponId: json["coupon_id"],
        couponAmount: json["coupon_amount"],
        wallet: json["wallet"],
        siteCommission: json["site_commission"],
        sitterAmount: json["sitter_amount"],
        paymentId: json["payment_id"],
        addressId: json["address_id"],
        date: json["date"],
        cancelReason: json["cancel_reason"],
        transactionId: json["transactionId"],
        paymentName: json["payment_name"],
        houseNo: json["house_no"],
        address: json["address"],
        landmark: json["landmark"],
        onlineAmount: json["online_amount"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "customer_id": customerId,
        "doctor_id": doctorId,
        "medicine_prescription": medicinePrescription == null ? [] : List<dynamic>.from(medicinePrescription!.map((x) => x)),
        "status": status,
        "tot_price": totPrice,
        "coupon_id": couponId,
        "coupon_amount": couponAmount,
        "wallet": wallet,
        "site_commission": siteCommission,
        "sitter_amount": sitterAmount,
        "payment_id": paymentId,
        "address_id": addressId,
        "date": date,
        "cancel_reason": cancelReason,
        "transactionId": transactionId,
        "payment_name": paymentName,
        "house_no": houseNo,
        "address": address,
        "landmark": landmark,
        "online_amount": onlineAmount,
    };
}

class ProductList {
    int? id;
    String? productImage;
    String? productName;
    String? proType;
    String? subCategoryName;
    String? categoryName;
    String? prescriptionRequire;
    PriceDetail? priceDetail;

    ProductList({
        this.id,
        this.productImage,
        this.productName,
        this.proType,
        this.subCategoryName,
        this.categoryName,
        this.prescriptionRequire,
        this.priceDetail,
    });

    factory ProductList.fromJson(Map<String, dynamic> json) => ProductList(
        id: json["id"],
        productImage: json["product_image"],
        productName: json["product_name"],
        proType: json["pro_type"],
        subCategoryName: json["sub_category_name"],
        categoryName: json["category_name"],
        prescriptionRequire: json["prescription_require"],
        priceDetail: json["price_detail"] == null ? null : PriceDetail.fromJson(json["price_detail"]),
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "product_image": productImage,
        "product_name": productName,
        "pro_type": proType,
        "sub_category_name": subCategoryName,
        "category_name": categoryName,
        "prescription_require": prescriptionRequire,
        "price_detail": priceDetail?.toJson(),
    };
}

class PriceDetail {
    String? title;
    int? price;
    int? bprice;
    int? discount;
    int? qty;

    PriceDetail({
        this.title,
        this.price,
        this.bprice,
        this.discount,
        this.qty,
    });

    factory PriceDetail.fromJson(Map<String, dynamic> json) => PriceDetail(
        title: json["title"],
        price: json["price"],
        bprice: json["bprice"],
        discount: json["discount"],
        qty: json["qty"],
    );

    Map<String, dynamic> toJson() => {
        "title": title,
        "price": price,
        "bprice": bprice,
        "discount": discount,
        "qty": qty,
    };
}
