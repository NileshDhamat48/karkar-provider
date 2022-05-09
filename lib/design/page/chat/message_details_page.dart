import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';
import 'package:karkar_provider_app/constants/all_imports.dart';
import 'package:karkar_provider_app/constants/app_strings.dart';
import 'package:karkar_provider_app/design/page/chat/firebase_utility.dart';
import 'package:karkar_provider_app/design/page/chat/location_picker.dart';
import 'package:karkar_provider_app/design/widget/chat_image_message_view.dart';
import 'package:karkar_provider_app/design/widget/chat_payment_message_view.dart';
import 'package:karkar_provider_app/design/widget/chat_text_message_view.dart';
import 'package:karkar_provider_app/design/widget/dialog.dart';
import 'package:karkar_provider_app/design/widget/text_field_widget.dart';
import 'package:karkar_provider_app/l10n/l10n.dart';
import 'package:karkar_provider_app/network/api_manager/api_manager.dart';
import 'package:karkar_provider_app/network/models/user_data.dart';
import 'package:karkar_provider_app/network/models/user_location.dart';
import 'package:karkar_provider_app/network/response/common_response.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../widget/full_screen_image_slider.dart';

class MessagesDetailsPage extends StatefulWidget {
  const MessagesDetailsPage({
    Key? key,
    required this.otherUserID,
    required this.otherUserName,
    required this.otherUserImage,
    required this.fromNotification,
  }) : super(key: key);

  final int otherUserID;
  final String otherUserName;
  final String otherUserImage;
  final bool fromNotification;

  @override
  State<MessagesDetailsPage> createState() => _MessagesDetailsPageState();
}

class _MessagesDetailsPageState extends State<MessagesDetailsPage> {
  TextEditingController messagecontroller = TextEditingController();
  FocusNode messageFN = FocusNode();
  UserData? userData;
  String groupChatId = '';
  String userAID = '';
  String userBID = '';
  Locale? locale;
  bool isLoading = false;
  bool isImageUploading = false;
  final casualController = TextEditingController();
  final moneyController = TextEditingController();
  final casualFn = FocusNode();
  final moneyFn = FocusNode();
  bool showSendMoneyView = false;

  @override
  void initState() {
    super.initState();
    // sharedPreferences.setBool(AppStrings.showChatNotification, false);
    getpref();
  }

  getpref() async {
    final userResponse = await Utility.getUserPref();

    locale = await Utility.getLangauge();
    if (userResponse?.data?.id != null) {
      userData = userResponse?.data;
    }
    getChatIDS();
  }

  getChatIDS() {
    if (widget.otherUserID < (userData?.id ?? 0)) {
      groupChatId = '${widget.otherUserID}-${(userData?.id ?? 0)}';
      userAID = (userData?.id ?? 0).toString();
      userBID = widget.otherUserID.toString();
    } else {
      groupChatId = '${(userData?.id ?? 0)}-${widget.otherUserID}';
      userAID = widget.otherUserID.toString();
      userBID = (userData?.id ?? 0).toString();
    }
    _notify();
  }

  _notify() {
    if (mounted) setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldbgcolor,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: AppColors.bodybgcolor,
        leading: BackArrowWidget(
          onTap: () {
            Navigator.pop(context);
          },
        ),
        title: Row(
          // mainAxisAlignment: MainAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(40),
              child: SizedBox(
                height: 50,
                width: 50,
                child: Utility.imageLoader(
                  widget.otherUserImage,
                  AppStrings.addSupport,
                  BoxFit.cover,
                ),
              ),
            ),
            const SizedBox(
              width: 15,
            ),
            Flexible(
              child: Text(
                widget.otherUserName,
                maxLines: 1,
                style: const TextStyle(color: AppColors.whiteColor, fontSize: 15),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
        actions: [IconButton(onPressed: () {}, icon: const Icon(Icons.cached_rounded))],
      ),
      body: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
        stream: FirebaseUtility().getMesaageAll(
          groupId: groupChatId,
          myId: (userData?.id?.toString() ?? '0'),
        ),
        builder: (context, snapshot) {
          isLoading = snapshot.connectionState == ConnectionState.waiting;
          return Stack(
            children: [
              if (snapshot.data?.docs.isEmpty ??
                  true && snapshot.connectionState == ConnectionState.waiting && !isLoading)
                Center(
                  child: Text(
                    AppLocalizations.of(context).noChat,
                    style: const TextStyle(
                      fontSize: 16,
                      color: AppColors.whiteColor,
                    ),
                  ),
                ),
              ListView.builder(
                padding: const EdgeInsets.only(bottom: 80, top: 10, left: 10, right: 10),
                reverse: true,
                itemCount: snapshot.data?.docs.length ?? 0,
                itemBuilder: (context, index) {
                  return itemview(snapshot.data?.docs[index].data());
                },
              ),
              if (showSendMoneyView) sendMoneyRequestView(),
              if (isLoading) Utility.progress(context),
              if (isImageUploading) Utility.progress(context)
            ],
          );
        },
      ),
      bottomSheet: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              GestureDetector(
                onTap: () {
                  showSendMoneyView = true;
                  _notify();
                },
                child: Container(
                  decoration: BoxDecoration(color: AppColors.blackColor, borderRadius: BorderRadius.circular(10)),
                  margin: const EdgeInsets.all(4),
                  height: 50,
                  width: 50,
                  child: const Center(
                      child: Icon(
                    Icons.attach_money,
                    color: AppColors.whiteColor,
                    size: 20,
                  )),
                ),
              ),
              Flexible(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4),
                  child: TextFormField(
                    controller: messagecontroller,
                    focusNode: messageFN,
                    keyboardType: TextInputType.text,
                    maxLines: 1,
                    decoration: InputDecoration(
                      fillColor: AppColors.greyColor.withOpacity(0.3),
                      border: InputBorder.none,
                      filled: true,
                      suffixIcon: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          GestureDetector(
                            onTap: () async {
                              UserLocation? loaction = await Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const LocationPicker(),
                                ),
                              );
                              if (loaction?.lat != null && loaction?.lng != null) {
                                onSendMessage(
                                  type: AppStrings.messageTypeLocation,
                                  location: GeoPoint(
                                    loaction!.lat!,
                                    loaction.lng!,
                                  ),
                                );
                              }
                            },
                            child: Icon(
                              Icons.location_on,
                              color: AppColors.greyText,
                              size: 25,
                            ),
                          ),
                          const SizedBox(
                            width: 3,
                          ),
                          GestureDetector(
                            onTap: () {
                              uploadDialogPopup();
                            },
                            child: Icon(
                              Icons.image,
                              color: AppColors.greyText,
                              size: 25,
                            ),
                          ),
                          const SizedBox(
                            width: 3,
                          )
                        ],
                      ),
                      hintText: 'Type your message',
                    ),
                  ),
                ),
              ),
              GestureDetector(
                onTap: () {
                  if (messagecontroller.text.trim() != '') {
                    onSendMessage(
                      type: AppStrings.messageTypeText,
                      message: messagecontroller.text.trim(),
                    );
                    messagecontroller.clear();
                  }
                },
                child: Container(
                  decoration: BoxDecoration(color: AppColors.blackColor, borderRadius: BorderRadius.circular(10)),
                  margin: const EdgeInsets.all(4),
                  height: 50,
                  width: 50,
                  child: const Center(
                      child: Icon(
                    Icons.send,
                    color: AppColors.whiteColor,
                    size: 20,
                  )),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  itemview(Map<String, dynamic>? data) {
    if (data?['type'] == AppStrings.messageTypeImage) {
      return ChatImageMessageView(
        isOtherUser: data?['id_from'] != (userData?.id?.toString() ?? '0'),
        image: data?['message'] ?? '',
        time: Utility().getDateTimeFromTimestamp(data?['timestamp']),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => FullScrennImageSlider(image: data?['message'] ?? ''),
            ),
          );
        },
      );
    }
    if (data?['type'] == AppStrings.messageTypeLocation) {
      final GeoPoint location = data?['location'];

      return ChatImageMessageView(
        isOtherUser: data?['id_from'] != (userData?.id?.toString() ?? '0'),
        image: Utility.getMapUrl(location.latitude.toString(), location.longitude.toString()),
        time: Utility().getDateTimeFromTimestamp(data?['timestamp']),
        onTap: () {
          Utility.urlLauncher(AppStrings.mapUrl(location.latitude.toString(), location.longitude.toString()));
        },
      );
    }
    if (data?['type'] == AppStrings.messageTypePayment) {
      return ChatPaymentMessageView(
        isOtherUser: data?['id_from'] != (userData?.id?.toString() ?? '0'),
        message: data?['message'] ?? '',
        price: data?['price'] ?? '',
        paymentStatus: getPaymentStatusString(status: data?['payment_status']),
        time: Utility().getDateTimeFromTimestamp(data?['timestamp']),
      );
    }
    return ChatTextMessageView(
      message: data?['message'] ?? '',
      time: Utility().getDateTimeFromTimestamp(data?['timestamp']),
      isOtherUser: data?['id_from'] != (userData?.id?.toString() ?? '0'),
    );
  }

  uploadDialogPopup() {
    DailogBox.cameraAndImagePickerDialog(
      context: context,
      onCameraTap: () {
        Navigator.pop(context);
        getImageFromCamera();
      },
      onGalleryTap: () async {
        Navigator.pop(context);
        final pickImageFilePath = await Utility.pickImageFromStorage();
        if (pickImageFilePath != null) {
          isImageUploading = true;
          _notify();
          uploadFile(pickImageFilePath);
          return;
        }
        if (pickImageFilePath == null) {
          Utility.showToast(msg: AppLocalizations.of(context).unabletoPickImage);
        }
      },
    );
  }

  getImageFromCamera() {
    Utility.checkPermission(
      onSucess: () async {
        final pickedImage = await ImagePicker().pickImage(source: ImageSource.camera);

        if (pickedImage != null) {
          isImageUploading = true;
          _notify();
          uploadFile(File(pickedImage.path));
          return;
        }
        if (pickedImage == null) {
          Utility.showToast(msg: AppLocalizations.of(context).unabletoPickImage);
        }
      },
      permission: Permission.camera,
    );
  }

  Future uploadFile(File image) async {
    await FirebaseUtility().uploadImage("Images", image, userData?.id.toString() ?? '0').then(
      (downloadurl) {
        isImageUploading = false;
        _notify();
        if (downloadurl != null) {
          onSendMessage(
            type: AppStrings.messageTypeImage,
            message: downloadurl,
          );
        } else {
          Utility.showToast(msg: 'Something went wrong');
        }
      },
    );
  }

  sendMoneyRequestView() {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Container(
        margin: const EdgeInsets.only(bottom: 65),
        decoration: BoxDecoration(
          color: AppColors.bookingDetailscolor,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(
              height: 5,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                InkWell(
                  onTap: () {
                    casualController.clear();
                    moneyController.clear();
                    showSendMoneyView = false;
                    _notify();
                  },
                  child: const Icon(
                    Icons.close,
                    size: 25,
                  ),
                ),
                const SizedBox(
                  width: 5,
                ),
              ],
            ),
            TextFieldWidget(
              hintText: '',
              textFieldLable: 'Casual',
              // label: 'Casual',
              controller: casualController,
              keyboardType: TextInputType.text,
              focusNode: casualFn,
              enabled: true,
              labelStyle: const TextStyle(color: AppColors.blackColor),
              padding: const EdgeInsets.symmetric(horizontal: 10),
              customBorder: const UnderlineInputBorder(
                borderSide: BorderSide(
                  color: AppColors.blackColor,
                ),
              ),
            ),
            Row(
              children: [
                Flexible(
                  child: TextFieldWidget(
                    hintText: '',
                    textFieldLable: 'Price (€)',
                    labelStyle: const TextStyle(color: AppColors.blackColor),
                    controller: moneyController,
                    keyboardType: TextInputType.number,
                    focusNode: moneyFn,
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    customBorder: const UnderlineInputBorder(
                      borderSide: BorderSide(
                        color: AppColors.blackColor,
                      ),
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    if (casualController.text.trim() == '') {
                      Utility.showToast(msg: 'Please Enter Casual');
                    } else if (moneyController.text.trim() == '') {
                      Utility.showToast(msg: 'Please Enter Price');
                    } else {
                      onSendMessage(
                        type: AppStrings.messageTypePayment,
                        message: casualController.text.trim(),
                        price: moneyController.text.trim(),
                        paymentStatus: AppStrings.chatPaymentStatusPending,
                      );
                      casualController.clear();
                      moneyController.clear();
                      showSendMoneyView = false;
                      _notify();
                    }
                  },
                  child: Container(
                    decoration: BoxDecoration(color: AppColors.blackColor, borderRadius: BorderRadius.circular(10)),
                    margin: const EdgeInsets.all(4),
                    height: 50,
                    width: 50,
                    child: const Center(
                        child: Icon(
                      Icons.send,
                      color: AppColors.whiteColor,
                      size: 20,
                    )),
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 5,
            )
          ],
        ),
      ),
    );
  }

  onSendMessage({
    required String type,
    String? message,
    String? fileUrl,
    GeoPoint? location,
    String? price,
    String? paymentStatus,
  }) async {
    await FirebaseUtility().enterDatainUsersChatListCollection(
      chattype: type,
      useraId: userAID,
      userbId: userBID,
      groupchatid: groupChatId,
      myid: (userData?.id?.toString() ?? '0'),
      message: getNotificationMessage(message: message ?? '', type: type),
    );
    await FirebaseUtility()
        .sendChatData(
      myId: (userData?.id?.toString() ?? '0'),
      otherId: widget.otherUserID.toString(),
      groupChatId: groupChatId,
      fileUrl: fileUrl,
      type: type,
      message: message,
      location: location,
      paymentStatus: paymentStatus,
      price: price,
    )
        .then(
      (value) {
        sendNotification(
          message: message ?? '',
          type: type,
        );
      },
    );
  }

  sendNotification({
    required String message,
    required String type,
  }) async {
    var request = <String, dynamic>{};
    request['user_id'] = widget.otherUserID.toString();
    request['message'] = getNotificationMessage(
      message: message,
      type: type,
    );

    CommonResponse.fromJson(await ApiManager(context).postCall(AppStrings.chatSendNotification, request));
  }

  String getNotificationMessage({
    required String message,
    required String type,
  }) {
    if (type == AppStrings.messageTypeText) {
      return message;
    }
    if (type == AppStrings.messageTypeImage) {
      return 'Image';
    }
    if (type == AppStrings.messageTypeLocation) {
      return 'Location';
    }
    if (type == AppStrings.messageTypePayment) {
      return 'Payment Request';
    }
    return message;
  }

  String getPaymentStatusString({
    required String status,
  }) {
    if (status == AppStrings.chatPaymentStatusPending) {
      return 'Pending';
    }
    if (status == AppStrings.chatPaymentStatusPaid) {
      return 'Paid';
    }

    return 'Pending';
  }
}
